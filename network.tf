#Define Virtual Network
resource "azurerm_virtual_network" "mtc-network" {
  name                = "Network Name"
  location            = azurerm_resource_group.mtc_resources.location
  resource_group_name = azurerm_resource_group.mtc_resources.name
  address_space       = ["10.123.0.0/16"]

  tags = {
    "environment" = "dev"
  }

}
#Define Subnet
resource "azurerm_subnet" "mtc-subnet" {
  name                 = "Subnet Name"
  resource_group_name  = azurerm_resource_group.mtc_resources.name
  virtual_network_name = azurerm_virtual_network.mtc-network.name
  address_prefixes     = ["10.123.1.0/24"]

}
#Define Security group
resource "azurerm_network_security_group" "mtc-security1" {
  name                = "Security Rule Name"
  location            = azurerm_resource_group.mtc_resources.location
  resource_group_name = azurerm_resource_group.mtc_resources.name

}
#Define Security rules within the Security Group
resource "azurerm_network_security_rule" "mtc-devrule" {
  name                        = "Security rule Name"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.mtc_resources.name
  network_security_group_name = azurerm_network_security_group.mtc-security1.name
}

#Associate the subnet and securtity group
resource "azurerm_subnet_network_security_group_association" "mtc-assoc" {
  subnet_id                 = azurerm_subnet.mtc-subnet.id
  network_security_group_id = azurerm_network_security_group.mtc-security1.id

}

#Define the VM Ip after provisioned
resource "azurerm_public_ip" "mtc-publicip" {
  name                = "public IP name"
  resource_group_name = azurerm_resource_group.mtc_resources.name
  location            = azurerm_resource_group.mtc_resources.location
  allocation_method   = "Dynamic"

}

resource "azurerm_network_interface" "mtc-nic" {
  name                = "Network Interface Name"
  location            = azurerm_resource_group.mtc_resources.location
  resource_group_name = azurerm_resource_group.mtc_resources.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mtc-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mtc-publicip.id
  }
}