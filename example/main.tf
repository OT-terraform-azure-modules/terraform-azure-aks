terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.99.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  skip_provider_registration = true
}


module "ssh-key" {
  source         = "./key"
  public_ssh_key = var.public_ssh_key == "" ? "" : var.public_ssh_key
}

module "aks" {
  source                               = "../"
  key_data                             = replace(var.public_ssh_key == "" ? module.ssh-key.public_ssh_key : var.public_ssh_key, "\n", "")
  resource_group_name                  = "himanshi_rg"
  location                             = "Australia East"
  cluster_name                         = "testing-aks-cluster"
  cluster_log_analytics_workspace_name = "Workspace-65775"
  prefix                               = "prefix"
  client_id                            = ""
  client_secret                        = ""
  admin_username                       = "azureuser"
  agents_size                          = "Standard_D2s_v3"
  log_analytics_workspace_sku          = "PerGB2018"
  log_retention_in_days                = 30
  agents_count                         = 2
  tags                                 = var.tags
  enable_log_analytics_workspace       = true
  #vnet_subnet_id                          = "null"
  os_disk_size_gb                    = "50"
  private_cluster_enabled            = true
  enable_kube_dashboard              = false
  enable_http_application_routing    = false
  enable_azure_policy                = false
  sku_tier                           = "Free"
  enable_role_based_access_control   = true
  rbac_aad_managed                   = true
  rbac_aad_admin_group_object_ids    = null
  rbac_aad_client_app_id             = "535f09e1-2b3c-45ba-90ca-bb66f8bf4236"
  rbac_aad_server_app_id             = "c48240e1-bfe3-445c-8d08-f859ddc3db4d"
  rbac_aad_server_app_secret         = "nXv8Q~kgo0nHrl9EdklBH_RxbguLWOpDYy6dVbkw"
  network_policy                     = "calico"
  network_plugin                     = "azure"
  net_profile_dns_service_ip         = "10.0.0.10"
  net_profile_docker_bridge_cidr     = "170.10.0.1/16"
  net_profile_outbound_type          = "loadBalancer"
  net_profile_pod_cidr               = "170.0.0.0/16"
  net_profile_service_cidr           = "10.0.0.0/16"
  kubernetes_version                 = "1.22.6"
  orchestrator_version               = "1.22.6"
  enable_auto_scaling                = false
  agents_max_count                   = 2
  agents_min_count                   = 1
  agents_pool_name                   = "nodepool"
  enable_node_public_ip              = false
  agents_availability_zones          = ["1", "2"]
  agents_labels                      = { "nodepool" : "defaultnodepool" }
  agents_type                        = "VirtualMachineScaleSets"
  agents_tags                        = var.agents_tags
  agents_max_pods                    = 100
  enable_ingress_application_gateway = null
  # ingress_application_gateway_id          = ""
  # ingress_application_gateway_name        = ""
  # ingress_application_gateway_subnet_cidr = ""
  # ingress_application_gateway_subnet_id   = ""
  identity_type             = "SystemAssigned"
  user_assigned_identity_id = "null"
  enable_host_encryption    = false
}
