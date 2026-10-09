resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count = length(var.instance_ids)
  alarm_name = "terraform-web-${count.index + 1}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 300
  statistic = "Average"
  threshold = 80
  alarm_description = "CPU above 80 percent for 10 minutes"
  dimensions = { InstanceId = var.instance_ids[count.index] }
  treat_missing_data = "missing"
}
resource "aws_cloudwatch_metric_alarm" "unhealthy_targets" {
  alarm_name = "terraform-web-unhealthy-targets"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 2
  metric_name = "UnHealthyHostCount"
  namespace = "AWS/ApplicationELB"
  period = 60
  statistic = "Maximum"
  threshold = 0
  alarm_description = "At least one unhealthy ALB target"
  dimensions = {
    TargetGroup = var.target_group_arn_suffix
    LoadBalancer = var.load_balancer_arn_suffix
  }
  treat_missing_data = "missing"
}
