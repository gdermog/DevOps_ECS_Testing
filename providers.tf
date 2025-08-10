terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket = "tfstate-ecs-testing-624876161801-eu-central-1"
    key = "ecs-demo/terraform.tfstate"
    region = "eu-central-1"
  } 
  
}

provider "aws" {
  region = var.aws_region
}
