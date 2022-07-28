resource "azurerm_linux_virtual_machine" "mtc-vm" {
  name                  = "VM Name"
  resource_group_name   = azurerm_resource_group.mtc_resources.name
  location              = azurerm_resource_group.mtc_resources.location
  size                  = "Standard_B1ls"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.mtc-nic.id]

  custom_data = filebase64("customdata.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/SSH KEY NAME")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-script.tpl", {
      hostname     = self.public_ip_address,
      user         = "adminuiser",
      identityfile = "~/.ssh/SSH KEY NAME"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]

  }

  tags = {
    environment = "dev"
  }
}