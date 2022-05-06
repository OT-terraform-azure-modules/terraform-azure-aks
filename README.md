Azure Kubernetes Service (AKS) Terraform Module
=====================================

[![Opstree Solutions][opstree_avatar]][opstree_homepage]

[Opstree Solutions][opstree_homepage]

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png

Azure Kubernetes Service is a managed container orchestration service based on the open source Kubernetes system, which is available on the Microsoft Azure public cloud. AKS can be use to handle critical functionality such as deploying, scaling and managing Docker containers and container-based applications. Benefits of AKS are flexibility, automation and reduced management overhead for administrators and developers. AKS nodes can scale up or down to accommodate fluctuations in resource demands. It simplifies managed Kubernetes cluster deployment in the public cloud environment and also manages health and monitoring of managed Kubernetes service.

- This terraform module will create a Azure Kubernetes Service(AKS) on azure.
- This project is a part of opstree's ot-azure initiative for terraform modules.

**Note : For more information, you can check example folder.**

## Terraform versions
------------------
Terraform 1.1.6

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_user_assigned_identity.aks_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_log_analytics_workspace.log](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |

## Module Usage

```hcl

#Enter the name of Resource group you want to make.

module "resource_group" {
  source                  = "OT-terraform-azure-modules/resource-group/azure"
  resource_group_name     = "aks-rg"
  resource_group_location = "eastus"

  tag_map = {
    Name = "AKSRG"
  }
}

# SSH-key module for accessing the cluster
module "ssh-key" {
  source         = "./key"
  public_ssh_key = var.public_ssh_key == "" ? "" : var.public_ssh_key
}

# Azure Kubernetes Service module

module "aks" {
  source                                    = "../"
  key_data                                  = replace(var.public_ssh_key == "" ? module.ssh-key.public_ssh_key : var.public_ssh_key, "\n", "")
  resource_group_name                       = module.res_group.resource_group_name
  location                                  = module.res_group.resource_group_location
  cluster_name                              = "testing-aks-cluster"
  cluster_log_analytics_workspace_name      = "Workspace-65775"
  prefix                                    = "prefix"
  admin_username                            = "azureuser"
  agents_size                               = "Standard_D2s_v3"
  log_analytics_workspace_sku               = "PerGB2018"
  log_retention_in_days                     = 30
  agents_count                              = 2
  tags                                      = var.tags
  os_disk_size_gb                           = "50"
  sku_tier                                  = "Free"
  enable_role_based_access_control          = true
  rbac_aad_managed                          = true
  network_policy                            = "calico"
  network_plugin                            = "kubenet"
  net_profile_dns_service_ip                = "10.0.0.10"
  net_profile_docker_bridge_cidr            = "170.10.0.1/16"
  net_profile_outbound_type                 = "loadBalancer"
  net_profile_pod_cidr                      = "170.0.0.0/16"
  net_profile_service_cidr                  = "10.0.0.0/16"
  kubernetes_version                        = "1.22.6"
  orchestrator_version                      = "1.22.6"
  agents_max_count                          = 2
  agents_min_count                          = 1
  agents_pool_name                          = "nodepool"
  agents_availability_zones                 = ["1", "2"]
  agents_labels                             = { "nodepool" : "defaultnodepool" }
  agents_type                               = "VirtualMachineScaleSets"
  agents_tags                               = var.agents_tags
  agents_max_pods                           = 100
  identity_type                             = "SystemAssigned"
}

```

Inputs
------
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | (Required) Name of the Managed Kubernetes Cluster | `string` |  | yes |
| resource_group_name | (Required) Name of the resource group where the Managed Kubernetes Cluster should exist | `string` |  | yes |
| location | (Required) The location where the Managed Kubernetes Cluster should be created | `string` |  | yes |
| key_data |  (Required) The Public SSH Key used to access the cluster. | `string` |  | yes |
| cluster_log_analytics_workspace_name | (Optional) Specifies the name of the Log Analytics Workspace. | `string` |  | no |
| client_id | (Optional) The Client ID (appId) for the Service Principal | `string` |  | no |
| client_secret | (Optional) The Client Secret (password) for the Service Principal | `string` |  | no |
| admin_username | (Required) The username of the local administrator to be created on the Kubernetes cluster | `string` |  | yes |
| agents_size | (Required) The virtual machine size for the Kubernetes agents | `string` |  | yes |
| log_analytics_workspace_sku | (Optional) Specifies the SKU of the Log Analytics Workspace | `string` | PerGB2018 | no |
| log_retention_in_days | (Optional) The workspace data retention in days | `number` | | no |
| agents_count | (Optional) Number of Agents that should exist in the Agent Pool | `number` | `` | no |
| enable_log_analytics_workspace | (Optional) Enable the creation of azurerm_log_analytics_workspace | `bool` | true | no |
| vnet_subnet_id | (Optional) The ID of a Subnet where the Kubernetes Node Pool should exist | `string` |  | no |
| os_disk_size_gb | Disk size of nodes in GBs | `number` |  | no |
| private_cluster_enabled | (Optional) Kubernetes cluster is private or public | `bool` | false | yes |
| enable_http_application_routing | (Optional) Enable HTTP Application Routing Addon | `bool` |  | no |
| enable_azure_policy | (Optional) Enable Azure Policy Addon | `bool` |  | No |
| sku_tier | (Optional) The SKU Tier that should be used for this Kubernetes Cluster | `string` | Free | No |
| enable_role_based_access_control | (Optional) Enable Role Based Access Control | `bool` | true | No |
| rbac_aad_managed | (Optional) Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration. | `bool` | false | no |
| rbac_aad_admin_group_object_ids | (Optional) Object ID of groups with admin access | `list(string)` |  | no |
| rbac_aad_client_app_id | The Client ID of an Azure Active Directory Application | `string` |  | yes |
| rbac_aad_server_app_id | The Server ID of an Azure Active Directory Application | `string` |  | yes |
| rbac_aad_server_app_secret |  The Server Secret of an Azure Active Directory Application | `string` |  | yes |
| network_policy | (Optional) Sets up network policy to be used | `string` |  | no |
| network_plugin | (Required) Network plugin to use for networking | `string` |  | yes |
| net_profile_dns_service_ip | (Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns) | `string` |  | no |
| net_profile_docker_bridge_cidr | (Optional) IP address (in CIDR notation) used as the Docker bridge IP address on nodes | `string` |  | no |
| net_profile_outbound_type | (Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster | `string` | loadBalancer | no |
| net_profile_pod_cidr | (Optional) The CIDR to use for pod IP addresses. | `string` |  | no |
| net_profile_service_cidr | (Optional) The Network Range used by the Kubernetes service | `string` |  | no |
| kubernetes_version | (Optional) Specify which Kubernetes release to use | `string` |  | no |
| orchestrator_version | (Optional) Specify which Kubernetes release to use for the orchestration layer | `string` |  | no |
| enable_auto_scaling | (Optional) Enable node pool autoscaling | `bool` | false | no |
| agents_max_count | (Required) Maximum number of nodes in a pool | `number` |  | yes |
| agents_min_count | (Required) Minimum number of nodes in a pool | `number` |  | yes |
| agents_pool_name | (Optional) The default Azure AKS agentpool (nodepool) name. | `string` | nodepool | no |
| enable_node_public_ip | (Optional) Enable node public ip if nodes in the Node Pool have a Public IP Address  | `bool` | false | no |
| agents_availability_zones | (Optional) A list of Availability Zones across which the Node Pool should be created | `list(string)` |  | no |
| agents_labels | (Optional) A map of Kubernetes labels which should be applied to nodes in the Default Node Pool | `map(string)` | {} | no |
| agents_type | (Optional) The type of Node Pool which should be created | `string` | VirtualMachineScaleSets | no |
| agents_tags | (Optional) A mapping of tags to assign to the Node Pool | `map(string)` |  | no |
| agents_max_pods | (Optional) The maximum number of pods that can run on each agent. | `number` |  | no |
| enable_ingress_application_gateway | Specify if Application Gateway ingress controller should be deployed to this Kubernetes Cluster | `bool` |  | no |
| ingress_application_gateway_id | (Optional) ID of the Application Gateway which will be integrated with the Kubernetes Cluster | `string` |  | no |
| ingress_application_gateway_name | (Optional) Name of the Application Gateway to be used or created which will be integrated with the Kubernetes Cluster | `string` |  | no |
| ingress_application_gateway_subnet_cidr | (Optional) Subnet CIDR to be used to create an Application Gateway, which will be integrated with ingress controller of the Kubernetes Cluster | `string` |  | no |
| ingress_application_gateway_subnet_id | (Optional) ID of the subnet used to create an Application Gateway, which will be integrated with ingress controller of the Kubernetes Cluster | `string` |  | no |
| identity_type | (Required) The type of identity used for the managed cluster | `string` |  | yes |
| enable_host_encryption | Enable Host Encryption for default node pool | `bool` | false | no |

## Output
------
| Name | Description |
|------|-------------|
| subnet_id | ID of the Subnet |


### Contributors

|  [![Himanshi Parnami][himanshi_avatar]][himanshi_homepage]<br/>[Himanshi Parnami][himanshi_homepage] | [![Rishabh Sharma][rishabh_avatar]][rishabh_homepage]<br/>[Rishabh Sharma][rishabh_homepage] |
|---|---|

  [himanshi_homepage]: https://gitlab.com/himanshiparnami
  [himanshi_avatar]: https://gitlab.com/uploads/-/system/user/avatar/10920273/avatar.png?width=400
  [rishabh_homepage]: https://www.linkedin.com/in/rishabh-sharma-b4a0b3152
  [rishabh_avatar]: https://gitlab.com/uploads/-/system/user/avatar/9890362/avatar.png?width=400
