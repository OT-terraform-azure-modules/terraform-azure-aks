variable "subnet_address_prefixs" {
  default = ["192.168.0.0/24"]             #["10.0.0.0/24"]
  description = "Subnet address space"
}

variable "vnet_name" {
  description = "VNET Name where subnet will get attach"
}

variable "aks_name" {
  type        = string
  description = "Name of the cluster"
}

variable "location" {
  type        = string
  description = "Location of the cluster"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group for the cluster"
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix for the cluster"
}

variable "vm_size" {
  type        = string
  description = "Size of the VM nodes"
}

variable "kubernetes_version" {
  type        = string
  description = "kubernetes version for the cluster"
  default     = "1.21.9"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for the node pool"
}

variable "node_type" {
  type        = string
  description = "Type of node pool"
}

variable "enable_auto_scaling" {
  type        = bool
  default     = true
  description = "Enable autoscaling for the node pool"
}

variable "max_count" {
  type        = string
  description = "Max number of nodes in te pool"
}

variable "min_count" {
  type        = string
  description = "Min number of nodes in te pool"
}

variable "node_count" {
  #type        = string
  default = true
  description = "Node count in the pool"
}

variable "vnet_subnet_id" {
  type        = string
  description = "Subnet to lauch the nodes in"
}

# Node Pool Variables

variable "eviction_policy" {
  type        = string
  description = "Eviction policy for the pool"
  default     = "Deallocate"      
}

variable "priority" {
  type        = string
  default     = "Spot"
  description = "Priority of the node pool"
}

variable "spot_max_price" {
  type        = string
  default     = "-1"
  description = "Max spot price to pay"
}

variable "tagMap" {
  type = map(string)
}
