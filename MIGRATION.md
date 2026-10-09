# Safe migration from the original flat Terraform project

1. Back up the entire original working directory, especially `terraform.tfstate`, `terraform.tfstate.backup`, and any backend configuration. Never commit these files.
2. In your **existing working directory**, run `terraform state list` and save the output privately. Compare each address with `moved.tf` in this package. Resource names must match exactly. The provided moves assume the names used in the tutorial; if yours differ, adjust the `from` addresses. Do not run `terraform state rm` or import blindly.
3. Check `terraform output alb_url` and both targets healthy. Ensure AWS region and account match.
4. Copy the packaged root `.tf` files, `modules/`, and `.gitignore` into your existing directory, **replacing** the old root Terraform resource declarations. Do not leave old `main.tf` declarations alongside the new modules. Keep the original state files and `.terraform/` directory. Do not copy `bootstrap-state` into the root as a module.
5. Run `terraform init`, `terraform fmt -recursive`, `terraform validate`, `terraform plan -out=migration.tfplan`.
6. Read the plan in full. The expected changes are address moves, web ingress changing from `0.0.0.0/0` to the ALB security group, three new CloudWatch alarms, and possibly provider default tag additions. **STOP if VPC, subnets, EC2, ALB, or target group are planned for replacement or destruction.** Differences in original user_data, AMI, tags, descriptions or resource names can cause changes. Compare and adjust code to your actual state before proceeding.
7. Apply only when satisfied: `terraform apply migration.tfplan`. Confirm both targets healthy, `terraform output alb_url` works, and direct EC2 IP HTTP access is blocked.
8. Optional: configure S3 remote state by following `REMOTE_STATE.md` after this migration succeeds.

The `moved.tf` file is only valid if original addresses match. If your existing security group rules used inline `ingress`/`egress` blocks instead of standalone rule resources, do not assume the move applies; reconcile the rules separately and review the plan. If you named ingress resources `allow_http` instead of `http`, edit that `from` address accordingly. Back up state before any migration.
