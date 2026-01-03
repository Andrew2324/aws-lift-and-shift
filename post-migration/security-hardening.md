# Post-Migration Security Hardening

## Objective
Improve the security posture of the migrated workload after stabilization.

## Actions Taken
- Disabled root SSH login
- Enforced SSH key-only authentication
- Restricted SSH access to admin IPs
- Applied latest OS patches
- Removed unused packages and services

## IAM Improvements
- Attached IAM role to EC2 instance
- Avoided use of static AWS credentials
- Limited permissions to least privilege

## Future Security Enhancements
- Move instance to private subnet
- Add ALB with HTTPS
- Enable AWS WAF
- Integrate with AWS Systems Manager
