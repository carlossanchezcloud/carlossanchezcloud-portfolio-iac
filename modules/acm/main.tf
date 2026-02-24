# modules/acm/main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# Certificado SSL importado desde ACM
# Ya está validado y en uso — no recreamos
# los registros DNS de validación
resource "aws_acm_certificate" "website" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
    # Ignoramos cambios porque este certificado
    # ya existe y está validado manualmente
    ignore_changes = [
      domain_name,
      subject_alternative_names,
      validation_method
    ]
  }

  tags = {
    Name        = "carlossanchezcloud-ssl"
    Project     = "carlossanchezcloud"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}

# Usamos el ARN directamente sin esperar validación
# porque el certificado ya está ISSUED
resource "aws_acm_certificate_validation" "website" {
  certificate_arn = aws_acm_certificate.website.arn
}