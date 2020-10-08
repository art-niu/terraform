# Bellow block is in Terraform 0.13 and later format
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
/* provider "aws" {
  region = "ca-central-1"
} */

provider "aws" {
  region                  = "ca-central-1"
  shared_credentials_file = "/Users/fei/.aws/credentials"
  profile                 = "fei"
}

# for different authentication methods, you can refer to https://registry.terraform.io/providers/hashicorp/aws/latest/docs

# Authenticate with Environment Variables
/* $ export AWS_ACCESS_KEY_ID="anaccesskey"
$ export AWS_SECRET_ACCESS_KEY="asecretkey"
$ export AWS_DEFAULT_REGION="us-west-2" */

