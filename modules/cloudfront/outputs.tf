# modules/cloudfront/outputs.tf
# Expone los valores de CloudFront
# que otros módulos necesitarán

output "distribution_id" {
  description = "ID de la distribución CloudFront"
  value       = aws_cloudfront_distribution.website.id
}

output "distribution_arn" {
  description = "ARN de la distribución CloudFront para la bucket policy OAC"
  value       = aws_cloudfront_distribution.website.arn
}

output "distribution_domain_name" {
  description = "Domain name de CloudFront para crear el CNAME en Cloudflare"
  value       = aws_cloudfront_distribution.website.domain_name
}