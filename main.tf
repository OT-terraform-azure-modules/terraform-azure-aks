resource "azurerm_subnet" "subnet" {
  name                 = "${var.aks_name}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.subnet_address_prefixs
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  private_cluster_enabled = true
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version      # default "1.19.11"

  default_node_pool {
    name                = "${var.aks_name}dp"
    vm_size             = var.vm_size
    availability_zones  = var.availability_zones
    type                = var.node_type
    enable_auto_scaling = var.enable_auto_scaling
    max_count           = var.max_count
    min_count           = var.min_count
    node_count          = var.node_count == false ? 0 : 1
    vnet_subnet_id      = azurerm_subnet.subnet.id
    
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tagMap
}

# [{vm_size, max, min, priority, ep, spot_max_price}]
resource "azurerm_kubernetes_cluster_node_pool" "aks_np" {
  name                  = "${var.aks_name}np"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.vm_size
  availability_zones    = var.availability_zones
  enable_auto_scaling   = var.enable_auto_scaling
  max_count             = var.max_count
  min_count             = var.min_count
  node_count            = var.node_count == false ? 0 : 3
  priority              = var.priority
  eviction_policy       = var.eviction_policy        # Default is "Deallocate"
  spot_max_price        = var.spot_max_price
  vnet_subnet_id        = azurerm_subnet.subnet.id
  tags = var.tagMap
}
