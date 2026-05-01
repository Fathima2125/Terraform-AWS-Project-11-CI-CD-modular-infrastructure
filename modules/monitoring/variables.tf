variable "asg_name" {
  description = "Auto Scaling Group Name"
  type        = string
}

variable "alb_arn_suffix" {
  description = "ALB ARN suffix"
  type        = string
}

variable "alert_email" {
  description = "Email for alerts"
  type        = string
}