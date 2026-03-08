terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {

  region = "us-east-1"

}

resource "aws_instance" "example" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t3.micro"
  tags = {
    "Name" = "Terraform-Example"
  }
}
