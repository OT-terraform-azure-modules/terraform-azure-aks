Terraform Module for deploying an AKS cluster
=====================================

[![Opstree Solutions][opstree_avatar]][opstree_homepage]

[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png



- This terraform module will create a AKS Cluster.
- This projecct is a part of opstree's ot-azure initiative for terraform modules.


Usage
------


```hcl
module "aks_subnet" {
  source         = "./modules/subnet"
  subnet_name    = var.aks_subnet_name
  subnet_rg      = var.rg_name
  vnet_name      = var.vnet_name
  address_prefix = var.aks_address_prefix
}


module "aks" {
  source              = "./modules/aks"
  aks_name            = var.aks_name
  location            = var.rg_location
  rg_name             = var.rg_name
  dns_prefix          = var.aks_dns_prefix
  vm_size             = var.aks_vm_size
  availability_zones  = var.aks_availability_zones
  node_type           = var.aks_node_type
  max_count           = var.aks_max_count
  min_count           = var.aks_min_count
  node_count          = var.aks_min_count
  vnet_subnet_id      = module.aks_subnet.subnet_id
  tagMap              = var.tagMap
}


```

```sh

$   cat output.tf
/*-------------------------------------------------------*/
output "aks_id" {
  value       = azurerm_kubernetes_cluster.aks.id
  description = "ID of the AKS cluster"
}



/*-------------------------------------------------------*/
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| subnet_name | Name of the subnet for AKS subnet module | string | aks_subnet | no |
| subnet_rg | RG of the subnet | string | myrg | no |
| vnet_name | Name of the vnet | string | myvnet | no |
| address_prefix | Subnet address space for AKS subnet module | string | null | yes |
| aks_name | Name of the cluster | string | bpaks | no |
| location | Name of cluster Location | string | eastus | no |
| rg_name | Name of cluster Resource Group | string | myrg | no |
| dns_prefix | DNS prefix for the cluster | string | buildpiperaks | no |
| vm_size |  size of the cluster | string | Standard_DS1_v2 | no |
| availability_zones | Availability Zones which the Node Pool should be spread | number | 1 | no |
| node_type | Type of node pool | string | VirtualMachineScaleSets | no |
| max_count | Max number of nodes in the pool | number | 2 | no |
| min_count | Min number of nodes in the pool | number | 1 | no |
| node_count | Node count in the pool(please change the node count as per your requirement in main.tf under the condition) | number | 1 | no |
| vnet_subnet_id | Subnet to lauch the nodes in | string | aks_subnet.subnet_id | no |
| tagMap | A mapping of tags to assign to the resource | map(string) | buildpiper | no |


## Outputs

| Name | Description |
|------|-------------|
| aks_id | ID of the AKS cluster |



### Contributors
