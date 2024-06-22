terraform {
    backend "s3" {
      bucket = "sheltr-tfstate"
      region = "us-east-1"
      key = "infra/tf/lowers.tfstate"
    }
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      CreatedBy = "sheltr-infra"
      Environment = var.environment
    }
  }
}

