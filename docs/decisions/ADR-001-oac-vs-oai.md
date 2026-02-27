# ADR-001: OAC sobre OAI para Origin Access

## Estado
✅ Aprobado

## Contexto
CloudFront necesita una identidad para acceder al bucket S3 privado.
Existen dos mecanismos: OAI (Origin Access Identity) y OAC (Origin Access Control).

## Decisión
Se usa **OAC (Origin Access Control)** en lugar de OAI.

## Razones
- OAI está en deprecación desde 2022 — AWS recomienda migrar a OAC
- OAC soporta SSE-KMS para encriptación avanzada
- OAC usa firma SigV4 — más seguro que OAI
- OAC es el estándar actual para nuevas implementaciones

## Consecuencias
✅ Mayor seguridad con autenticación SigV4
✅ Soporte futuro garantizado por AWS
✅ Compatible con encriptación SSE-KMS
❌ Configuración ligeramente más compleja que OAI