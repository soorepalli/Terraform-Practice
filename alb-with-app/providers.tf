terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25"
    }
  }
}

provider "aws" {
  # region = "us-east-1"
  region  = var.region
  profile = "default"

}