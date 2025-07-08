# This file defines the input variables required for the Azure Local VM deployment.
# Dummy default values are provided for quick testing and demonstration purposes.
# Please replace these with your actual values for production deployments.

# --- Resource Group Variables ---

variable "resource_group_name" {
  description = "The name of the primary Azure Resource Group where the resources will be located."
  type        = string
  default     = "rg-hci-primary-dev" # Dummy value
}

variable "resource_group_name_physical" {
  description = "The name of the physical (secondary) Azure Resource Group, typically for resources in a different location or cluster."
  type        = string
  default     = "rg-hci-physical-dev" # Dummy value
}

# --- Custom Location Variables ---

variable "custom_location_name" {
  description = "The name of the primary Azure Custom Location for Azure Stack HCI."
  type        = string
  default     = "cl-hci-primary-dev" # Dummy value
}

variable "custom_location_name_physical" {
  description = "The name of the physical (secondary) Azure Custom Location for Azure Stack HCI."
  type        = string
  default     = "cl-hci-physical-dev" # Dummy value
}

# --- VM Image Variables ---

variable "is_marketplace_image" {
  description = "A boolean flag indicating whether the VM image is from the Azure Marketplace (true) or a custom gallery image (false)."
  type        = bool
  default     = false # Assuming custom gallery image by default if not specified
}

variable "image_name" {
  description = "The name of the primary VM Image (Gallery Image) to be used for creating virtual machines."
  type        = string
  default     = "WinSrv2022-Standard-Gen2" # Dummy value
}

variable "image_name_physical" {
  description = "The name of the physical (secondary) VM Image to be used for creating virtual machines."
  type        = string
  default     = "WinSrv2022-Standard-Gen2-Physical" # Dummy value
}

# --- Logical Network Variables ---

variable "logical_network_name" {
  description = "The name of the primary Logical Network to which the VMs will connect."
  type        = string
  default     = "ln-hci-primary-dev" # Dummy value
}

variable "logical_network_name_physical" {
  description = "The name of the physical (secondary) Logical Network to which the VMs will connect."
  type        = string
  default     = "ln-hci-physical-dev" # Dummy value
}

# --- Virtual Machine Configuration Variables ---

variable "enable_telemetry" {
  description = "Controls whether telemetry reporting is enabled for the deployed virtual machines."
  type        = bool
  default     = true # Common default for AVM modules
}

variable "name" {
  description = "The name of the primary virtual machine instance."
  type        = string
  default     = "vm-hci-primary-dev" # Dummy value
}

variable "vm_admin_username" {
  description = "The administrator username for the virtual machines."
  type        = string
  default     = "azureuser" # Dummy value
}

variable "vm_admin_password" {
  description = "The administrator password for the virtual machines."
  type        = string
  sensitive   = true # Mark as sensitive to prevent logging in plain text
  default     = "P@ssw0rd123!" # Dummy value - CHANGE THIS FOR PRODUCTION!
}

variable "v_cpu_count" {
  description = "The number of virtual CPUs to allocate to the virtual machines."
  type        = number
  default     = 2 # Dummy value
}

variable "memory_mb" {
  description = "The amount of memory (in MB) to allocate to the virtual machines."
  type        = number
  default     = 4096 # Dummy value (4GB)
}

variable "dynamic_memory" {
  description = "Specifies whether dynamic memory is enabled for the virtual machines."
  type        = bool
  default     = false
}

variable "dynamic_memory_max" {
  description = "The maximum amount of dynamic memory (in MB) for the virtual machines."
  type        = number
  default     = 8192 # Dummy value
}

variable "dynamic_memory_min" {
  description = "The minimum amount of dynamic memory (in MB) for the virtual machines."
  type        = number
  default     = 2048 # Dummy value
}

variable "dynamic_memory_buffer" {
  description = "The percentage of memory buffer for dynamic memory (e.g., 20 for 20%)."
  type        = number
  default     = 20 # Dummy value
}

variable "data_disk_params" {
  description = "A map of data disk configurations for the virtual machines."
  type = map(object({
    name       = string
    diskSizeGB = number
    dynamic    = bool
  }))
  default = { # Dummy value
    disk1 = {
      name       = "data-disk-01"
      diskSizeGB = 128
      dynamic    = false
    }
  }
}

variable "private_ip_address" {
  description = "The static private IP address to assign to the primary virtual machine."
  type        = string
  default     = "10.0.0.100" # Dummy value
}

variable "domain_to_join" {
  description = "The domain name to join the virtual machines to."
  type        = string
  default     = "example.com" # Dummy value
}

variable "domain_target_ou" {
  description = "The target Organizational Unit (OU) within the domain for the virtual machines."
  type        = string
  default     = "OU=Servers,DC=example,DC=com" # Dummy value
}

variable "domain_join_user_name" {
  description = "The username for joining the virtual machines to the domain."
  type        = string
  default     = "domainjoinuser" # Dummy value
}

variable "domain_join_password" {
  description = "The password for joining the virtual machines to the domain."
  type        = string
  sensitive   = true # Mark as sensitive
  default     = "DomainP@ssw0rd!" # Dummy value - CHANGE THIS FOR PRODUCTION!
}
