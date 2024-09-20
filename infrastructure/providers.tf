terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.67.0"  # Update this line
    }
  }
}

provider "aws" {
  region = "us-west-2"  # Replace with your desired region
}