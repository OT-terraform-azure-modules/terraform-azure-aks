variable "public_ssh_key" {
  description = "A custom ssh key to control access to the AKS cluster"
  type        = string
  default     = ""
}

variable "agents_tags" {
  description = "(Optional) A mapping of tags to assign to the Node Pool."
  type        = map(string)
  default = {
    role = "AKS"
    type = "cluster"
  }
}

variable "tags" {
  type        = map(string)
  description = "Any tags that should be present on the Virtual Network resources"
  default = {
    platform = "Azure"
    owner    = "Opstree"
    env      = "testing"
  }
}
variable "network_plugin" {
  type        = string
  default     = "kubenet"
  description = "(Required) Network plugin to use for networking. Currently supported values are azure and kubenet"
}
variable "net_profile_pod_cidr" {
  type        = string
  default     = "170.0.0.0/16"
  description = "(Optional)The CIDR to use for pod IP addresses. This field can only be set when network_plugin is set to kubenet."
}

variable "network_policy" {
  type        = string
  default     = "calico"
  description = "(Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created."
}

