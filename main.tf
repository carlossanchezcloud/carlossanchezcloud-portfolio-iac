# main.tf

# ─────────────────────────────────────────
# 1. Módulo ACM
# ─────────────────────────────────────────
module "acm" {
  source = "./modules/acm"

  domain_name        = var.domain_name
  cloudflare_zone_id = var.cloudflare_zone_id
}

# ─────────────────────────────────────────
# 2. Módulo S3 — Solo el bucket sin policy
# ─────────────────────────────────────────
module "s3" {
  source = "./modules/s3"

  bucket_name = var.bucket_name
}

# ─────────────────────────────────────────
# 3. Módulo CloudFront
# ─────────────────────────────────────────
module "cloudfront" {
  source = "./modules/cloudfront"

  bucket_domain_name = module.s3.bucket_domain_name
  bucket_id          = module.s3.bucket_id
  certificate_arn    = module.acm.certificate_arn
  domain_aliases = [
    var.domain_name,
  ]

  depends_on = [module.acm, module.s3]
}

# ─────────────────────────────────────────
# 4. Bucket Policy — Fuera del módulo S3
#    Se crea después de CloudFront
#    Rompe el ciclo definitivamente
# ─────────────────────────────────────────
resource "aws_s3_bucket_policy" "website" {
  bucket = module.s3.bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontOAC"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${module.s3.bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = module.cloudfront.distribution_arn
          }
        }
      }
    ]
  })

  depends_on = [module.s3, module.cloudfront]
}

# ─────────────────────────────────────────
# 5. Módulo Cloudflare DNS
# ─────────────────────────────────────────
   module "cloudflare_dns" {
  source = "./modules/cloudflare_dns"
  cloudflare_zone_id     = var.cloudflare_zone_id
  cloudfront_domain_name = module.cloudfront.distribution_domain_name

  depends_on = [module.cloudfront]
  }