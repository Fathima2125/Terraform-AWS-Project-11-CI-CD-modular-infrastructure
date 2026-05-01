# SNS Topic
resource "aws_sns_topic" "alerts" {
  name = "terraform-alerts"
}

# Email Subscription
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# EC2 CPU Alarm (ASG level)
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = "ec2-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_description = "EC2 CPU usage > 70%"
  alarm_actions     = [aws_sns_topic.alerts.arn]
}

# ALB 5XX Error Alarm
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 5

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  alarm_description = "ALB 5XX errors detected"
  alarm_actions     = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "terraform-level5-dashboard"

  dashboard_body = jsonencode({
    widgets = [

      # CPU
      {
        type = "metric",
        x = 0, y = 0, width = 12, height = 6,
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", var.asg_name]
          ],
          stat = "Average",
          period = 60,
          region = "us-east-1",
          title = "ASG CPU Utilization"
        }
      },

      # ALB Requests
      {
        type = "metric",
        x = 12, y = 0, width = 12, height = 6,
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_arn_suffix]
          ],
          stat = "Sum",
          period = 60,
          region = "us-east-1",
          title = "ALB Request Count"
        }
      },

      # Response Time
      {
        type = "metric",
        x = 0, y = 6, width = 12, height = 6,
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_arn_suffix]
          ],
          stat = "Average",
          period = 60,
          region = "us-east-1",
          title = "ALB Response Time"
        }
      },

      # 5XX Errors
      {
        type = "metric",
        x = 12, y = 6, width = 12, height = 6,
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", var.alb_arn_suffix]
          ],
          stat = "Sum",
          period = 60,
          region = "us-east-1",
          title = "ALB 5XX Errors"
        }
      },

      # HEALTH METRICS (NEW ⭐)
      {
        type = "metric",
        x = 0, y = 12, width = 12, height = 6,
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HealthyHostCount", "LoadBalancer", var.alb_arn_suffix],
            ["AWS/ApplicationELB", "UnHealthyHostCount", "LoadBalancer", var.alb_arn_suffix]
          ],
          stat = "Average",
          period = 60,
          region = "us-east-1",
          title = "ALB Health Status"
        }
      },

      # ASG CAPACITY (NEW ⭐)
      {
        type = "metric",
        x = 12, y = 12, width = 12, height = 6,
        properties = {
          metrics = [
            ["AWS/AutoScaling", "GroupDesiredCapacity", "AutoScalingGroupName", var.asg_name],
            ["AWS/AutoScaling", "GroupInServiceInstances", "AutoScalingGroupName", var.asg_name]
          ],
          stat = "Average",
          period = 60,
          region = "us-east-1",
          title = "ASG Capacity"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "ec2_logs" {
  name              = "/ec2/terraform-level5"
  retention_in_days = 7
}

resource "aws_budgets_budget" "monthly" {
  name         = "monthly-budget"
  budget_type  = "COST"
  limit_amount = "10"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold          = 80
    threshold_type     = "PERCENTAGE"
    notification_type  = "ACTUAL"

    subscriber_email_addresses = [var.alert_email]
  }
}
