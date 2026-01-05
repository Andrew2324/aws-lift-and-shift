# Observability + Runbooks (Lift-and-Shift)

This project operationalizes the lift-and-shift EC2 workload by adding:
- CloudWatch Logs for Apache/system logs
- CloudWatch Agent for memory/disk metrics
- CloudWatch Alarms + SNS alerts
- A CloudWatch Dashboard
- Incident runbooks tied to alarms

## Dashboards
- CloudWatch Dashboard: `liftshift-dashboard`

## Log Groups
- `/aws/liftshift/apache/access`
- `/aws/liftshift/apache/error`
- `/aws/liftshift/system/messages`

## Alarm → Runbook Mapping
- `liftshift-ec2-statuscheck-failed` → `INCIDENT_INSTANCE_UNREACHABLE.md`
- `liftshift-high-cpu` → `INCIDENT_HIGH_CPU.md`
- `liftshift-high-memory` → `INCIDENT_HIGH_CPU.md` (memory section)
- `liftshift-high-disk` → `INCIDENT_DISK_FULL.md`

## Fast Triage Order (when the site is down)
1) Status checks + EC2 state
2) Security Group / reachability
3) Apache status + logs
4) Disk space
