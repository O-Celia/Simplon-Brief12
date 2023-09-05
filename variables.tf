variable "resource_group" {
    type = string
    description = "Resource group for Brief12"
}

variable "location" {
    type = string
    description = "Location for Brief12"
}

variable "virtual_network" {
    type = string
    description = "Virtual network for Brief12"
}

variable "virtual_network_address_space" {
    description = "Address space for the Azure Virtual Network"
    type        = list(string)
}

variable "subnet_name" {
    description = "Name of the Azure Subnet for Brief12"
    type = string
}

variable "subnet_app_address_prefix" {
    description = "Address prefix for the Application Subnet"
    type        = list(string)
}

variable "nic_app_name" {
  description = "Name of the Azure Network Interface for Brief12"
  type        = string
}

variable "nsg_app_name" {
  description = "Name of the Azure Network Security Group for Brief12"
  type        = string
}

variable "public_ip_nat_name" {
  description = "Name of the Azure Public IP for NAT Gateway"
  type        = string
}

variable "nat_gateway_name" {
  description = "Name of the Azure NAT Gateway"
  type        = string
}

variable "subnet_gateway_name" {
  description = "Name of the Azure Subnet for Gateway"
  type        = string
}

variable "public_ip_gateway_name" {
  description = "Name of the Azure Public IP for Gateway"
  type        = string
}

variable "application_gateway_name" {
  description = "Name of the Azure Application Gateway"
  type        = string
}

variable "subnet_gateway_address_prefix" {
  description = "Address prefix for the Gateway Subnet"
  type        = list(string)
}

variable "nic_app_config" {
    description = "network_interface_config"
    type = string
}

variable "aks_cluster_name" {
    description = "Cluster for Brief12"
    type    = string
}