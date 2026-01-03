terraform {
  backend "s3" {
    bucket       = "app-elsondevops-3tier-tf-s3-2026"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
