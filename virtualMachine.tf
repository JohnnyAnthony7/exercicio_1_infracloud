resource "azurerm_linux_virtual_machine" "vm_atividade" {
    name                  = "virtualMachine"
    location              = "brazilsouth"
    resource_group_name   = azurerm_resource_group.rg_atividade.name
    network_interface_ids = [azurerm_network_interface.nic_atividade.id]
    size                  = "Standard_E2bs_v5"

    os_disk {
        name              = "discoVM"
        caching           = "ReadWrite" 
        storage_account_type = "Premium_LRS"
    }

    # manter padrão
    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "killyVM"
    admin_username = "killyADM"
    admin_password = "3ss4eaS3nh@"
    disable_password_authentication = false

    

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.saAtividade.primary_blob_endpoint
    }

    depends_on = [ azurerm_resource_group.rg_atividade ]
}

resource "null_resource" "apache_atividade" {
  connection {
    type = "ssh"
    host = data.azurerm_public_ip.ip_atividade.ip_address
    user = "killyADM"
    password = "3ss4eaS3nh@"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y apache2",
    ]
  }

  depends_on = [
    azurerm_linux_virtual_machine.vm_atividade
  ]
}
