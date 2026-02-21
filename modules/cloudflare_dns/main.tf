# modules/cloudflare_dns/main.tf
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# ─────────────────────────────────────────
# 1. Registro raíz
#    carlossanchezcloud.com → CloudFront
# ─────────────────────────────────────────
resource "cloudflare_record" "root" {
  zone_id         = var.cloudflare_zone_id
  name            = "@"
  content         = var.cloudfront_domain_name
  type            = "CNAME"
  ttl             = 1
  proxied         = false
  allow_overwrite = true
}

# ─────────────────────────────────────────
# 2. Registro www
#    www.carlossanchezcloud.com → CloudFront
# ─────────────────────────────────────────
resource "cloudflare_record" "www" {
  zone_id         = var.cloudflare_zone_id
  name            = "www"
  content         = var.cloudfront_domain_name
  type            = "CNAME"
  ttl             = 1
  proxied         = false
  allow_overwrite = true
}