# modules/cloudflare_dns/variables.tf
# Variables que necesita el módulo Cloudflare DNS

variable "cloudflare_zone_id" {
  description = "Zone ID de Cloudflare para el dominio carlossanchezcloud.com"
  type        = string
  sensitive   = true
}

variable "cloudfront_domain_name" {
  description = "Domain name de CloudFront al que apuntarán los registros DNS"
  type        = string
}