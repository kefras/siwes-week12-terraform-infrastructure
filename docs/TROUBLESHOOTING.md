# Troubleshooting record

## `terraform plan -out=...` returned "Too many command line arguments"

In this Windows PowerShell session, the working syntax was:

```powershell
terraform plan -out project1-final.tfplan
```

Terraform generally supports both `-out=FILE` and `-out FILE`; the observed failure does not establish a universal Terraform limitation. If it recurs, check the exact characters pasted, command aliases, Terraform version, and PowerShell tokenization.

## AWS 403 when creating CloudFront distribution

AWS returned `AccessDenied` and requested account verification before adding new CloudFront resources. This is an account restriction, not a Terraform syntax failure. Contact AWS Support through the official AWS console; do not repeatedly apply an unchanged failing plan.

## `terraform state list` initially returned "No state file was found"

Before the first successful resource creation, the configured backend had no initialized resource state for this deployment. After partial apply, Terraform tracked the resources that were created successfully.

## S3 `head-bucket` returned 404

The lab bucket did not yet exist before apply. After the partial apply, it was created and an `index.html` object was uploaded successfully.

## Partial apply

CloudFront creation failed, while S3, OAC, and IAM resources were created. Terraform state recorded successful creations. The configuration was subsequently revised to reference an existing CloudFront distribution; `terraform plan` later reported no changes.

## S3 object verification

`head-object` returned a 358-byte `index.html`, `ContentType: text/html`, and `ServerSideEncryption: AES256`. This confirms object storage and metadata, not public website availability.
