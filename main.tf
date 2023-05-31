
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  profile = "terraform-user"
}

# stores terraform state files in S3
terraform {
  backend "s3" {
    bucket = "safo-terraform-remote-state"
    key    = "terraform-tfstate.dev"
    region = "us-east-1"
    profile = "terraform-user"

  }
}
