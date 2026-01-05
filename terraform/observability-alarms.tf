variable "alert_email" {
  type    = string
  default = ""
}

variable "cpu_threshold"  { type = number, default = 80 }
variable "mem_threshold"  { type = number, default = 80 }
variable "disk_threshold" { type = number, default = 85 }

resource "aws_sns_topic" "liftshift_alerts" {
  name = "liftshift-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  count     = var.alert_email == "" ? 0 : 1
  topic_arn = aws_sns_topic.liftshift_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# IMPORTANT: set this local to your EC2 resource name
# Update aws_instance.<NAME> after you find it with grep/state
locals {
  legacy_instance_id = aws_instance.legacy_app.id
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed" {
  alarm_name          = "liftshift-ec2-statuscheck-failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  alarm_actions       = [aws_sns_topic.liftshift_alerts.arn]
  dimensions = { InstanceId = local.legacy_instance_id }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "liftshift-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.cpu_threshold
  alarm_actions       = [aws_sns_topic.liftshift_alerts.arn]
  dimensions = { InstanceId = local.legacy_instance_id }
}

# CWAgent metrics (CloudWatch Agent must be running)
resource "aws_cloudwatch_metric_alarm" "high_mem" {
  alarm_name          = "liftshift-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = 60
  statistic           = "Average"
  threshold           = var.mem_threshold
  alarm_actions       = [aws_sns_topic.liftshift_alerts.arn]
  dimensions = { InstanceId = local.legacy_instance_id }
}

resource "aws_cloudwatch_metric_alarm" "high_disk" {
  alarm_name          = "liftshift-high-disk"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = 60
  statistic           = "Average"
  threshold           = var.disk_threshold
  alarm_actions       = [aws_sns_topic.liftshift_alerts.arn]

  # Disk dimensions depend on how the agent reports them.
  # Start simple with just InstanceId (works for many setups).
  dimensions = { InstanceId = local.legacy_instance_id }
}
