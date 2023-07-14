# Deploy Log Analytics

# Deploy Resource Group for log analytics
resource "azurerm_resource_group" "log" {
  name     = var.log_rg_name
  location = var.location
}

# Deploys the Log Analytics resource
resource "azurerm_log_analytics_workspace" "log" {
  name                = var.log_name
  location            = azurerm_resource_group.log.location
  resource_group_name = azurerm_resource_group.log.name
  sku                 = "PerGB2018"
}

# Deploy the Azure data collection endpoint for monitoring linux virtual machines.
resource "azurerm_monitor_data_collection_endpoint" "log" {
  name                = var.data_collection_endpoint_name
  location            = azurerm_resource_group.log.location
  resource_group_name = azurerm_resource_group.log.name
  kind                = "Linux"
  description         = "Data collection endpoint for Linux"
}

# Deploy data collection rules and link to the data collection endpoint.
resource "azurerm_monitor_data_collection_rule" "log" {
  name                        = var.data_collection_rule_name
  location                    = azurerm_resource_group.log.location
  resource_group_name         = azurerm_resource_group.log.name
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.log.id

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.log.id
      name                  = azurerm_log_analytics_workspace.log.name
    }
  }

  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = [azurerm_log_analytics_workspace.log.name]
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "Processor(*)\\% Processor Time",
        "Processor(*)\\% Idle Time",
        "Processor(*)\\% User Time",
        "Processor(*)\\% Nice Time",
        "Processor(*)\\% Privileged Time",
        "Processor(*)\\% IO Wait Time",
        "Processor(*)\\% Interrupt Time",
        "Processor(*)\\% DPC Time",
        "Memory(*)\\Available MBytes Memory",
        "Memory(*)\\% Available Memory",
        "Memory(*)\\Used Memory MBytes",
        "Memory(*)\\% Used Memory",
        "Memory(*)\\Pages/sec",
        "Memory(*)\\Page Reads/sec",
        "Memory(*)\\Page Writes/sec",
        "Memory(*)\\Available MBytes Swap",
        "Memory(*)\\% Available Swap Space",
        "Memory(*)\\Used MBytes Swap Space",
        "Memory(*)\\% Used Swap Space",
        "Logical Disk(*)\\% Free Inodes",
        "Logical Disk(*)\\% Used Inodes",
        "Logical Disk(*)\\Free Megabytes",
        "Logical Disk(*)\\% Free Space",
        "Logical Disk(*)\\% Used Space",
        "Logical Disk(*)\\Logical Disk Bytes/sec",
        "Logical Disk(*)\\Disk Read Bytes/sec",
        "Logical Disk(*)\\Disk Write Bytes/sec",
        "Logical Disk(*)\\Disk Transfers/sec",
        "Logical Disk(*)\\Disk Reads/sec",
        "Logical Disk(*)\\Disk Writes/sec",
        "Network(*)\\Total Bytes Transmitted",
        "Network(*)\\Total Bytes Received",
        "Network(*)\\Total Bytes",
        "Network(*)\\Total Packets Transmitted",
        "Network(*)\\Total Packets Received",
        "Network(*)\\Total Rx Errors",
        "Network(*)\\Total Tx Errors",
        "Network(*)\\Total Collisions"
      ]
      name = "datasource-perfcounter"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  description = "Data collection rule for logisation."
}

# Associate to a Data Collection Endpoint
resource "azurerm_monitor_data_collection_rule_association" "vm_rule" {
  name                    = var.data_collection_rule_association_name
  target_resource_id      = azurerm_linux_virtual_machine.vm.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.log.id
  description             = "Azure monitor data collection rule association on data collection endpoint ${azurerm_monitor_data_collection_rule.log.name} for virtual machine ${azurerm_linux_virtual_machine.vm.name}"
}

# Associate to a Data Collection Endpoint
resource "azurerm_monitor_data_collection_rule_association" "vm_endpoint" {
  target_resource_id          = azurerm_linux_virtual_machine.vm.id
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.log.id
  description                 = "Azure monitor data collection rule association on data collection endpoint ${azurerm_monitor_data_collection_rule.log.name} for virtual machine ${azurerm_linux_virtual_machine.vm.name}"
}