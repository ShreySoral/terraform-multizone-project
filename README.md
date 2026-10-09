# AWS Multi-AZ Web Infrastructure with Terraform

Infrastructure as Code project deploying two Amazon Linux 2023 Nginx servers in separate AWS Availability Zones behind an internet-facing Application Load Balancer.

## Architecture

```text
Internet -> ALB (public subnets in eu-west-1a and eu-west-1b)
                  |                     |
               EC2 Nginx 1         EC2 Nginx 2
                  \_______ VPC 10.0.0.0/16 _______/
```

## Features

- Terraform AWS provider 6.x, reusable network/compute/ALB/monitoring modules
- Two public subnets, internet gateway and route table associations
- HTTP target group with health checks and two registered EC2 instances
- EC2 port 80 ingress restricted to the ALB security group
- CloudWatch alarms for high EC2 CPU and unhealthy ALB targets
- Optional S3 remote state with versioning, encryption and lockfile
- GitHub Actions format and validate checks

## Prerequisites

Terraform >= 1.5, AWS CLI configured with authorized credentials, AWS account with appropriate permissions. Default region: `eu-west-1`.

## Deploy

```bash
aws sts get-caller-identity
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=deploy.tfplan
terraform apply deploy.tfplan
terraform output alb_url
```

Wait for both ALB targets to be healthy before testing. This uses HTTP only and is intended as a learning/portfolio demonstration, not production hosting.

## Existing deployment migration

**Do not copy this over your working configuration and immediately apply.** Follow `MIGRATION.md` to preserve Terraform state addresses. Verify resource names and the planned changes first.

## Remote state

Follow `REMOTE_STATE.md` after completing the safe module migration. Never commit state files or credentials.

## Validation and testing

- `terraform fmt -check -recursive`
- `terraform validate`
- `terraform plan` and confirm no unintended replacements
- AWS EC2 > Target Groups > Targets: both healthy
- `terraform output alb_url` then visit the URL
- Confirm direct access to EC2 public IPs is blocked after security hardening
- AWS CloudWatch > Alarms: three configured alarms (notifications not configured)

## Known limitations and future improvements

- EC2 instances remain in public subnets; private subnets, VPC endpoints, and a private instance access strategy are next steps.
- No HTTPS/TLS, DNS, Auto Scaling Group, or automated instance replacement.
- Monitoring alarms have no SNS notification actions.
- Changing `user_data` or AMI may replace instances; inspect every plan.
- The ALB is a paid AWS resource; EC2, public IPv4, S3 and CloudWatch may also incur costs.

## Cleanup

From the infrastructure root: `terraform destroy` after reviewing the plan. S3 state bootstrap is deliberately separate and has `prevent_destroy`; preserve backups and remove the bucket only when you explicitly intend to retire the state.

