# ADR-003: Cloudflare DNS + ACM para SSL

## Estado
✅ Aprobado

## Contexto
El dominio `carlossanchezcloud.com` fue adquirido en Cloudflare.
CloudFront requiere un certificado SSL en ACM para servir HTTPS
con dominio personalizado. Se necesita decidir cómo gestionar
el DNS y la validación del certificado.

## Decisión
Se usa **Cloudflare como DNS** con proxy desactivado y
**ACM para el certificado SSL**, automatizando la validación
DNS via Cloudflare API desde Terraform.

## Razones
- Cloudflare ofrece DNS gratuito con alta disponibilidad global
- ACM es gratuito para certificados públicos en AWS
- El proxy de Cloudflare debe estar OFF para que ACM valide correctamente
- La API de Cloudflare permite automatizar registros DNS desde Terraform
- Sin Route53 — ahorro de $0.50/mes por hosted zone

## Configuración
```hcl