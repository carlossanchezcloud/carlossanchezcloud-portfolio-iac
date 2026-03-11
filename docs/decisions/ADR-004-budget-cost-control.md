# ADR-004: AWS Budget para Control de Costos

## Estado
✅ Aprobado

## Contexto
El portfolio desplegado en S3 + CloudFront tiene un costo estimado bajo (~$1-3 USD/mes).
Sin embargo, existen riesgos reales sin un mecanismo de alerta: tráfico inesperado,
errores de Terraform, cambios inesperados en la infraestructura o recursos huérfanos
pueden generar costos elevados que solo se detectarían al revisar la factura mensual.

## Decisión
Se configura un **AWS Budget mensual de $3 USD** con alerta al **80% ($2.40 USD)**
gestionado como código en `budgets.tf` usando Terraform.

## Razones
- AWS Budgets es gratuito hasta 2 budgets por cuenta
- Alerta proactiva antes de superar el límite — no reactiva
- Detección temprana de comportamiento anómalo en la cuenta
- Configuración como código — reproducible, versionada y auditable
- CloudWatch Billing Alarm es más complejo y menos recomendado para este caso

## Consecuencias

**✅ Alerta proactiva** antes de superar el límite mensual  
**✅ Detección temprana** de anomalías en la cuenta AWS  
**✅ Costo cero** - AWS Budgets gratuito hasta 2 budgets  
**✅ IaC** - configuración versionada junto al resto de la infraestructura  
**❌ Límite estático** - hay que actualizarlo manualmente si el proyecto crece  
**❌ Requiere confirmación** de suscripción SNS por email para activar alertas