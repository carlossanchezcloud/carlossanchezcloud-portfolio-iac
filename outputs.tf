# outputs.tf
# Muestra los valores importantes
# al finalizar el terraform apply

output "cloudfront_distribution_id" {
  description = "ID de la distribución CloudFront"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_domain_name" {
  description = "Domain name de CloudFront"
  value       = module.cloudfront.distribution_domain_name
}

output "website_bucket_name" {
  description = "Nombre del bucket S3 del sitio web"
  value       = module.s3.bucket_id
}

output "certificate_arn" {
  description = "ARN del certificado SSL"
  value       = module.acm.certificate_arn
}

output "website_url" {
  description = "URL del sitio web en producción"
  value       = "https://${var.domain_name}"
}