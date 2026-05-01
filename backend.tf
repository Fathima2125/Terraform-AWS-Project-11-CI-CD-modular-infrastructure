terraform {
  backend "s3" {
    bucket         = "fathima-terraform-state-bucket-12345"
    key            = "project5/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    use_lockfile   = true
  }
}