<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.61.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.61.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_log_analytics_workspace.log](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_data_collection_endpoint.log](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_endpoint) | resource |
| [azurerm_monitor_data_collection_rule.log](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule) | resource |
| [azurerm_monitor_data_collection_rule_association.vm_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |
| [azurerm_monitor_data_collection_rule_association.vm_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |
| [azurerm_network_interface.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.net](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.log](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.net](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.net](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.net](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_user_assigned_identity.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_machine_extension.azure_monitor_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_network.net](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [tls_private_key.vm](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_computer_name"></a> [computer\_name](#input\_computer\_name) | The Virtual Machine computer name. | `string` | `"myvm"` | no |
| <a name="input_data_collection_endpoint_name"></a> [data\_collection\_endpoint\_name](#input\_data\_collection\_endpoint\_name) | The Data Collection Endpoint name. | `string` | `"dce-vm"` | no |
| <a name="input_data_collection_rule_association_name"></a> [data\_collection\_rule\_association\_name](#input\_data\_collection\_rule\_association\_name) | The Data Collection Rule Association name. | `string` | `"dcrta-vm"` | no |
| <a name="input_data_collection_rule_name"></a> [data\_collection\_rule\_name](#input\_data\_collection\_rule\_name) | The Data Collection Rule name. | `string` | `"dcr-vm"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of all resources deployed. | `string` | `"westeurope"` | no |
| <a name="input_log_name"></a> [log\_name](#input\_log\_name) | The Log Analytics name. | `string` | `"loganalytics"` | no |
| <a name="input_log_rg_name"></a> [log\_rg\_name](#input\_log\_rg\_name) | The Log Analytics Resource Group name. | `string` | `"rg_loganalytics"` | no |
| <a name="input_net_rg_name"></a> [net\_rg\_name](#input\_net\_rg\_name) | The Virtual Network Resource Group name. | `string` | `"rg-vnet"` | no |
| <a name="input_random_password_length"></a> [random\_password\_length](#input\_random\_password\_length) | The desired length of random password created for the VM. | `number` | `64` | no |
| <a name="input_server_admin_name"></a> [server\_admin\_name](#input\_server\_admin\_name) | The Virtual Machine admin name. | `string` | `"sysadmin"` | no |
| <a name="input_size"></a> [size](#input\_size) | The Virtual Machine SKU size. | `string` | `"Standard_B1s"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The Virtual Network Subnet for Virtual Machine name. | `string` | `"subnet-vm"` | no |
| <a name="input_subnet_range"></a> [subnet\_range](#input\_subnet\_range) | The Virtual Network Subnet for Virtual Machine range. | `string` | `"10.0.0.0/26"` | no |
| <a name="input_user_assigned_identity_name"></a> [user\_assigned\_identity\_name](#input\_user\_assigned\_identity\_name) | The Virtual Machine User Assigned Identity name. | `string` | `"vm-id"` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | The Virtual Machine name. | `string` | `"vm"` | no |
| <a name="input_vm_nic_name"></a> [vm\_nic\_name](#input\_vm\_nic\_name) | The Virtual Machine Network interface name. | `string` | `"vm-nic"` | no |
| <a name="input_vm_rg_name"></a> [vm\_rg\_name](#input\_vm\_rg\_name) | The Virtual Machine Resource Group name. | `string` | `"rg-vm"` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The Virtual Network name. | `string` | `"vnet"` | no |
| <a name="input_vnet_range"></a> [vnet\_range](#input\_vnet\_range) | The Virtual Network range. | `string` | `"10.0.0.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username) | Admin Username |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Public IPv4 for the Virtual Machine |
| <a name="output_ssh_public_key"></a> [ssh\_public\_key](#output\_ssh\_public\_key) | Public SSH Key |
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | Virtual Machine ID |
<!-- END_TF_DOCS -->