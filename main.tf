data "azurerm_virtual_network" "example" {
  provider            = azurerm.connectivity
  name                = "alz-hub-weu"
  resource_group_name = "alz-connectivity"
}

resource "azurerm_route" "example" {
  for_each = toset(data.azurerm_virtual_network.example.vnet_peerings_addresses)
  provider            = azurerm.connectivity
  name                   = "onprem-to-${replace(each.key, "/", "-")}"
  resource_group_name    = "alz-connectivity"
  route_table_name       = "alz-gateway-routetable" # Gateway subnet route table
  address_prefix         = each.key
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.20.255.4" # Azure Firewall IP
}
