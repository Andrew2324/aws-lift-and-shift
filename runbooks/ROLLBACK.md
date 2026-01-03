# Rollback Runbook – Lift and Shift Migration

## Objective
Provide a safe rollback path in case of failure during or after cutover.

## Rollback Triggers
- Application unreachable
- Critical application errors
- Performance degradation
- Security misconfiguration

## Rollback Steps
1. Revert DNS record to on-premises IP
2. Confirm on-prem application availability
3. Disable AWS EC2 instance if needed
4. Notify stakeholders of rollback

## Post-Rollback Actions
- Capture logs and metrics
- Identify root cause
- Document lessons learned
- Plan remediation before retry

## Rollback Validation
- Application reachable on on-prem environment
- No data inconsistency observed
