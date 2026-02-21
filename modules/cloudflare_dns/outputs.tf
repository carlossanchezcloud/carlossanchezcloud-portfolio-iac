# modules/cloudflare_dns/outputs.tf
# Expone los valores de los registros DNS

output "root_record_hostname" {
  description = "Hostname del registro DNS raíz"
  value       = cloudflare_record.root.hostname
}

output "www_record_hostname" {
  description = "Hostname del registro DNS www"
  value       = cloudflare_record.www.hostname
}