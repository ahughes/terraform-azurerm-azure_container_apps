variable "resource_group_name" {
  description = "Name of the existing resource group in which to deploy the Azure Container App(s)"
  type        = string
}
variable "log_analytics_workspace_name" {
  description = "Name of an existing Log Analytics Workspace to bind to the Azure Container Apps Environment"
  type        = string
}
variable "log_analytics_workspace_resource_group_name" {
  description = "Name of resource group containing existing Log Analytics Workspace (leave blank to use var.resource_group_name)"
  type        = string
  default     = ""
}
variable "azure_container_apps_environment_name" {
  description = "Name of Azure Container Apps Environment"
  type        = string
}
variable "azure_files_volumes_map" {
  description = "Map of Azure Files shares to map as volumes for containers to mount"
  type = map(object({
    access_mode                 = optional(string, "ReadWrite")
    account_key                 = optional(string)
    account_name                = string
    account_resource_group_name = string
    share_name                  = string
  }))
}
variable "azure_container_apps_map" {
  description = "Map of Azure Container Apps to be deployed to the ACA Environment"
  type = map(object({
    name                   = optional(string) # If unspecified, the map key will be used
    active_revisions_mode  = optional(string, "Single")
    azurefile_volumes      = optional(list(string), [])
    ingress_allow_external = optional(bool, true)
    ingress_allow_insecure = optional(bool, false)
    ingress_target_port    = optional(number, 80)
    ingress_transport      = optional(string, "Auto")
    max_replicas           = number
    min_replicas           = number
    secrets                = optional(map(string))
    containers = map(object({
      command      = optional(set(string))
      env          = optional(map(string), {})
      image        = string
      volumeMounts = optional(map(string))
      # To do: Add probes
      resources = object({
        cpu    = number
        memory = string
      })
    }))
    dapr_configuration = optional(object({
      appId       = string
      appPort     = number
      appProtocol = optional(string, "http")
      enabled     = optional(bool, true)
    }))
    ingress_custom_domains = optional(list(object({
      name          = string
      certificateId = string
      bindingType   = optional(string, "SniEnabled")
    })))
    registries_configuration = optional(list(object({
      identity          = optional(string)
      passwordSecretRef = optional(string)
      server            = optional(string)
      username          = optional(string)
    })))
    scale_rules = optional(list(object({
      name = string
      azureQueue = object({
        queueName   = string
        queueLength = number
        auth = list(object({
          secretRef        = string
          triggerParameter = string
        }))
      })
      # To do: Add http and custom scale rules
    })))
  }))
}
variable "tags" {
  description = "Tags to assign to all new resources"
  type        = map(string)
  default     = {}
}