provider "aws" {
  region = var.aws_region
  default_tags {
    tags = { Project = "terraform-aws-portfolio", Environment = "dev", ManagedBy = "Terraform" }
  }
}
