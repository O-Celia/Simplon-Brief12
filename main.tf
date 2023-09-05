module "network" {
  source = "./module"

  resource_group                = var.resource_group
  location                      = var.location
  virtual_network               = var.virtual_network
  virtual_network_address_space = var.virtual_network_address_space
  subnet_name                   = var.subnet_name
  subnet_app_address_prefix     = var.subnet_app_address_prefix
  nic_app_name                  = var.nic_app_name
  nsg_app_name                  = var.nsg_app_name
  public_ip_nat_name            = var.public_ip_nat_name
  nat_gateway_name              = var.nat_gateway_name
  subnet_gateway_name           = var.subnet_gateway_name
  public_ip_gateway_name        = var.public_ip_gateway_name
  application_gateway_name      = var.application_gateway_name
  subnet_gateway_address_prefix = var.subnet_gateway_address_prefix
  nic_app_config                = var.nic_app_config
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = module.network.location
  resource_group_name = module.network.resource_group
  dns_prefix          = var.aks_cluster_name

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_A2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}