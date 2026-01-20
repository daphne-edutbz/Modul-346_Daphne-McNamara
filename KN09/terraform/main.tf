provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "db_sg" {
  name        = "kn09-db-terraform"
  description = "Security Group for KN09 DB"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kn09-db"
  }
}

resource "aws_instance" "db" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.db_sg.id]

  user_data = file("cloud-init-db.yaml")

  tags = {
    Name = "KN09-DB-Terraform"
  }
}
