
terraform {
  backend "s3" {
    bucket       = "kefas-siwes-terraform-state-178777954852"
    key          = "siwes/week12/project1-rebuild/terraform.tfstate"
    region       = "us-east-1"
    profile      = "siwes-terraform"
    encrypt      = true
    use_lockfile = true
  }
}
