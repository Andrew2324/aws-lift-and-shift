resource "aws_cloudwatch_dashboard" "liftshift" {
  dashboard_name = "liftshift-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0, y = 0, width = 12, height = 6,
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", local.legacy_instance_id]
          ],
          period = 60,
          stat   = "Average",
          title  = "CPU Utilization"
        }
      },
      {
        type = "metric",
        x    = 12, y = 0, width = 12, height = 6,
        properties = {
          metrics = [
            ["CWAgent", "mem_used_percent", "InstanceId", local.legacy_instance_id]
          ],
          period = 60,
          stat   = "Average",
          title  = "Memory Used %"
        }
      },
      {
        type = "metric",
        x    = 0, y = 6, width = 12, height = 6,
        properties = {
          metrics = [
            ["CWAgent", "disk_used_percent", "InstanceId", local.legacy_instance_id]
          ],
          period = 60,
          stat   = "Average",
          title  = "Disk Used %"
        }
      },
      {
        type = "metric",
        x    = 12, y = 6, width = 12, height = 6,
        properties = {
          metrics = [
            ["AWS/EC2", "StatusCheckFailed", "InstanceId", local.legacy_instance_id]
          ],
          period = 60,
          stat   = "Maximum",
          title  = "Status Check Failed"
        }
      }
    ]
  })
}
