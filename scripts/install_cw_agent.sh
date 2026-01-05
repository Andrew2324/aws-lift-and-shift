#!/bin/bash
set -e

# Amazon Linux 2023
dnf install -y amazon-cloudwatch-agent

# CW Agent config: metrics + apache logs + system messages
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<'EOF'
{
  "agent": { "metrics_collection_interval": 60 },
  "metrics": {
    "append_dimensions": { "InstanceId": "${aws:InstanceId}" },
    "metrics_collected": {
      "cpu": { "measurement": ["cpu_usage_idle","cpu_usage_user","cpu_usage_system"], "totalcpu": true, "metrics_collection_interval": 60 },
      "mem": { "measurement": ["mem_used_percent"], "metrics_collection_interval": 60 },
      "disk": { "measurement": ["used_percent"], "metrics_collection_interval": 60, "resources": ["/"] }
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          { "file_path": "/var/log/httpd/access_log", "log_group_name": "/aws/liftshift/apache/access", "log_stream_name": "{instance_id}" },
          { "file_path": "/var/log/httpd/error_log",  "log_group_name": "/aws/liftshift/apache/error",  "log_stream_name": "{instance_id}" },
          { "file_path": "/var/log/messages",         "log_group_name": "/aws/liftshift/system/messages","log_stream_name": "{instance_id}" }
        ]
      }
    }
  }
}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s

systemctl enable amazon-cloudwatch-agent
