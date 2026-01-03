# Migration Plan – Lift and Shift (On-Prem to AWS)

## Overview
This document outlines the migration plan for moving a legacy on-premises virtual machine to AWS using a lift-and-shift strategy. The goal is rapid migration with minimal application changes while maintaining stability and rollback capability.

## Source Environment (Simulated)
- Platform: On-prem virtual machine
- OS: Linux (Amazon Linux 2023 equivalent)
- Application: Apache-hosted web application
- Data Size: < 5 GB
- Dependencies:
  - HTTP (Port 80)
  - SSH (Port 22 – admin access only)

## Target Environment (AWS)
- EC2 instance (t3.micro)
- Amazon Linux 2023
- VPC with public subnet
- Security Groups controlling access
- Infrastructure provisioned via Terraform

## Pre-Migration Checklist
- [ ] Identify running services
- [ ] Validate disk usage and available space
- [ ] Confirm open ports
- [ ] Confirm SSH access
- [ ] Backup application data
- [ ] Document DNS records

## Migration Strategy
- Recreate VM in AWS using EC2
- Install required packages via user-data
- Restore application files (simulated)
- Validate application functionality
- Perform DNS cutover

## Downtime Expectation
- Estimated downtime: 10–15 minutes
- Downtime window scheduled during low-traffic period

## Risks and Mitigation
| Risk | Mitigation |
|-----|-----------|
| DNS propagation delay | Lower TTL before cutover |
| App startup failure | Rollback plan prepared |
| Security misconfiguration | Pre-validated SG rules |

## Success Criteria
- Application reachable via AWS public IP
- SSH access restricted and functional
- No application errors observed
