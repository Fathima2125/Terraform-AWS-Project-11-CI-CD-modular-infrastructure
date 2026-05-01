variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "terraform-level5"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_1" {
  default = "10.0.1.0/24"
}

variable "subnet_cidr_2" {
  default = "10.0.2.0/24"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {}

variable "alert_email" {
  description = "Email for CloudWatch alerts"
  type        = string
}