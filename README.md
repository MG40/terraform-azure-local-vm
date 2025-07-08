# Terraform Module: Azure Local Virtual Machine Deployment
## Overview
This Terraform module is designed to automate the deployment of Virtual Machine Instances on an Azure Stack HCI cluster. It leverages existing Azure resources such as Resource Groups, Custom Locations, VM Images (Gallery Images), and Logical Networks to provision new virtual machines. The module supports deploying both single and multiple VM instances, with options for dynamic memory, data disks, and domain joining.

## Disclaimer
This module is provided as-is and is not actively maintained. It is intended for demonstration, testing, or as a starting point for your own custom deployments. Users are responsible for reviewing, testing, and maintaining the code for their specific production environments. No ongoing support or updates are guaranteed.

## Prerequisites
Before you can use this Terraform module, ensure you have the following:

### 1. Terraform CLI:

Install Terraform version `~> 1.5` or later. You can download it from the Terraform website.

### 2. Azure Subscription:

An active Azure subscription where you have appropriate permissions to create and manage resources.

### 3. Azure CLI or Azure PowerShell:

- **Azure CLI**: Install the Azure CLI. Authenticate using `az login`.

- **Azure PowerShell**: Install the Azure PowerShell Az module. Authenticate using `Connect-AzAccount`.

- Terraform uses credentials from either of these tools to authenticate with Azure.

### 4. Azure Providers Configuration:

Ensure your Terraform environment is configured with the azurerm and azapi providers, as specified in your versions.tf (or equivalent) file.

### 5. Existing Azure Stack HCI Resources:

- **Resource Groups:** The primary and physical Azure Resource Groups (`var.resource_group_name`, `var.resource_group_name_physical`) must already exist.

- **Custom Locations:** The primary and physical Azure Custom Locations (`var.custom_location_name`, `var.custom_location_name_physical`) must be pre-configured and associated with your Azure Stack HCI cluster.

- **VM Images (Gallery Images):** The VM images (`var.image_name`, `var.image_name_physical`) you intend to use must already be available in your Azure Stack HCI environment (either custom gallery images or marketplace images).

- **Logical Networks:** The primary and physical Logical Networks (`var.logical_network_name`, `var.logical_network_name_physical`) must be defined and available.

## How to Run This Module
Follow these steps to deploy Azure Stack HCI Virtual Machines using this module:

### 1. Clone the Repository:

    git clone https://github.com/MG40/terraform-azure-local-vm.git
    cd terraform-azure-local-vm

### 2. Initialize Terraform:
Navigate to the root directory of this module (where main.tf, variables.tf, etc., are located) and run:

  `terraform init`

This command downloads the necessary providers and initializes the backend.

### 3. Review Variables:
Open the `variables.tf` file and review the default values. It is highly recommended to override these defaults with your specific values using a `terraform.tfvars` file or by passing them directly via the command line.

Example `terraform.tfvars` file:

    resource_group_name = "my-prod-rg"
    custom_location_name = "my-prod-cl"
    image_name = "WindowsServer2022"
    vm_admin_username = "youradmin"
    vm_admin_password = "YourStrongPassword!"
    # ... other variables

Remember to keep sensitive values (like passwords) out of version control.

### 4. Generate an Execution Plan:
Run terraform plan to see what actions Terraform will perform. This step does not make any changes to your infrastructure.

  `terraform plan`

Review the output carefully to ensure it aligns with your expectations.

### 5. Apply the Configuration:
If the plan looks correct, apply the configuration to deploy the resources:

  `terraform apply`

Terraform will prompt you to confirm the actions. Type yes and press Enter to proceed.

### 6. Destroy Resources (Optional):
To remove all resources deployed by this module, run:

  `terraform destroy`

Terraform will again prompt for confirmation. Use with caution, as this will permanently delete the deployed VMs and associated resources.
