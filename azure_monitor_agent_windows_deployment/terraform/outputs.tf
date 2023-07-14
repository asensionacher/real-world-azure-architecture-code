output "vm_id" {
  value       = azurerm_windows_virtual_machine.vm.id
  description = "Virtual Machine ID"
}

output "public_ip" {
  value       = azurerm_windows_virtual_machine.vm.public_ip_address
  description = "Public IPv4 for the Virtual Machine"
}

output "admin_username" {
  value       = var.server_admin_name
  description = "Admin Username"
}

output "admin_password" {
  value       = random_password.vm.result
  description = "Admin Password"
  sensitive   = true
}