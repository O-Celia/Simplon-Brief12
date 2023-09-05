resource "azurerm_resource_group" "rg" {
  name      = var.resource_group
  location  = var.location
}

resource "azurerm_virtual_network" "network" {
  name                = var.virtual_network
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.virtual_network_address_space
}

resource "azurerm_subnet" "subnet_app" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = var.subnet_app_address_prefix
}

resource "azurerm_network_interface" "nic_app" {
  name                = var.nic_app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic_config"
    subnet_id                     = azurerm_subnet.subnet_app.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "nsg_app" {
  name                = var.nsg_app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "assoc-nic-nsg-app" {
  network_interface_id      = azurerm_network_interface.nic_app.id
  network_security_group_id = azurerm_network_security_group.nsg_app.id
}

resource "azurerm_nat_gateway" "nat_gw" {
  name                    = var.nat_gateway_name
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
}

resource "azurerm_public_ip" "public_ip_nat" {
  name                = var.public_ip_nat_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "gw_ip_a" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gw.id
  public_ip_address_id = azurerm_public_ip.public_ip_nat.id
}

resource "azurerm_subnet_nat_gateway_association" "gw_a" {
  subnet_id      = azurerm_subnet.subnet_app.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}

resource "azurerm_subnet" "subnet_gateway" {
  name                 = var.subnet_gateway_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = var.subnet_gateway_address_prefix
}

resource "azurerm_public_ip" "public_ip_gateway" {
  name                = var.public_ip_gateway_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "gateway" {
 name                = var.application_gateway_name
 resource_group_name = azurerm_resource_group.rg.name
 location            = azurerm_resource_group.rg.location

 sku {
   name     = "Standard_v2"
   tier     = "Standard_v2"
 }

 gateway_ip_configuration {
   name      = "ip-configuration"
   subnet_id = azurerm_subnet.subnet_gateway.id
 }

 frontend_port {
   name = "http"
   port = 80
 }

 frontend_ip_configuration {
   name                 = "front-ip"
   public_ip_address_id = azurerm_public_ip.public_ip_gateway.id
 }

 backend_address_pool {
   name = "backend_pool"
 }

 backend_http_settings {
   name                  = "http-settings"
   cookie_based_affinity = "Disabled"
   path                  = "/"
   port                  = 80
   protocol              = "Http"
   request_timeout       = 10
 }

 http_listener {
   name                           = "listener"
   frontend_ip_configuration_name = "front-ip"
   frontend_port_name             = "http"
   protocol                       = "Http"
 }

 request_routing_rule {
   name                       = "rule-1"
   rule_type                  = "Basic"
   http_listener_name         = "listener"
   backend_address_pool_name  = "backend_pool"
   backend_http_settings_name = "http-settings"
   priority                   = 100
 }

 autoscale_configuration {
   min_capacity = 1
 }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "poolbackend" {
 network_interface_id    = azurerm_network_interface.nic_app.id
 ip_configuration_name   = var.nic_app_config
 backend_address_pool_id = tolist(azurerm_application_gateway.gateway.backend_address_pool).0.id
}