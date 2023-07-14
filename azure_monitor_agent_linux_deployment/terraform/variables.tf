variable "location" {
  type        = string
  default     = "westeurope"
  description = "Location of all resources deployed."
}

variable "log_rg_name" {
  type        = string
  default     = "rg_loganalytics"
  description = "The Log Analytics Resource Group name."
}


variable "log_name" {
  type        = string
  default     = "loganalytics"
  description = "The Log Analytics name."
}

variable "data_collection_endpoint_name" {
  type        = string
  default     = "dce-vm"
  description = "The Data Collection Endpoint name."
}

variable "data_collection_rule_name" {
  type        = string
  default     = "dcr-vm"
  description = "The Data Collection Rule name."
}

variable "data_collection_rule_association_name" {
  type        = string
  default     = "dcrta-vm"
  description = "The Data Collection Rule Association name."
}

variable "net_rg_name" {
  type        = string
  default     = "rg-vnet"
  description = "The Virtual Network Resource Group name."
}

variable "vnet_name" {
  type        = string
  default     = "vnet"
  description = "The Virtual Network name."
}

variable "vnet_range" {
  type        = string
  default     = "10.0.0.0/24"
  description = "The Virtual Network range."
}

variable "subnet_name" {
  type        = string
  default     = "subnet-vm"
  description = "The Virtual Network Subnet for Virtual Machine name."
}

variable "subnet_range" {
  type        = string
  default     = "10.0.0.0/26"
  description = "The Virtual Network Subnet for Virtual Machine range."
}

variable "vm_rg_name" {
  type        = string
  default     = "rg-vm"
  description = "The Virtual Machine Resource Group name."
}

variable "random_password_length" {
  type        = number
  default     = 64
  description = "The desired length of random password created for the VM."
}

variable "vm_nic_name" {
  type        = string
  default     = "vm-nic"
  description = "The Virtual Machine Network interface name."
}

variable "user_assigned_identity_name" {
  type        = string
  default     = "vm-id"
  description = "The Virtual Machine User Assigned Identity name."
}

variable "vm_name" {
  type        = string
  default     = "vm"
  description = "The Virtual Machine name."
}

variable "size" {
  type        = string
  default     = "Standard_B1s"
  description = "The Virtual Machine SKU size."
}

variable "server_admin_name" {
  type        = string
  default     = "sysadmin"
  description = "The Virtual Machine admin name."
}

variable "computer_name" {
  type        = string
  default     = "myvm"
  description = "The Virtual Machine computer name."
}