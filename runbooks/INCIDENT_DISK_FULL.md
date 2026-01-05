# Incident Runbook: Disk Usage High

## Symptoms
- CloudWatch alarm: `liftshift-high-disk`
- Instance becomes slow/unresponsive
- Logs stop writing or services fail to restart
- `df -h` shows `/` approaching 85–95% used

## Checks (5–10 minutes)
1) SSH into instance
2) Check disk usage:
   - `df -h`
3) Find what is consuming space:
   - `sudo du -h /var/log | sort -hr | head -n 20`
   - `sudo du -h / | sort -hr | head -n 20` (can be heavy; use carefully)

## Fix
- Clear large/old logs (be careful):
  - Check Apache logs:
    - `sudo ls -lh /var/log/httpd`
  - If necessary (lab-safe), truncate large logs:
    - `sudo truncate -s 0 /var/log/httpd/access_log`
    - `sudo truncate -s 0 /var/log/httpd/error_log`
- Restart CloudWatch Agent if it stopped:
  - `sudo systemctl restart amazon-cloudwatch-agent`

## Validate
- `df -h` shows safe free space (< 80–85%)
- CloudWatch alarm returns to `OK`
- Logs resume appearing in CloudWatch log groups

## Prevention
- Keep CloudWatch log retention low (3–7 days) for lab cost control
- Ensure logrotate is working (optional improvement)
- Add a note in README about how disk alarms protect availability
