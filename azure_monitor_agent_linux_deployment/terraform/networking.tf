# Deploy Networking resources

# Deploy Resource Group for networking
resource "azurerm_resource_group" "net" {
  name     = var.net_rg_name
  location = var.location
}

# Deploy virtual network
resource "azurerm_virtual_network" "net" {
  name                = var.vnet_name
  location            = azurerm_resource_group.net.location
  resource_group_name = azurerm_resource_group.net.name
  address_space       = [var.vnet_range]
}

# Create the subnet
resource "azurerm_subnet" "net" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.net.name
  virtual_network_name = azurerm_virtual_network.net.name
  address_prefixes     = [var.subnet_range]
}

resource "azurerm_network_security_group" "net" {
  name                = "${var.vm_name}-nsg"
  resource_group_name = azurerm_resource_group.net.name
  location            = azurerm_resource_group.net.location
  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "net" {
  subnet_id                 = azurerm_subnet.net.id
  network_security_group_id = azurerm_network_security_group.net.id
}