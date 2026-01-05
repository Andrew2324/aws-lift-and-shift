output "alerts_topic_arn" {
  value = aws_sns_topic.liftshift_alerts.arn
}

output "dashboard_name" {
  value = aws_cloudwatch_dashboard.liftshift.dashboard_name
}
