# AWS Lift-and-Shift Modernization (Terraform)

## Purpose
This lab simulates a real-world "lift-and-shift" migration: moving a legacy VM-hosted web app to AWS with minimal changes.
The focus is:
- Rapid migration
- Infrastructure as Code (Terraform)
- Security-first basics (restricted SSH, least privilege)
- Runbooks (migration, cutover, rollback)
- Post-migration hardening + modernization roadmap

> Note: This is a lab / simulated enterprise scenario (not a real production workload).

## Architecture
- VPC (10.0.0.0/16)
- 1 Public Subnet (10.0.1.0/24)
- Internet Gateway + Route Table
- Security Group:
  - SSH (22) limited to your IP
  - HTTP (80) open to world
- EC2 (Amazon Linux 2023) with Apache installed via user-data
- Optional: SSM role for future hardening (no inbound required)

## Repo Structure
- terraform/        -> IaC (VPC, subnet, routes, SG, IAM, EC2)
- scripts/          -> userdata + validation scripts
- runbooks/         -> migration plan, cutover, rollback
- post-migration/   -> security, monitoring, cost, modernization plan
- diagram/          -> architecture image (optional)

## Prereqs
- Terraform >= 1.5
- AWS CLI configured (or env vars)
- An existing EC2 Key Pair in your AWS account (for SSH)

## Quick Start
### 1) Create a key pair (once)
In AWS Console: EC2 → Key Pairs → Create.
Name it something like: `liftshift-key`

### 2) Set variables
Option A (recommended): create a `terraform/terraform.tfvars`:
```hcl
key_name      = "liftshift-key"
admin_cidr    = "YOUR_PUBLIC_IP/32"
aws_region    = "us-east-1"
instance_type = "t3.micro"
