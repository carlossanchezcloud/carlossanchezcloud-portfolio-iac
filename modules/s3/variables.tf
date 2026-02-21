# modules/s3/variables.tf
# Define las variables que necesita el módulo S3

variable "bucket_name" {
  description = "Nombre del bucket S3 para el sitio web"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "ARN de la distribucion CloudFront para la bucket policy OAC"
  type        = string
}