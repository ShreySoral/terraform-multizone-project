# Optional encrypted S3 remote state

**Complete the module migration first.** Terraform state may contain sensitive information; do not upload or commit it publicly.

1. Pick a globally unique S3 bucket name. In `bootstrap-state/`, run:

```bash
terraform init
terraform apply -var="state_bucket_name=YOUR-GLOBALLY-UNIQUE-STATE-BUCKET"
```

2. Return to the infrastructure root. Copy `backend.tf.example` to `backend.tf`, replace the placeholder with the created bucket name, and keep the backend region matching the bucket region.
3. Run `terraform init -migrate-state` and approve the state migration after verifying the bucket and key. Keep a secure backup of local state.
4. Run `terraform plan` and ensure no unexpected resource changes. S3 native lockfile support (`use_lockfile = true`) requires a Terraform release that supports it; upgrade Terraform if needed.
5. Do not run concurrent applies or manually edit the remote state. Protect the bucket with least-privilege IAM and access logging as appropriate.

The bootstrap bucket is intentionally managed by its **own local state**, separate from the infrastructure it stores. Keep that bootstrap state backed up securely.
