# providers.tf
# Define las herramientas que Terraform necesita descargar y cómo conectarse a AWS

terraform {
  # Versión mínima de Terraform requerida
  # Necesitamos >= 1.10 por el S3 native locking
  required_version = ">= 1.10.0"

  required_providers {
    # Proveedor de AWS
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # Proveedor de Cloudflare para automatizar DNS
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# Configuración de conexión a AWS
provider "aws" {
  region = "us-east-1"
}

# Configuración de conexión a Cloudflare
# El token se inyecta como variable de entorno
# nunca hardcodeado aquí
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}