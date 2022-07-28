# tfdevenv
Terraform Dev environment

I have stripped out the information for resource names so that you may enter your own.
The terraform files assume that you are utilizing the azure CLI for credentials.

# Azure
This repo uses Terraform and Azure to provision the following.
-Azure Resource Group (main.tf)
-Azure Network (subnet, nic, security group, security rule) (network.tf)
-Azure VM (vm.tf

Once provisioned, the VM will install docker on the machine.

# Terraform Backend
The information is in the main.tf file, but you will need to follow the MS Docs and provision.
-Another Resource Group
-A storage account (create a container within)

https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=powershell#3-configure-terraform-backend-state
