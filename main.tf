terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {

  region = "us-east-1"

}

variable "server_port" {

  description = "Port number for the HTTP server"
  type        = number
  default     = 8080

}

resource "aws_instance" "example" {
  ami                         = "ami-04505e74c0741db8d"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.instance.id]
  user_data                   = <<-EOF
              #!/bin/bash
              echo "Witaj, świecie" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  user_data_replace_on_change = true
  tags = {
    "Name" = "Terraform-Example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "Public IP address of the EC2 instance"
}
