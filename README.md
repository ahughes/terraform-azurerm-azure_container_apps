# terraform-azurerm-azure_container_apps
A Terraform module to deploy Azure Container Apps

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.37.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 1.1.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.37.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.aca](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource.aca_env](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource.aca_env_storages](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurerm_log_analytics_workspace.laws](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_storage_account.aca_env_storages](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_container_apps_environment_name"></a> [azure\_container\_apps\_environment\_name](#input\_azure\_container\_apps\_environment\_name) | Name of Azure Container Apps Environment | `string` | n/a | yes |
| <a name="input_azure_container_apps_map"></a> [azure\_container\_apps\_map](#input\_azure\_container\_apps\_map) | Map of Azure Container Apps to be deployed to the ACA Environment | <pre>map(object({<br>    name                   = optional(string)<br>    active_revisions_mode  = optional(string, "Single")<br>    azurefile_volumes      = optional(list(string), [])<br>    ingress_allow_external = optional(bool, true)<br>    ingress_allow_insecure = optional(bool, false)<br>    ingress_target_port    = optional(number, 80)<br>    ingress_transport      = optional(string, "Auto")<br>    max_replicas           = number<br>    min_replicas           = number<br>    secrets                = optional(map(string))<br>    containers = map(object({<br>      command      = optional(set(string))<br>      env          = optional(map(string), {})<br>      image        = string<br>      volumeMounts = optional(map(string))<br>      resources = object({<br>        cpu    = number<br>        memory = string<br>      })<br>    }))<br>    dapr_configuration = optional(object({<br>      appId       = string<br>      appPort     = number<br>      appProtocol = optional(string, "http")<br>      enabled     = optional(bool, true)<br>    }))<br>    ingress_custom_domains = optional(list(object({<br>      name          = string<br>      certificateId = string<br>      bindingType   = optional(string, "SniEnabled")<br>    })))<br>    registries_configuration = optional(list(object({<br>      identity          = optional(string)<br>      passwordSecretRef = optional(string)<br>      server            = optional(string)<br>      username          = optional(string)<br>    })))<br>    scale_rules = optional(list(object({<br>      name = string<br>      azureQueue = object({<br>        queueName   = string<br>        queueLength = number<br>        auth = list(object({<br>          secretRef        = string<br>          triggerParameter = string<br>        }))<br>      })<br>    })))<br>  }))</pre> | n/a | yes |
| <a name="input_azure_files_volumes_map"></a> [azure\_files\_volumes\_map](#input\_azure\_files\_volumes\_map) | Map of Azure Files shares to map as volumes for containers to mount | <pre>map(object({<br>    access_mode                 = optional(string, "ReadWrite")<br>    account_key                 = optional(string)<br>    account_name                = string<br>    account_resource_group_name = string<br>    share_name                  = string<br>  }))</pre> | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Name of an existing Log Analytics Workspace to bind to the Azure Container Apps Environment | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | Name of resource group containing existing Log Analytics Workspace (leave blank to use var.resource\_group\_name) | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the existing resource group in which to deploy the Azure Container App(s) | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign to all new resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aca_fqdns"></a> [aca\_fqdns](#output\_aca\_fqdns) | Map of Azure Container Apps and respective fully-qualified domain names (FQDNs) |
