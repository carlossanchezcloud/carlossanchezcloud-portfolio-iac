# modules/s3/main.tf
# Crea el bucket S3 privado para el portafolio
# Solo CloudFront puede acceder via OAC

# ─────────────────────────────────────────
# 1. El bucket principal
#    Aquí vivirán tus archivos HTML, CSS, JS
# ─────────────────────────────────────────
resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Project     = "carlossanchezcloud"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}

# ─────────────────────────────────────────
# 2. Bloquea TODO acceso público al bucket
#    El sitio NUNCA será accesible directo
#    Solo CloudFront puede leerlo via OAC
# ─────────────────────────────────────────
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ─────────────────────────────────────────
# 3. Encriptación del bucket
#    Todos los archivos se guardan
#    encriptados en reposo (AES-256)
# ─────────────────────────────────────────
resource "aws_s3_bucket_server_side_encryption_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ─────────────────────────────────────────
# 4. Versionado del bucket
#    Guarda historial de cada archivo
#    Si rompes algo puedes volver atrás
# ─────────────────────────────────────────
resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ─────────────────────────────────────────
# 5. Lifecycle — Limpieza automática
#    Borra versiones viejas después de
#    30 días para no acumular costos
# ─────────────────────────────────────────
resource "aws_s3_bucket_lifecycle_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    id     = "cleanup-old-versions"
    status = "Enabled"

    # Filter vacío = aplica a todos los objetos
    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}
