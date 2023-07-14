output "vm_id" {
  value       = azurerm_linux_virtual_machine.vm.id
  description = "Virtual Machine ID"
}

output "public_ip" {
  value       = azurerm_linux_virtual_machine.vm.public_ip_address
  description = "Public IPv4 for the Virtual Machine"
}

output "admin_username" {
  value       = var.server_admin_name
  description = "Admin Username"
}

output "ssh_public_key" {
  value       = tls_private_key.vm.public_key_openssh
  description = "Public SSH Key"
}