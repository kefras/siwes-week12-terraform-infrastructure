# SIWES Week 12 — Project 1 Infrastructure Rebuild

Terraform-based AWS infrastructure lab demonstrating private S3 object storage, CloudFront origin access controls, IAM permissions, and remote Terraform state.

## Current status

**Infrastructure provisioned and verified; public delivery of the SIWES test page is not yet configured.** A pre-existing CloudFront distribution is referenced as a Terraform data source and continues to serve a separate professional portfolio. It has **not** been repointed to the SIWES bucket.

| Component | Status |
|---|---|
| Private S3 bucket | Created |
| S3 Block Public Access | Enabled |
| Default S3 encryption | AES256 (SSE-S3) |
| CloudFront Origin Access Control | Created for the lab |
| CloudFront distribution | Existing distribution referenced, not created or managed by this project |
| Lambda IAM execution role | Created with AWSLambdaBasicExecutionRole attached |
| Lambda function | Not provisioned |
| Website `index.html` | Uploaded to private S3 bucket; `text/html`, AES256 verified |
| Public HTTPS delivery of lab website | Not configured |
| Terraform drift check | `No changes` observed |

## Architecture
https://github.com/kefras/siwes-week12-terraform-infrastructure/blob/main/docs/Week%2012%20Terraform%20AWS%20Architecture.png
```

The lab bucket and existing portfolio bucket are distinct. The existing distribution is not the delivery endpoint for the lab object.

## Repository layout

```text
week12-project1-rebuild/
├── .gitignore
├── .terraform.lock.hcl
├── backend.tf
├── main.tf
├── outputs.tf
├── variables.tf
├── versions.tf
├── terraform.tfvars.example
├── website/
│   └── index.html
└── docs/
    ├── ARCHITECTURE.md
    └── TROUBLESHOOTING.md
```

`terraform.tfvars.example` is a safe template; keep the actual `terraform.tfvars` local. The Terraform backend configuration in `backend.tf` must point to a **pre-existing** state bucket.

## Prerequisites

- Terraform CLI and AWS CLI installed
- An AWS CLI profile with appropriate permissions, such as `siwes-terraform`
- A pre-existing S3 remote-state bucket and permissions for state read/write and locking
- Existing CloudFront distribution ID if referencing a distribution as a data source

## Reproduce safely

1. Review `backend.tf`, `main.tf`, and `terraform.tfvars.example`; replace account-specific names and IDs for your own account. Do not use another person's production distribution.
2. Copy the example variables to `terraform.tfvars` and edit local values.
3. Confirm the AWS identity:

   ```powershell
   aws sts get-caller-identity --profile siwes-terraform
   ```
4. Initialize and validate:

   ```powershell
   terraform init
   terraform fmt -check
   terraform validate
   ```
5. Review the proposed changes before approving anything:

   ```powershell
   terraform plan
   ```

   In the original lab, a saved plan was generated with `terraform plan -out project1-final.tfplan`. Review it with `terraform show project1-final.tfplan` before applying. **Do not apply an old saved plan without reviewing its contents and current infrastructure.**
6. Upload and inspect the test page (once the bucket exists):

   ```powershell
   aws s3 sync .\website s3://YOUR-LAB-BUCKET/ --profile siwes-terraform
   aws s3api head-object --bucket YOUR-LAB-BUCKET --key index.html --profile siwes-terraform --query '{ContentLength:ContentLength,ContentType:ContentType,Encryption:ServerSideEncryption}' --output table
   ```
7. Check for drift:

   ```powershell
   terraform plan
   terraform output
   terraform state list
   ```

## Observed verification

- `terraform plan`: **No changes. Your infrastructure matches the configuration.**
- S3 `head-object`: **ContentLength 358**, **ContentType text/html**, **ServerSideEncryption AES256**.
- Existing CloudFront distribution: **Deployed**.
- An attempt to create a new CloudFront distribution failed with AWS **403 AccessDenied** requiring account verification.

## Security

- The lab S3 bucket blocks public ACLs and public bucket policies.
- Default server-side encryption is enabled (SSE-S3).
- The Lambda execution role has a basic logging policy attached; no Lambda function was created.
- Do not make the S3 bucket public to bypass CloudFront verification.
- Never commit AWS credentials, state files, `.tfplan` files, or real `terraform.tfvars` files.
- Review IAM privileges and AWS charges before creating or modifying resources.

## Known limitation and next steps

AWS denied creation of a new CloudFront distribution pending account verification. Referencing the existing portfolio distribution allows the Terraform configuration to be evaluated without attempting to create a second distribution, but **does not publish the lab page**. After AWS verification, consider provisioning a separate distribution and bucket policy for the lab, or testing another safe delivery mechanism without changing the production portfolio.

## Author / context

SIWES practical lab — Week 12, Task 12.2: Project 1 Infrastructure Rebuild.
