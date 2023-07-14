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

# Deploy the Azure data collection endpoint for monitoring windows virtual machines.
resource "azurerm_monitor_data_collection_endpoint" "log" {
  name                = var.data_collection_endpoint_name
  location            = azurerm_resource_group.log.location
  resource_group_name = azurerm_resource_group.log.name
  kind                = "Windows"
  description         = "Data collection endpoint for Windows"
}

resource "azurerm_log_analytics_solution" "windows_event_forwarding" {
  solution_name         = "WindowsEventForwarding"
  location              = azurerm_resource_group.log.location
  resource_group_name   = azurerm_resource_group.log.name
  workspace_resource_id = azurerm_log_analytics_workspace.log.id
  workspace_name        = azurerm_log_analytics_workspace.log.name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/WindowsEventForwarding"
  }
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

  data_flow {
    streams      = ["Microsoft-Event"]
    destinations = [azurerm_log_analytics_workspace.log.name]
  }

  data_sources {
    syslog {
      facility_names = ["*"]
      log_levels     = ["*"]
      name           = "datasource-syslog"
    }

    performance_counter {
      streams                       = ["Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\Processor Information(_Total)\\% Processor Time",
        "\\Processor Information(_Total)\\% Privileged Time",
        "\\Processor Information(_Total)\\% User Time",
        "\\Processor Information(_Total)\\Processor Frequency",
        "\\System\\Processes",
        "\\Process(_Total)\\Thread Count",
        "\\Process(_Total)\\Handle Count",
        "\\System\\System Up Time",
        "\\System\\Context Switches/sec",
        "\\System\\Processor Queue Length",
        "\\Memory\\% Committed Bytes In Use",
        "\\Memory\\Available Bytes",
        "\\Memory\\Committed Bytes",
        "\\Memory\\Cache Bytes",
        "\\Memory\\Pool Paged Bytes",
        "\\Memory\\Pool Nonpaged Bytes",
        "\\Memory\\Pages/sec",
        "\\Memory\\Page Faults/sec",
        "\\Process(_Total)\\Working Set",
        "\\Process(_Total)\\Working Set - Private",
        "\\LogicalDisk(_Total)\\% Disk Time",
        "\\LogicalDisk(_Total)\\% Disk Read Time",
        "\\LogicalDisk(_Total)\\% Disk Write Time",
        "\\LogicalDisk(_Total)\\% Idle Time",
        "\\LogicalDisk(_Total)\\Disk Bytes/sec",
        "\\LogicalDisk(_Total)\\Disk Read Bytes/sec",
        "\\LogicalDisk(_Total)\\Disk Write Bytes/sec",
        "\\LogicalDisk(_Total)\\Disk Transfers/sec",
        "\\LogicalDisk(_Total)\\Disk Reads/sec",
        "\\LogicalDisk(_Total)\\Disk Writes/sec",
        "\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer",
        "\\LogicalDisk(_Total)\\Avg. Disk sec/Read",
        "\\LogicalDisk(_Total)\\Avg. Disk sec/Write",
        "\\LogicalDisk(_Total)\\Avg. Disk Queue Length",
        "\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length",
        "\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length",
        "\\LogicalDisk(_Total)\\% Free Space",
        "\\LogicalDisk(_Total)\\Free Megabytes",
        "\\Network Interface(*)\\Bytes Total/sec",
        "\\Network Interface(*)\\Bytes Sent/sec",
        "\\Network Interface(*)\\Bytes Received/sec",
        "\\Network Interface(*)\\Packets/sec",
        "\\Network Interface(*)\\Packets Sent/sec",
        "\\Network Interface(*)\\Packets Received/sec",
        "\\Network Interface(*)\\Packets Outbound Errors",
        "\\Network Interface(*)\\Packets Received Errors"
      ]
      name = "datasource-perfcounter"
    }

    windows_event_log {
      streams = ["Microsoft-WindowsEvent"]
      x_path_queries = [
        "Application!*[System[(Level=1 or Level=2 or Level=3)]]",
        "Security!*[System[(band(Keywords,13510798882111488))]]",
        "System!*[System[(Level=1 or Level=2 or Level=3)]]"
      ]
      name = "datasource-wineventlog"
    }
  }

  stream_declaration {
    stream_name = "Custom-MyTableRawData"
    column {
      name = "Time"
      type = "datetime"
    }
    column {
      name = "Computer"
      type = "string"
    }
    column {
      name = "AdditionalContext"
      type = "string"
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
  target_resource_id      = azurerm_windows_virtual_machine.vm.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.log.id
  description             = "Azure monitor data collection rule association on data collection endpoint ${azurerm_monitor_data_collection_rule.log.name} for virtual machine ${azurerm_windows_virtual_machine.vm.name}"
}

# Associate to a Data Collection Endpoint
resource "azurerm_monitor_data_collection_rule_association" "vm_endpoint" {
  target_resource_id          = azurerm_windows_virtual_machine.vm.id
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.log.id
  description                 = "Azure monitor data collection rule association on data collection endpoint ${azurerm_monitor_data_collection_rule.log.name} for virtual machine ${azurerm_windows_virtual_machine.vm.name}"
}