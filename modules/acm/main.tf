
# modules/acm/main.tf
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}


# modules/acm/main.tf
# Solicita y valida el certificado SSL en ACM
# Validación automática via Cloudflare DNS API

# ─────────────────────────────────────────
# 1. Solicita el certificado SSL
#    Wildcard cubre el dominio raíz y
#    cualquier subdominio futuro
# ─────────────────────────────────────────
resource "aws_acm_certificate" "website" {
  domain_name = var.domain_name

  # Wildcard cubre:
  # carlossanchezcloud.com
  # *.carlossanchezcloud.com (cualquier subdominio futuro)
  subject_alternative_names = ["*.${var.domain_name}"]

  # Validación via DNS es automática
  # No requiere intervención manual
  validation_method = "DNS"

  # Importante: Si necesitas recrear el certificado
  # crea el nuevo antes de destruir el viejo
  # Evita downtime en producción
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "carlossanchezcloud-ssl"
    Project     = "carlossanchezcloud"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}

# ─────────────────────────────────────────
# 2. Crea los registros DNS en Cloudflare
#    para validar el certificado
#    ACM genera los valores, Terraform
#    los crea automáticamente en Cloudflare
# ─────────────────────────────────────────
resource "cloudflare_record" "acm_validation" {
  # for_each porque ACM puede requerir
  # múltiples registros de validación
  for_each = {
    for dvo in aws_acm_certificate.website.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      value = dvo.resource_record_value
      type  = dvo.resource_record_type
    }
  }

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  content   = each.value.value
  type    = each.value.type

  # TTL bajo para que la validación
  # sea lo más rápida posible
  ttl = 60

  # Proxy OFF obligatorio para registros
  # de validación ACM — no pueden pasar
  # por el proxy de Cloudflare
  proxied = false
}

# ─────────────────────────────────────────
# 3. Espera hasta que ACM confirme
#    que el certificado está validado
#    y listo para usar en CloudFront
# ─────────────────────────────────────────
resource "aws_acm_certificate_validation" "website" {
  certificate_arn = aws_acm_certificate.website.arn

  validation_record_fqdns = [
    for record in cloudflare_record.acm_validation : record.hostname
  ]
}