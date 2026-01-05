# Incident Runbook: Instance Unreachable / Status Check Failed

## Symptoms
- CloudWatch alarm: `liftshift-ec2-statuscheck-failed`
- Site is timing out or unreachable from browser/curl
- SSH connection times out or refuses
- EC2 console shows failing `2/2 checks` or `1/2 checks`

## Checks (5–10 minutes)
1) Confirm the failure from your machine
   - `curl -I http://<PUBLIC_IP>`
2) Check EC2 state and status checks (AWS Console)
   - Is the instance `running`?
   - Which check failed?
     - **System status check failed** → AWS host/network side issue
     - **Instance status check failed** → OS/app/network config issue
3) Confirm the instance still has the expected public IP/DNS
   - Compare with Terraform output (if you re-applied, IP may change)
4) Security Group sanity check
   - Inbound: TCP 80 allowed (0.0.0.0/0 for lab) or your IP range
   - Inbound: TCP 22 allowed from **your** IP only
5) Basic reachability
   - Try ping (optional): `ping <PUBLIC_IP>` (ICMP may be blocked, so not definitive)

## Fix
- If **System status check** is failing:
  1) Wait a few minutes (transient host issues can clear)
  2) Stop/Start the instance (last resort; public IP may change)
  3) If persistent, redeploy via Terraform (cleanest lab recovery)

- If **Instance status check** is failing:
  1) Reboot instance from AWS Console
  2) If SSH works, check system health:
     - `uptime`
     - `sudo journalctl -xe --no-pager | tail -n 80`
     - `sudo dmesg | tail -n 80`

## Validate
- Status checks return to `2/2 passed`
- `curl -I http://<PUBLIC_IP>` returns `HTTP/1.1 200 OK` (or 301/302)
- Apache log group receives new entries after a test request

## Prevention
- Keep a CloudWatch alarm for `StatusCheckFailed`
- Add a “No HTTP response” runbook-driven workflow for app-level issues
- For production: consider ALB + Auto Scaling + multi-AZ (not required for this lab)
