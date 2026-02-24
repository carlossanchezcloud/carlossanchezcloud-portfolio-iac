# variables.tf
# Variables globales del proyecto

variable "domain_name" {
  description = "Dominio principal del sitio web"
  type        = string
}

variable "bucket_name" {
  description = "Nombre del bucket S3 para el sitio web"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Zone ID de Cloudflare para el dominio"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_token" {
  description = "Token de API de Cloudflare"
  type        = string
  sensitive   = true
}

#test
#test2
#test3