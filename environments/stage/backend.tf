terraform {
  backend "s3" {
    bucket         = "yash-terraform-prod-state-2026"
    key            = "stage/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-prod-locks"
    encrypt        = true
  }
}
