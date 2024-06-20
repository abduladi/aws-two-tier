# Configure the AWS Provider

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0.0"
    }
  }


# Integration with HCP
  cloud {
    organization = "N26-demo"

    workspaces {
      name = "n26-demo"
    }
  }


}

provider "aws" {
  region = "us-east-1"
  # profile = "terraform"
}
