# Incident Runbook: High CPU / High Memory

## Symptoms
- CloudWatch alarm: `liftshift-high-cpu` and/or `liftshift-high-memory`
- Site is slow, intermittent, or returns errors
- CPU > 80% for several minutes (per alarm threshold)
- Memory used percent climbing continuously

## Checks (5–10 minutes)
1) Open CloudWatch Dashboard:
   - Confirm CPU trend and when it started
2) Check logs for spikes/errors:
   - CloudWatch Logs: `/aws/liftshift/apache/error`
   - CloudWatch Logs: `/aws/liftshift/apache/access` (traffic spike)
3) SSH into instance and check:
   - `top`
   - `uptime`
   - `free -m`
   - `df -h`
4) Identify top offenders:
   - CPU: `ps aux --sort=-%cpu | head -n 10`
   - Memory: `ps aux --sort=-%mem | head -n 10`

## Fix
### If CPU is caused by Apache / traffic spike
- Restart Apache (quick recovery):
  - `sudo systemctl restart httpd`
- Check for repeated hits / bot-like behavior (lab observation):
  - `sudo tail -n 30 /var/log/httpd/access_log`

### If CPU is a runaway process
- Identify PID from `top`
- If it is safe to stop:
  - `sudo kill -15 <PID>`
  - If needed: `sudo kill -9 <PID>`

### If memory is high
- Restart Apache (common cause in small instances):
  - `sudo systemctl restart httpd`
- If memory is critically low and system unstable:
  - Reboot instance (last resort in lab)

## Validate
- Alarm returns to `OK`
- Dashboard CPU and memory return to baseline
- `curl -I http://<PUBLIC_IP>` responds quickly (200/301/302)
- Error logs stop spiking

## Prevention
- For production: autoscaling, caching, WAF/rate limiting, and request throttling
- For this lab: keep the alarm + runbook and note “scale strategy” in README
