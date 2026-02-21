# modules/s3/outputs.tf
# Expone los valores del bucket S3
# que otros módulos necesitarán

output "bucket_id" {
  description = "ID del bucket S3"
  value       = aws_s3_bucket.website.id
}

output "bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.website.arn
}

output "bucket_domain_name" {
  description = "Domain name del bucket para conectar con CloudFront"
  value       = aws_s3_bucket.website.bucket_regional_domain_name
}