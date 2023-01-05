data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_log_analytics_workspace" "laws" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group_name == "" ? data.azurerm_resource_group.rg.name : var.log_analytics_workspace_resource_group_name
}

resource "azapi_resource" "aca_env" {
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  parent_id = data.azurerm_resource_group.rg.id
  location  = data.azurerm_resource_group.rg.location
  name      = var.azure_container_apps_environment_name
  tags      = var.tags

  body = jsonencode({
    properties = {
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = data.azurerm_log_analytics_workspace.laws.workspace_id
          sharedKey  = data.azurerm_log_analytics_workspace.laws.primary_shared_key
        }
      }
    }
  })
}

data "azurerm_storage_account" "aca_env_storages" {
  for_each = var.azure_files_volumes_map

  name                = each.value.account_name
  resource_group_name = each.value.account_resource_group_name
}

resource "azapi_resource" "aca_env_storages" {
  for_each = var.azure_files_volumes_map

  type      = "Microsoft.App/managedEnvironments/storages@2022-03-01"
  parent_id = azapi_resource.aca_env.id
  name      = each.key
  tags      = var.tags

  body = jsonencode({
    properties = {
      azureFile = {
        accessMode  = each.value.access_mode
        accountKey  = each.value.account_key != null ? each.value.account_key : data.azurerm_storage_account.aca_env_storages[each.key].primary_access_key
        accountName = each.value.account_name
        shareName   = each.value.share_name
      }
    }
  })
}

resource "azapi_resource" "aca" {
  for_each = var.azure_container_apps_map

  type      = "Microsoft.App/containerApps@2022-03-01"
  parent_id = azapi_resource.aca_env.parent_id
  location  = azapi_resource.aca_env.location
  name      = try(each.value.name, each.key)
  tags      = var.tags

  body = jsonencode({
    properties = {
      managedEnvironmentId = azapi_resource.aca_env.id
      configuration = {
        activeRevisionsMode = each.value.active_revisions_mode
        dapr                = each.value.dapr_configuration
        registries          = each.value.registries_configuration
        secrets             = local.aca_secrets_map[each.key]
        ingress = {
          allowInsecure = each.value.ingress_allow_insecure
          customDomains = each.value.ingress_custom_domains
          external      = each.value.ingress_allow_external
          targetPort    = each.value.ingress_target_port
          transport     = each.value.ingress_transport
          traffic = [
            {
              latestRevision = true
              weight         = 100
            }
          ]
        }
      }
      template = {
        containers = local.aca_containers_map[each.key]
        volumes    = local.aca_volumes_map[each.key]
        scale = {
          minReplicas = each.value.min_replicas
          maxReplicas = each.value.max_replicas
          rules       = each.value.scale_rules
        }
      }
    }
  })

  response_export_values = [
    "properties.configuration.ingress.fqdn"
  ]
}