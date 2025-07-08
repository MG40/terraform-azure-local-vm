# This file defines data sources for existing Azure Stack HCI resources
# and deploys virtual machine instances using a shared module.

# --- Data Sources for Resource Groups ---

# Retrieves details of the primary Azure Resource Group where resources are located.
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name # The name of the resource group to retrieve.
}

# Retrieves details of the physical (secondary) Azure Resource Group.
# This is typically used for resources associated with a different physical location or cluster.
data "azurerm_resource_group" "rg_physical" {
  name = var.resource_group_name_physical # The name of the physical resource group.
}

# --- Data Sources for Custom Locations ---

# Retrieves details of the primary Custom Location.
# Custom Locations extend Azure management to on-premises Azure Stack HCI clusters.
data "azapi_resource" "customlocation" {
  type      = "Microsoft.ExtendedLocation/customLocations@2021-08-15"
  name      = var.custom_location_name # The name of the custom location.
  parent_id = data.azurerm_resource_group.rg.id # Associates with the primary resource group.
}

# Retrieves details of the physical (secondary) Custom Location.
data "azapi_resource" "customlocation_physical" {
  type      = "Microsoft.ExtendedLocation/customLocations@2021-08-15"
  name      = var.custom_location_name_physical # The name of the physical custom location.
  parent_id = data.azurerm_resource_group.rg_physical.id # Associates with the physical resource group.
}

# --- Data Sources for VM Images ---

# Retrieves details of the primary VM Image (Gallery Image).
# This image is used for creating virtual machines.
data "azapi_resource" "vm_image" {
  # Dynamically sets the image type based on whether it's a marketplace image or a custom gallery image.
  type      = var.is_marketplace_image ? "Microsoft.AzureStackHCI/marketplaceGalleryImages@2023-09-01-preview" : "Microsoft.AzureStackHCI/galleryImages@2023-09-01-preview"
  name      = var.image_name # The name of the VM image.
  parent_id = data.azurerm_resource_group.rg.id # Associates with the primary resource group.
}

# Retrieves details of the physical (secondary) VM Image.
data "azapi_resource" "vm_image_physical" {
  # Dynamically sets the image type based on whether it's a marketplace image or a custom gallery image.
  type      = var.is_marketplace_image ? "Microsoft.AzureStackHCI/marketplaceGalleryImages@2023-09-01-preview" : "Microsoft.AzureStackHCI/galleryImages@2023-09-01-preview"
  name      = var.image_name_physical # The name of the physical VM image.
  parent_id = data.azurerm_resource_group.rg_physical.id # Associates with the physical resource group.
}

# --- Data Sources for Logical Networks ---

# Retrieves details of the primary Logical Network.
# Logical Networks define the network configuration for VMs on Azure Stack HCI.
data "azapi_resource" "logical_network" {
  type      = "Microsoft.AzureStackHCI/logicalNetworks@2023-09-01-preview"
  name      = var.logical_network_name # The name of the logical network.
  parent_id = data.azurerm_resource_group.rg.id # Associates with the primary resource group.
}

# Retrieves details of the physical (secondary) Logical Network.
data "azapi_resource" "logical_network_name_physical" {
  type      = "Microsoft.AzureStackHCI/logicalNetworks@2023-09-01-preview"
  name      = var.logical_network_name_physical # The name of the physical logical network.
  parent_id = data.azurerm_resource_group.rg_physical.id # Associates with the physical resource group.
}

# --- Module for VM Deployment (Primary) ---

# Deploys a single Azure Stack HCI Virtual Machine Instance using the AVM module.
module "test" {
  # Specifies the source for the module from the Azure Verified Modules registry.
  source = "Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm"
  # The 'version' argument can be uncommented and set to pin a specific module version, e.g., version = "~>0.0"

  enable_telemetry      = var.enable_telemetry # Controls telemetry reporting for the VM.
  resource_group_name   = var.resource_group_name # The resource group where the VM will be deployed.
  location              = data.azurerm_resource_group.rg.location # Inherits location from the primary resource group.
  custom_location_id    = data.azapi_resource.customlocation.id # Links to the primary custom location.
  name                  = var.name # The name of the virtual machine instance.
  image_id              = data.azapi_resource.vm_image.id # The ID of the VM image to use.
  logical_network_id    = data.azapi_resource.logical_network.id # The ID of the logical network to connect to.
  admin_username        = var.vm_admin_username # Administrator username for the VM.
  admin_password        = var.vm_admin_password # Administrator password for the VM.
  v_cpu_count           = var.v_cpu_count # Number of virtual CPUs for the VM.
  memory_mb             = var.memory_mb # Amount of memory (in MB) for the VM.
  dynamic_memory        = var.dynamic_memory # Enable or disable dynamic memory.
  dynamic_memory_max    = var.dynamic_memory_max # Maximum dynamic memory (in MB).
  dynamic_memory_min    = var.dynamic_memory_min # Minimum dynamic memory (in MB).
  dynamic_memory_buffer = var.dynamic_memory_buffer # Percentage of memory buffer for dynamic memory.
  data_disk_params      = var.data_disk_params # Configuration for data disks.
  private_ip_address    = var.private_ip_address # Static private IP address for the VM.
  domain_to_join        = var.domain_to_join # Domain to join the VM to.
  domain_target_ou      = var.domain_target_ou # Target Organizational Unit in the domain.
  domain_join_user_name = var.domain_join_user_name # Username for domain join.
  domain_join_password  = var.domain_join_password # Password for domain join.

  # Optional block to configure a proxy server for your VM.
  # Uncomment and configure these settings if a proxy is required for the VM's internet access.
  # http_proxy = "http://username:password@proxyserver.contoso.com:3128"
  # https_proxy = "https://username:password@proxyserver.contoso.com:3128"
  # no_proxy = [
  #     "localhost",
  #     "127.0.0.1"
  # ]
  # trusted_ca = "-----BEGIN CERTIFICATE-----....-----END CERTIFICATE-----"
}

# --- Module for VM Deployment (Physical/Count-based) ---

# Deploys multiple Azure Stack HCI Virtual Machine Instances using the AVM module.
# The 'count' meta-argument is used to create multiple instances of the VM.
module "test_physical" {
  source = "Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm"
  # The 'version' argument can be uncommented and set to pin a specific module version, e.g., version = "~>0.0"

  count = 3 # Creates 3 virtual machine instances.

  enable_telemetry      = var.enable_telemetry # Controls telemetry reporting for the VM.
  resource_group_name   = var.resource_group_name_physical # The resource group where these VMs will be deployed.
  location              = data.azurerm_resource_group.rg_physical.location # Inherits location from the physical resource group.
  custom_location_id    = data.azapi_resource.customlocation_physical.id # Links to the physical custom location.
  name                  = "azure-local-${count.index}" # Generates unique names like "azure-local-0", "azure-local-1", etc.
  image_id              = data.azapi_resource.vm_image_physical.id # The ID of the physical VM image to use.
  logical_network_id    = data.azapi_resource.logical_network_name_physical.id # The ID of the physical logical network to connect to.
  admin_username        = var.vm_admin_username # Administrator username for the VMs.
  admin_password        = var.vm_admin_password # Administrator password for the VMs.
  v_cpu_count           = var.v_cpu_count # Number of virtual CPUs for the VMs.
  memory_mb             = var.memory_mb # Amount of memory (in MB) for the VMs.
  dynamic_memory        = var.dynamic_memory # Enable or disable dynamic memory.
  dynamic_memory_max    = var.dynamic_memory_max # Maximum dynamic memory (in MB).
  dynamic_memory_min    = var.dynamic_memory_min # Minimum dynamic memory (in MB).
  dynamic_memory_buffer = var.dynamic_memory_buffer # Percentage of memory buffer for dynamic memory.

  # Hardcoded data disk configuration for each instance created by 'count'.
  # The disk name is made unique using 'count.index'.
  data_disk_params = {
    disk1 = {
      name       = "disk${count.index}" # Unique disk name for each VM instance.
      diskSizeGB = 1024
      dynamic    = false
    }
  }
  private_ip_address    = "1.2.3.4${count.index + 1}" # Generates unique private IPs like "1.2.3.41", "1.2.3.42", etc.
  domain_to_join        = var.domain_to_join # Domain to join the VMs to.
  domain_target_ou      = var.domain_target_ou # Target Organizational Unit in the domain.
  domain_join_user_name = var.domain_join_user_user_name # Username for domain join.
  domain_join_password  = var.domain_join_password # Password for domain join.

  # Optional block to configure a proxy server for your VM.
  # Uncomment and configure these settings if a proxy is required for the VM's internet access.
  # http_proxy = "http://username:password@proxyserver.contoso.com:3128"
  # https_proxy = "https://username:password@proxyserver.contoso.com:3128"
  # no_proxy = [
  #     "localhost",
  #     "127.0.0.1"
  # ]
  # trusted_ca = "-----BEGIN CERTIFICATE-----....-----END CERTIFICATE-----"
}
