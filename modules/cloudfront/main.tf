# modules/cloudfront/main.tf
# Distribución CloudFront con OAC, HTTPS forzado
# y cabeceras de seguridad empresarial

# ─────────────────────────────────────────
# 1. Origin Access Control (OAC)
#    Identidad que CloudFront usa para
#    acceder al bucket S3 privado
#    Reemplaza el OAI deprecado
# ─────────────────────────────────────────
resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "carlossanchezcloud-oac"
  description                       = "OAC para el portafolio de carlossanchezcloud"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# ─────────────────────────────────────────
# 2. Response Headers Policy
#    Cabeceras de seguridad en cada
#    respuesta — protege contra XSS,
#    clickjacking y sniffing
# ─────────────────────────────────────────
resource "aws_cloudfront_response_headers_policy" "security_headers" {
  name = "carlossanchezcloud-security-headers"

  security_headers_config {
    # Fuerza HTTPS por 1 año en el navegador
    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains         = true
      preload                    = true
      override                   = true
    }

    # Evita que el navegador adivine el tipo
    # de contenido — previene ataques MIME
    content_type_options {
      override = true
    }

    # Evita que tu sitio sea embebido en
    # iframes de otros dominios — anti clickjacking
    frame_options {
      frame_option = "DENY"
      override     = true
    }

    # Controla qué información del referrer
    # se comparte con otros sitios
    referrer_policy {
      referrer_policy = "strict-origin-when-cross-origin"
      override        = true
    }
  }
}

# ─────────────────────────────────────────
# 3. Distribución CloudFront principal
#    El corazón de la infraestructura
# ─────────────────────────────────────────
resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_All"
  aliases             = var.domain_aliases

  # ── Origen: S3 privado via OAC ──
  origin {
    domain_name              = var.bucket_domain_name
    origin_id                = "S3-${var.bucket_id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  # ── Comportamiento del caché ──
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.bucket_id}"
    viewer_protocol_policy = "redirect-to-https"

    # Política de caché optimizada para
    # contenido estático de S3
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers.id

    compress = true
  }

  # ── Páginas de error personalizadas ──
  # Si alguien va a una ruta que no existe
  # muestra tu index.html en lugar de error XML de S3
  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  # ── Certificado SSL ──
  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # ── Restricciones geográficas ──
  # Sin restricciones — acceso global
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = "carlossanchezcloud-distribution"
    Project     = "carlossanchezcloud"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}