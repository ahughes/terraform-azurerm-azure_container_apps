output "aca_fqdns" {
  description = "Map of Azure Container Apps and respective fully-qualified domain names (FQDNs)"
  value       = { for ca_key, ca in azapi_resource.aca : ca_key => jsondecode(ca.output).properties.configuration.ingress.fqdn }
}