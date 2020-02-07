variable "resource_group_name" {
  type        = "string"
  description = "Name of the azure resource group."
  default     = "tf_demo_network"
}
variable "resource_group_location" {
  type        = "string"
  description = "Location of the azure resource group."
  default     = "westus2"
}
variable "network-range" {
  type        = "string"
  default     = "10.0"
}