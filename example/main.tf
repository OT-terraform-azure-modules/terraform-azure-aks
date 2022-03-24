
provider "azurerm" {
  features {}

  subscription_id = "a58cafae-2cce-4b17-ac7b-f73f02077cc7"
  client_id       = "ad507a18-1329-4900-bb5b-dedddbb6e832"
  client_secret   = "5MFeVqxGqAhbsV.yPZdBhBpQthZAHxxV5G"
  tenant_id       = "c3f5280f-05f1-48f8-9369-cc5c7978c463"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.99.0"
    }
  }
}

data "azurerm_resource_group" "example" {
  name = "himanshi-rg"
}

module "vnet" {
  source                      = "OT-terraform-azure-modules/virtual-network/azure"
  resource_group_name         = data.azurerm_resource_group.example.name
  resource_group_location     = data.azurerm_resource_group.example.location
  address_space               = ["192.168.0.0/16"]
  vnet_name                   = "kritarth-vnet"
  dns_servers                 = ["192.168.0.4", "192.168.0.5"]
  create_ddos_protection_plan = false
  tag_map = {
    name = "vnet"
  }
}

module "aks" {
  source              = "../"
  vnet_name           = module.vnet.vnet_name
  aks_name            = var.aks_name
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  dns_prefix          = var.aks_dns_prefix
  vm_size             = var.aks_vm_size
  availability_zones  = var.aks_availability_zones
  node_type           = var.aks_node_type
  max_count           = var.aks_max_count
  min_count           = var.aks_min_count
  node_count          = var.aks_min_count
  vnet_subnet_id      = module.aks.subnet_id
  tagMap              = var.tagMap
}


