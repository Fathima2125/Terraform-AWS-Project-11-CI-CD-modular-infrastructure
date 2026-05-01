resource "aws_autoscaling_group" "asg" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1

  vpc_zone_identifier = var.subnet_ids

  target_group_arns = [var.target_group_arn]

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }
}