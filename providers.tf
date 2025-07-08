# This block defines the minimum Terraform version required and configures the
# Azure providers used by this module.
terraform {
  required_version = "~> 1.5" # Specifies the minimum Terraform CLI version
  required_providers {
    # The 'azapi' provider allows for managing Azure resources directly via the Azure REST API.
    # It's useful for resources not yet fully supported by the 'azurerm' provider.
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.0"
    }
    # The 'azurerm' provider is the primary provider for managing Azure resources.
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Configures the AzureRM provider to interact with your Azure subscription.
provider "azurerm" {
  # Specifies the Azure subscription ID to deploy resources into.
  # This value should be provided via a variable.
  subscription_id = var.subscription_id

  # Controls the registration of Azure Resource Providers.
  # "none" means Terraform will not attempt to register any providers,
  # assuming they are pre-registered or will be registered by another mechanism.
  resource_provider_registrations = "none"

  # Configures specific features for the AzureRM provider.
  features {
    # Defines behavior for resource groups.
    resource_group {
      # When set to 'false', allows a resource group to be deleted even if it contains resources.
      # Be cautious with this setting in production environments as it can lead to accidental data loss.
      # Consider enabling `prevent_deletion_if_contains_resources` (set to `true`)
      # for critical resource groups, or manage deletion protection at the resource level.
      prevent_deletion_if_contains_resources = false
    }
  }
}
