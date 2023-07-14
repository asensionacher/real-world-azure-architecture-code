# Deploy Virtual Machine

# Deploy Resource Group for Virtual Machine
resource "azurerm_resource_group" "vm" {
  name     = var.vm_rg_name
  location = var.location
}

# Create a random password
resource "random_password" "vm" {
  length           = var.random_password_length
  special          = true
  override_special = "_%@"
}

# Deploy the Virtual Machine NIC
resource "azurerm_network_interface" "vm" {
  name                = var.vm_nic_name
  location            = azurerm_resource_group.vm.location
  resource_group_name = azurerm_resource_group.vm.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.net.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm.id
  }
}

# Create User assigned identity
resource "azurerm_user_assigned_identity" "vm" {
  location            = azurerm_resource_group.vm.location
  resource_group_name = azurerm_resource_group.vm.name
  name                = var.user_assigned_identity_name
}

# Create public ip for the VM
resource "azurerm_public_ip" "vm" {
  name                = "${var.vm_name}-pip"
  location            = azurerm_resource_group.vm.location
  resource_group_name = azurerm_resource_group.vm.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create a Windows VM
resource "azurerm_windows_virtual_machine" "vm" {
  depends_on          = [azurerm_log_analytics_workspace.log]
  name                = var.vm_name
  location            = azurerm_resource_group.vm.location
  resource_group_name = azurerm_resource_group.vm.name

  size = var.size

  admin_username = var.server_admin_name
  #admin_password = random_password.vm.result
  admin_password = "ElPato20142014"

  network_interface_ids = [azurerm_network_interface.vm.id]
  patch_mode            = "AutomaticByOS"

  provision_vm_agent = true
  computer_name      = var.computer_name

  license_type = "None"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.vm.id]
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  os_disk {
    name                 = "${var.vm_name}-os"
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"
  }
}

# Add new Azure Monitor Virtual machine extension for windows virtual machines. Replaces Log Analytics Extension.
resource "azurerm_virtual_machine_extension" "azure_monitor_windows" {
  depends_on = [
    azurerm_monitor_data_collection_rule_association.vm_rule,
    azurerm_monitor_data_collection_rule_association.vm_endpoint
  ]
  name                       = "Azure_Monitor_Windows_Agent"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true
  settings                   = <<SETTINGS
  {
    "authentication": {
      "managedIdentity": {
        "identifier-name": "mi_res_id",
         "identifier-value": "${azurerm_user_assigned_identity.vm.id}"
      }
    }
  }
  SETTINGS
}