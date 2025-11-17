# 01_Simple_EC2_With_NGINX

Launch a single EC2 instance in the **Default VPC**, install **NGINX via Chef (chef‑solo)**, and serve a page:

> *Simple Project to create EC2 instance on AWS and Install NGINX using Chef Cookbook*

## Run
```bash
cp example.tfvars terraform.tfvars
terraform init
terraform apply
open "$(terraform output -raw site_url)"
```

## Destroy
```bash
terraform destroy
```

## Notes
- SSH is **disabled** by default; use AWS **SSM Session Manager** for access.
- Security Group allows **HTTP (80)** from anywhere.
- Business tags applied to resources: `X-Environment`, `X-Customer`, `X-Dept`, `X-Contact`.
- Local state, tfvars, backend config, keys/certs are **gitignored** at repo root.
