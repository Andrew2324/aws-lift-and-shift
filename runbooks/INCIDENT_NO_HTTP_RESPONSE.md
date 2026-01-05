# Incident Runbook: No HTTP Response (Port 80)

## Symptoms
- Browser shows timeout
- `curl -I http://<PUBLIC_IP>` times out or “Connection refused”
- Status checks may still be passing (instance up, app down)

## Checks (5–10 minutes)
1) Confirm from your machine:
   - `curl -I http://<PUBLIC_IP>`
2) Confirm security group allows inbound 80
3) SSH to instance:
   - `ssh -i <key.pem> ec2-user@<PUBLIC_IP>`
4) Check Apache service:
   - `sudo systemctl status httpd --no-pager`
5) Check if port 80 is listening:
   - `sudo ss -lntp | grep :80 || true`

## Fix
- If Apache is stopped or failed:
  - `sudo systemctl restart httpd`
  - `sudo systemctl enable httpd`
- If Apache won’t start, check logs:
  - `sudo tail -n 80 /var/log/httpd/error_log`
  - `sudo journalctl -u httpd --no-pager | tail -n 80`

## Validate
- `curl -I http://localhost` returns 200/301/302
- `curl -I http://<PUBLIC_IP>` returns 200/301/302
- New entries show up in `/aws/liftshift/apache/access` after a test request

## Prevention
- Add an alarm for “instance reachable but no HTTP response” (future enhancement)
- Keep Apache logs flowing to CloudWatch for quick remote diagnosis
- Document config changes in commit history (README “Changes” section)
