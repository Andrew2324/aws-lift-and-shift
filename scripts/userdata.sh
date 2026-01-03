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
