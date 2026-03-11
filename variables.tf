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

variable "project_name" {
  description = "Nombre del proyecto, usado como prefijo en recursos"
  type        = string
  default     = "portfolio"
}

variable "budget_limit_usd" {
  description = "Límite mensual del budget en USD"
  type        = string
  default     = "3"
}

variable "alert_email" {
  description = "Email para recibir alertas del budget"
  type        = string
  sensitive   = true
}