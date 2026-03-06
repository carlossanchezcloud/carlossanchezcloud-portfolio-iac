
# backend.tf
# Le dice a Terraform dónde guardar el tfstate
# Apunta al bucket S3 que se creo manualmente

terraform {
  backend "s3" {
    bucket       = "carlossanchezcloud-tfstate-prod"
    key          = "prod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}