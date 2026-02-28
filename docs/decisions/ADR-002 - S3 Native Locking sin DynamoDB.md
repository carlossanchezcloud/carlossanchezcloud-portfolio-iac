# ADR-002: S3 Native Locking sin DynamoDB

## Estado
✅ Aprobado

## Contexto
Terraform requiere un mecanismo de locking para el tfstate que evite
que dos ejecuciones simultáneas corrompan el estado. Tradicionalmente
se usaba DynamoDB junto con S3 para este propósito.

## Decisión
Se usa **S3 Native Locking** disponible desde Terraform >= 1.10
eliminando la dependencia de DynamoDB.

## Razones
- Terraform 1.10 introdujo locking nativo en S3 en noviembre 2024
- DynamoDB agrega costo y complejidad innecesarios
- Un solo desarrollador no necesita protección contra escrituras concurrentes
- S3 native locking usa conditional writes — igual de confiable

## Configuración
```hcl
terraform {
  backend "s3" {
    bucket       = "carlossanchezcloud-tfstate-prod"
    key          = "prod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
```

## Consecuencias


✅ Sin costo adicional de DynamoDB
✅ Arquitectura más simple
✅ Estándar moderno de Terraform
❌ Requiere Terraform >= 1.10