variable "resource_group_name" {
  type        = "string"
  description = "Name of the azure resource group."
  default     = "tf_demo_app"
}

variable "resource_group_location" {
  type        = "string"
  description = "Location of the azure resource group."
  default     = "westus2"
}

variable "network_storage_account_name" {
  type = "string"
}

variable "network_container_name" {
  type = "string"
}

variable "network_storage_key" {
  type = "string"
}

variable "network_access_key" {
  type = "string"
}

variable "vm_username" {
  type = "string"
}

variable "vm_password" {
  type = "string"
}