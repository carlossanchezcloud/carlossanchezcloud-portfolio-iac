# modules/cloudfront/variables.tf
# Variables que necesita el módulo CloudFront

variable "bucket_domain_name" {
  description = "Domain name regional del bucket S3"
  type        = string
}

variable "bucket_id" {
  description = "ID del bucket S3"
  type        = string
}

variable "certificate_arn" {
  description = "ARN del certificado SSL validado en ACM"
  type        = string
}

variable "domain_aliases" {
  description = "Dominios que responde la distribución CloudFront"
  type        = list(string)
}