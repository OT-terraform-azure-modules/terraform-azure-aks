variable "tagMap" {
  default = {
    app = "buildpiper"
  }
}

variable "resource_group_name" {
  default = "myrg"
}

variable "resource_group_location" {
  default = "eastus"
}

variable "vnet_name" {
  default = "myvnet"
}

# Variables for AKS
variable "aks_name" {
  default = "bpaks"
}

variable "aks_dns_prefix" {
  default = "buildpiperaks"
}

variable "aks_vm_size" {
  default = "standard_a2_v2"
}

variable "aks_availability_zones" {
  default = [1]
}

variable "aks_node_type" {
  default = "VirtualMachineScaleSets"
}

variable "aks_max_count" {
  default = 2
}

variable "aks_min_count" {
  default = 1
}

variable "aks_node_count" {
  default = 1
}

