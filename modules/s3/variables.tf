# modules/s3/variables.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "bucket_name" {
  description = "Nombre del bucket S3 para el sitio web"
  type        = string
}