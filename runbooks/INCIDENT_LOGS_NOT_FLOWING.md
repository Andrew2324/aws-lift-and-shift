# Incident Runbook: Logs Not Flowing to CloudWatch

## Symptoms
- No new events in CloudWatch log groups:
  - `/aws/liftshift/apache/access`
  - `/aws/liftshift/apache/error`
  - `/aws/liftshift/system/messages`
- Metrics may still appear (or vice versa)
- CloudWatch Agent appears installed but silent

## Checks (5–10 minutes)
1) Confirm you generated traffic:
   - `curl http://<PUBLIC_IP> >/dev/null`
2) Confirm logs exist locally:
   - `sudo ls -lah /var/log/httpd`
   - `sudo tail -n 20 /var/log/httpd/access_log`
3) Check agent status:
   - `sudo systemctl status amazon-cloudwatch-agent --no-pager`
4) Check agent log:
   - `sudo tail -n 80 /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log`

## Fix
- Restart agent:
  - `sudo systemctl restart amazon-cloudwatch-agent`
- Confirm config file exists:
  - `sudo cat /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json | head`
- If config is wrong/missing:
  - Re-apply Terraform (userdata rebuild) OR replace config and restart agent

## Validate
- New log events appear in CloudWatch within 1–3 minutes
- Access log group shows entries after curl

## Prevention
- Manage log group retention via Terraform
- Keep CW Agent config under version control
- Prefer userdata for “always reproducible” agent setup
