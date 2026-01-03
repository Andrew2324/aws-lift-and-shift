# Cutover Runbook – AWS Lift and Shift

## Objective
Safely transition production traffic from the on-premises environment to AWS.

## Cutover Steps
1. Confirm AWS EC2 instance is healthy
2. Verify application is running and accessible
3. Lower DNS TTL (if applicable)
4. Update DNS record to AWS public IP
5. Monitor traffic and logs
6. Validate application functionality

## Validation Checklist
- [ ] HTTP responds with 200 OK
- [ ] Application content loads correctly
- [ ] SSH access works for administrators
- [ ] No errors in application logs

## Monitoring During Cutover
- CloudWatch CPU and memory usage
- System logs (`/var/log/messages`)
- Apache access and error logs

## Cutover Completion
Cutover is considered successful after 30 minutes of stable operation with no errors or user impact.
