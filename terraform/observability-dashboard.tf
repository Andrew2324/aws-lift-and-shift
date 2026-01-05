resource "aws_cloudwatch_dashboard" "liftshift" {
  dashboard_name = "liftshift-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric",
        x      = 0,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          region      = var.aws_region
          annotations = {}
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.legacy_app.id]
          ]
          period = 60
          stat   = "Average"
          title  = "CPU Utilization"
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          region      = var.aws_region
          annotations = {}
          metrics = [
            ["CWAgent", "mem_used_percent", "InstanceId", aws_instance.legacy_app.id]
          ]
          period = 60
          stat   = "Average"
          title  = "Memory Used % (CWAgent)"
        }
      },
      {
        type   = "metric",
        x      = 0,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          region      = var.aws_region
          annotations = {}
          metrics = [
            ["CWAgent", "disk_used_percent", "InstanceId", aws_instance.legacy_app.id]
          ]
          period = 60
          stat   = "Average"
          title  = "Disk Used % (CWAgent)"
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          region      = var.aws_region
          annotations = {}
          metrics = [
            ["AWS/EC2", "StatusCheckFailed", "InstanceId", aws_instance.legacy_app.id]
          ]
          period = 60
          stat   = "Maximum"
          title  = "Status Check Failed"
        }
      }
    ]
  })
}
