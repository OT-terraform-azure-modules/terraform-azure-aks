terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.99.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_subnet" "subnet" {
  name                 = "default"
  virtual_network_name = "test-vnet"
  resource_group_name  = "himanshi_rg"
}

module "ssh-key" {
  source         = "./key"
  public_ssh_key = var.public_ssh_key == "" ? "" : var.public_ssh_key
}

module "aks" {
  source                               = "../"
  key_data                             = replace(var.public_ssh_key == "" ? module.ssh-key.public_ssh_key : var.public_ssh_key, "\n", "")
  resource_group_name                  = "himanshi_rg"
  location                             = "eastus"
  cluster_name                         = "testing-aks-cluster"
  cluster_log_analytics_workspace_name = "Workspace-65775"
  prefix                               = "prefix"
  admin_username                       = "azureuser"
  agents_size                          = "Standard_D2s_v3"
  log_analytics_workspace_sku          = "PerGB2018"
  log_retention_in_days                = 30
  agents_count                         = 2
  tags                                 = var.tags
  os_disk_size_gb                      = "50"
  sku_tier                             = "Free"
  enable_role_based_access_control     = true
  rbac_aad_managed                     = false
  network_policy                       = "calico"
  network_plugin                       = "kubenet"
  net_profile_dns_service_ip           = "10.0.0.10"
  net_profile_docker_bridge_cidr       = "170.10.0.1/21"
  net_profile_outbound_type            = "loadBalancer"
  net_profile_pod_cidr                 = "170.0.0.0/21"
  net_profile_service_cidr             = "10.0.0.0/21"
  kubernetes_version                   = "1.22.6"
  orchestrator_version                 = "1.22.6"
  agents_max_count                     = 2
  agents_min_count                     = 1
  agents_pool_name                     = "nodepool"
  agents_availability_zones            = ["1", "2"]
  agents_labels                        = { "nodepool" : "defaultnodepool" }
  agents_type                          = "VirtualMachineScaleSets"
  agents_tags                          = var.agents_tags
  agents_max_pods                      = 100
  identity_type                        = "SystemAssigned"
  vnet_subnet_id                       = data.azurerm_subnet.subnet.id
  private_cluster_enabled              = false
}
