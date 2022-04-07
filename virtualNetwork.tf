# Virtual Network
resource "azurerm_virtual_network" "vnet_atividade" {
  name                = "virtualNetwork"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_atividade.location
  resource_group_name = azurerm_resource_group.rg_atividade.name

  tags = {
    environment = "aulaImpacta"
    turma = "FS04"
  }
}

# Subnet
resource "azurerm_subnet" "subnet_atividade" {
  name                 = "subNetwork"
  resource_group_name  = azurerm_resource_group.rg_atividade.name
  virtual_network_name = azurerm_virtual_network.vnet_atividade.name
  address_prefixes     = ["10.0.1.0/24"]
}

# IP Público
resource "azurerm_public_ip" "pip_atividade" {
  name                    = "publicIP"
  location                = azurerm_resource_group.rg_atividade.location
  resource_group_name     = azurerm_resource_group.rg_atividade.name
  allocation_method       = "Static"

  tags = {
    environment = "aulaImpacta"
    turma = "FS04"
    
  }
}

# Firewall
resource "azurerm_network_security_group" "nsg_atividade" {
  name                = "firewall"
  location            = azurerm_resource_group.rg_atividade.location
  resource_group_name = azurerm_resource_group.rg_atividade.name

  security_rule {
    name                       = "sshFirewall"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "aulaImpacta"
    turma = "FS04"
  }
}

# Placa de Rede / Network Interface
resource "azurerm_network_interface" "nic_atividade" {
  name                = "placaDeRede"
  location            = azurerm_resource_group.rg_atividade.location
  resource_group_name = azurerm_resource_group.rg_atividade.name

  ip_configuration {
    name                          = "ipInterface"
    subnet_id                     = azurerm_subnet.subnet_atividade.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip_atividade.id
  }
}


# Associação/Amarração do NIC com o NSG
resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc_atividade" {
  network_interface_id = azurerm_network_interface.nic_atividade.id
  network_security_group_id = azurerm_network_security_group.nsg_atividade.id
}


# Armazenamento da VM
resource "azurerm_storage_account" "saAtividade" {
    name                        = "killysa"
    resource_group_name         = azurerm_resource_group.rg_atividade.name
    location                    = "brazilsouth"
    account_tier                = "Standard"
    account_replication_type    = "GRS"
}
