locals {
  name_suffix = var.name != null ? "-${var.name}" : ""

  azure_name                  = "${var.azure_resource_prefix}-${var.service_short}-${var.environment}-redis${local.name_suffix}"
  azure_private_endpoint_name = "${var.azure_resource_prefix}-${var.service_short}-${var.environment}-redis${local.name_suffix}-pe"

  kubernetes_name = "${var.service_short}-${var.environment}-redis${local.name_suffix}"
}

# Azure

resource "azurerm_redis_cache" "main" {
  count = var.use_azure ? 1 : 0

  name                          = local.azure_name
  location                      = data.azurerm_resource_group.main[0].location
  resource_group_name           = data.azurerm_resource_group.main[0].name
  capacity                      = var.azure_capacity
  family                        = var.azure_family
  sku_name                      = var.azure_sku_name
  minimum_tls_version           = var.azure_minimum_tls_version
  public_network_access_enabled = var.azure_public_network_access_enabled
  redis_version                 = var.server_version

  redis_configuration {
    maxmemory_policy = var.azure_maxmemory_policy
  }

  timeouts {
    create = "30m"
    update = "30m"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

  dynamic "patch_schedule" {
    for_each = var.azure_patch_schedule

    content {
      day_of_week        = patch_schedule.value.day_of_week
      start_hour_utc     = patch_schedule.value.start_hour_utc
      maintenance_window = patch_schedule.value.maintenance_window
    }
  }
}

resource "azurerm_private_endpoint" "main" {
  count = var.use_azure ? 1 : 0

  name                = local.azure_private_endpoint_name
  location            = data.azurerm_resource_group.main[0].location
  resource_group_name = data.azurerm_resource_group.main[0].name
  subnet_id           = data.azurerm_subnet.main[0].id

  private_dns_zone_group {
    name                 = data.azurerm_private_dns_zone.main[0].name
    private_dns_zone_ids = [data.azurerm_private_dns_zone.main[0].id]
  }

  private_service_connection {
    name                           = local.azure_private_endpoint_name
    private_connection_resource_id = azurerm_redis_cache.main[0].id
    is_manual_connection           = false
    subresource_names              = ["redisCache"]
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_monitor_metric_alert" "memory" {
  count = var.use_azure && var.azure_enable_monitoring ? 1 : 0

  name                = "${azurerm_redis_cache.main[0].name}-memory"
  resource_group_name = data.azurerm_resource_group.main[0].name
  scopes              = [azurerm_redis_cache.main[0].id]
  description         = "Action will be triggered when memory use is greater than 60%"

  criteria {
    metric_namespace = "Microsoft.Cache/redis"
    metric_name      = "allusedmemorypercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.azure_memory_threshold
  }

  action {
    action_group_id = data.azurerm_monitor_action_group.main[0].id
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Kubernetes

resource "kubernetes_deployment" "main" {
  count = var.use_azure ? 0 : 1

  metadata {
    name      = local.kubernetes_name
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = local.kubernetes_name
      }
    }
    template {
      metadata {
        labels = {
          app = local.kubernetes_name
        }
      }
      spec {
        node_selector = {
          "kubernetes.io/os" : "linux"
        }
        container {
          name  = local.kubernetes_name
          image = "redis:${var.server_version}-alpine"
          resources {
            requests = {
              cpu    = "100m"
              memory = "256Mi"
            }
            limits = {
              cpu    = "250m"
              memory = "1Gi"
            }
          }
          port {
            container_port = 6379
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "main" {
  count = var.use_azure ? 0 : 1

  metadata {
    name      = local.kubernetes_name
    namespace = var.namespace
  }
  spec {
    port {
      port = 6379
    }
    selector = {
      app = local.kubernetes_name
    }
  }
}
