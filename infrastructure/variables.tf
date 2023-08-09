variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "rg-finalproj"
}
variable "aks_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "aks_cluster_finalproj"
}
variable "rg-location" {
  description = "Region to depoy"
  type = string
  default = "West Europe"
}