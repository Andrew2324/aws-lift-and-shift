#!/bin/bash
set -euxo pipefail

dnf update -y
dnf install -y httpd

cat > /var/www/html/index.html <<'EOF'
<html>
  <head><title>Lift-and-Shift Migration</title></head>
  <body style="font-family: Arial;">
    <h1>✅ Lift-and-Shift Success</h1>
    <p>This legacy web workload was migrated to AWS EC2 using Terraform.</p>
    <p><b>Next:</b> hardening, monitoring, and modernization phases.</p>
  </body>
</html>
EOF

systemctl enable httpd
systemctl start httpd

# Install + start CloudWatch Agent

# Create CW Agent config
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<'EOF'
{
  "agent": {
    "metrics_collection_interval": 60,
    "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
  },
  "metrics": {
    "append_dimensions": {
      "InstanceId": "${aws:InstanceId}"
    },
    "metrics_collected": {
      "cpu": {
        "measurement": ["cpu_usage_idle","cpu_usage_user","cpu_usage_system"],
        "totalcpu": true,
        "metrics_collection_interval": 60
      },
      "mem": {
        "measurement": ["mem_used_percent"],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": ["used_percent"],
        "metrics_collection_interval": 60,
        "resources": ["/"]
      }
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/httpd/access_log",
            "log_group_name": "/aws/liftshift/apache/access",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/var/log/httpd/error_log",
            "log_group_name": "/aws/liftshift/apache/error",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/aws/liftshift/system/messages",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
EOF

# Start the agent using the config above
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s

systemctl enable amazon-cloudwatch-agent
