locals {
  aca_secrets_map = {
    for ca_key, ca in var.azure_container_apps_map : ca_key => [
      for secret_key, secret in ca.secrets : {
        name  = secret_key
        value = secret
      }
    ]
  }
  aca_volumes_map = {
    for ca_key, ca in var.azure_container_apps_map : ca_key => [
      for volume_name in ca.azurefile_volumes : {
        name        = volume_name
        storageName = volume_name
        storageType = "AzureFile"
      }
    ]
  }
  aca_containers_map = {
    for ca_key, ca in var.azure_container_apps_map : ca_key => [
      for container_key, container in ca.containers : {
        name      = container_key
        image     = container.image
        command   = container.command
        resources = container.resources
        volumeMounts = [
          for volumename, mountpath in lookup(ca, "volume_mounts", {}) : {
            volumeName = volumename
            mountPath  = mountpath
          }
        ]
        env = concat(
          [
            for env_key, env in container.env : {
              name      = env_key
              secretRef = trimprefix(env, "secretRef:")
              value     = ""
            } if startswith(env, "secretRef:")
          ],
          [
            for env_key, env in container.env : {
              name  = env_key
              value = env
            } if !startswith(env, "secretRef:")
          ]
        )
        # To do: Add probes
      }
    ]
  }
}