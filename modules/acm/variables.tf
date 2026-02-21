# modules/acm/variables.tf
# Variables que necesita el módulo ACM

variable "domain_name" {
  description = "Dominio principal del sitio web"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Zone ID de Cloudflare para crear los registros DNS de validación"
  type        = string
  sensitive   = true
}