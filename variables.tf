# This file defines the input variables required for the Azure Stack HCI VM deployment module.
# Default values are set to align with common Azure Portal defaults or for quick testing.
# Please review and adjust these values for your specific production deployments.

# --- Core Resource Variables ---
# These variables define the names for essential Azure resources like Resource Groups
# and Custom Locations, which are foundational for deploying VMs on Azure Stack HCI.

variable "resource_group_name" {
  type        = string
  description = "The name of the primary Azure Resource Group where the resources will be deployed."
  default     = "RG" # Placeholder: Update with your actual primary resource group name.
}

variable "resource_group_name_physical" {
  type        = string
  description = "The name of the physical (secondary) Azure Resource Group where the resources will be deployed. This is typically used for resources associated with a different physical location or cluster."
  default     = "RG" # Placeholder: Update with your actual physical resource group name.
}

variable "custom_location_name" {
  type        = string
  description = "Enter the custom location name of your HCI cluster. This represents the Azure Arc-enabled location where the VMs will be provisioned."
  default     = "azure-local-cl" # Placeholder: Update with your actual primary custom location name.
}

variable "custom_location_name_physical" {
  type        = string
  description = "Enter the custom location name of your HCI cluster for the physical (secondary) deployment. This is for VMs in a separate physical location or cluster."
  default     = "azure-local-cl" # Placeholder: Update with your actual physical custom location name.
}

variable "logical_network_name" {
  type        = string
  description = "Enter the name of the primary logical network you would like to use for the VM deployment. This network defines the IP addressing and connectivity for your VMs."
  default     = "logical" # Placeholder: Update with your actual primary logical network name.
}

variable "logical_network_name_physical" {
  type        = string
  description = "Enter the name of the logical network for the physical (secondary) VM deployment. This network defines the IP addressing and connectivity for VMs in a separate physical location."
  default     = "logical" # Placeholder: Update with your actual physical logical network name.
}

# --- VM Image Variables ---
# These variables define the virtual machine images used for creating new VM instances.

variable "image_name" {
  type        = string
  description = "Enter the name of the VM image you would like to use for the primary VM deployment. This image defines the operating system and base configuration."
  default     = "image" # Placeholder: Update with the actual name of your primary VM image.
}

variable "image_name_physical" {
  type        = string
  description = "Enter the name of the VM image you would like to use for the physical (secondary) VM deployment."
  default     = "image-name" # Placeholder: Update with the actual name of your physical VM image.
}

variable "is_marketplace_image" {
  type        = bool
  description = "Set to 'true' if the referenced image is sourced directly from Azure Marketplace; set to 'false' if it's a custom gallery image."
  default     = true # Default set to true, as per common scenarios.
}

# --- Virtual Machine Configuration Variables ---
# These variables control the specifications and settings of the virtual machine instances.

variable "name" {
  type        = string
  description = "Name of the primary VM resource. This name will be used in Azure and for the VM's hostname."
  default     = "name" # Placeholder: Update with your desired VM name.
  validation {
    condition     = length(var.name) > 0
    error_message = "The VM name cannot be empty."
  }
  validation {
    condition     = length(var.name) <= 15
    error_message = "The VM name must be 15 characters or less (due to NetBIOS name limitations)."
  }
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]*$", var.name))
    error_message = "The VM name must contain only alphanumeric characters and hyphens."
  }
}

variable "vm_admin_username" {
  type        = string
  description = "The administrator username for accessing the VM."
  default     = "admin" # Placeholder: Update with your desired admin username.
}

variable "vm_admin_password" {
  type        = string
  description = "The administrator password for the VM. This should be a strong password."
  default     = "admin_password" # WARNING: This is a dummy value. CHANGE THIS FOR PRODUCTION!
  sensitive   = true # Marks the variable as sensitive to prevent its value from being logged.
}

variable "v_cpu_count" {
  type        = number
  description = "The number of virtual CPUs to allocate to the VM."
  default     = 2 # Common default, adjust based on workload requirements.
}

variable "memory_mb" {
  type        = number
  description = "The amount of memory (in MB) to allocate to the VM."
  default     = 8192 # Default to 8GB (8192 MB).
}

variable "dynamic_memory" {
  type        = bool
  description = "Set to 'true' to enable dynamic memory for the VM, allowing memory to be adjusted based on workload."
  default     = false # Default to false if dynamic memory is not required.
}

variable "dynamic_memory_buffer" {
  type        = number
  description = "The percentage of memory buffer (e.g., 20 for 20%) when dynamic memory is enabled. This provides headroom for memory spikes."
  default     = 20 # Common default for dynamic memory buffer.
}

variable "dynamic_memory_max" {
  type        = number
  description = "The maximum amount of dynamic memory (in MB) that can be allocated to the VM."
  default     = 8192 # Default to 8GB (8192 MB) as max.
}

variable "dynamic_memory_min" {
  type        = number
  description = "The minimum amount of dynamic memory (in MB) that will be allocated to the VM."
  default     = 512 # Default to 512 MB as min.
}

variable "data_disk_params" {
  type = map(object({
    name       = string
    diskSizeGB = number
    dynamic    = bool
  }))
  default     = {} # Default to an empty map if no additional data disks are required.
  description = "A map describing the data disks to attach to the VM. Provide an empty map for no additional disks, or a map structured as per the module's documentation (e.g., { disk1 = { name = \"data-disk-01\", diskSizeGB = 128, dynamic = false } })."
}

variable "private_ip_address" {
  type        = string
  description = "The static private IP address to assign to the VM's network interface. If left as default, a dynamic IP may be assigned depending on network configuration."
  default     = "1.2.3.4" # Placeholder: Update with your desired private IP address.
}

# --- Domain Join Variables (Optional) ---
# These variables are used to automatically join the VM to an Active Directory domain during deployment.

variable "domain_to_join" {
  type        = string
  description = "Optional: The fully qualified domain name (FQDN) to join the VM to (e.g., 'contoso.com'). If specified, 'domain_target_ou', 'domain_join_user_name', and 'domain_join_password' are required."
  default     = "" # Default to empty if domain join is not required.
}

variable "domain_target_ou" {
  type        = string
  description = "Optional: The target Organizational Unit (OU) within the domain where the VM's computer object will be created (e.g., 'OU=Servers,DC=contoso,DC=com'). Required if 'domain_to_join' is specified."
  default     = "" # Default to empty if domain join is not required.
}

variable "domain_join_user_name" {
  type        = string
  description = "Optional: The username with permissions to join the VM to the domain (e.g., 'domain-joiner'). Required if 'domain_to_join' is specified."
  default     = "" # Default to empty if domain join is not required.
}

variable "domain_join_password" {
  type        = string
  description = "Optional: The password for the user specified in 'domain_join_user_name'. Required if 'domain_to_join' is specified."
  default     = null # Default to null if domain join is not required.
  sensitive   = true # Marks the variable as sensitive.
}

# --- Telemetry Variable ---
# This variable controls anonymous telemetry collection for the module.

variable "enable_telemetry" {
  type        = bool
  default     = false # Default to false to disable telemetry by default.
  description = <<DESCRIPTION
This variable controls whether or not anonymous telemetry is enabled for the module.
For more information on what data is collected and why, please refer to:
<https://aka.ms/avm/telemetryinfo>.
If this variable is set to 'false', then no telemetry will be collected.
DESCRIPTION
}
