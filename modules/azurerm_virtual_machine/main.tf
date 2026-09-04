data "azurerm_subnet" "this" {
    for_each = var.vms
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.rg_name
}
data "azurerm_public_ip" "this" {
    for_each = var.vms
  name                = each.value.pip_name
  resource_group_name = each.value.rg_name
}

resource "azurerm_network_interface" "this" {
    for_each = var.vms
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     =  data.azurerm_subnet.this[each.key].id
    public_ip_address_id = data.azurerm_public_ip.this[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "this" {
    for_each = var.vms
  name                = each.value.vm_name
  resource_group_name = each.value.rg_name
  location            = each.value.location
  size                = each.value.vm_size
  admin_username      = each.value.user_name
  admin_password = each.value.user_password
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.this[each.key].id]
  os_disk {
    caching              = each.value.caching
    storage_account_type = each.value.storage_account_type
  }

  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }
}