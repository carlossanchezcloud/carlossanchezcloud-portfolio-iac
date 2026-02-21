# modules/acm/outputs.tf
# Expone los valores del certificado SSL
# que CloudFront necesitará

output "certificate_arn" {
  description = "ARN del certificado SSL validado para usar en CloudFront"
  value       = aws_acm_certificate_validation.website.certificate_arn
}