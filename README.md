# terraform-azure-mdc-defender-plans-azure


## Onboarding to Microsoft Defender for Cloud (MDC) plans in Azure

This Terraform module activate Microsoft Defender for Cloud (MDC) plans.

The module supports the following onboarding types:

1. <u>Single Subscription</u>: Onboard MDC plans for a single subscription.



## Usage

### Enable plans

To enable plans using this module, follow these steps based on the subscription type:

#### Single Subscription

1. Navigate to `examples\single_subscription` folder.
2. Execute the `terraform apply` command.
3. Your onboarding will be applied exclusively to the subscription you are currently connected to.

#### Chosen Subscriptions / All Subscriptions / Management Group

1. Enter the relevant folder under `examples` based on your scenario.
2. Execute the `terraform apply` command.
3. After the execution, a new directory named `output` will be generated within the example folder.
4. Access the newly created `output` folder.
5. Modify the `main.tf` file within this folder to align with your specific requirements.
6. Execute the `terraform apply` command again to apply your modifications.

### Disable plans

* To disable all plans execute `terraform destroy` command.
* To disable a specific plan, remove the plan name from mdc_plans_list var and execute `terraform apply` command.

### Onboarded Azure Subscription
We recommend managing the entire onboarding process with our module. If you've already onboarded your Azure Subscription to Microsoft Defender for Cloud plans, you have several options:

#### Azure Defender Plans UI Portal
* **Manual Cleanup**: Manually toggle off the status of all MDC plans.

#### Terraform CLI
* **Start Fresh**: You can choose to destroy your current Terraform environment and begin anew.
* **Import Existing Resources**: Utilize [Terraform import](https://developer.hashicorp.com/terraform/cli/import) to seamlessly integrate existing resources into Terraform management.
* **Manage Multiple Terraform States**: Maintain your current state and create a new one for this module, allowing for efficient resource management.

## Telemetry Collection

This module uses [terraform-provider-modtm](https://registry.terraform.io/providers/Azure/modtm/latest) to collect telemetry data. This provider is designed to assist with tracking the usage of Terraform modules. It creates a custom `modtm_telemetry` resource that gathers and sends telemetry data to a specified endpoint. The aim is to provide visibility into the lifecycle of your Terraform modules - whether they are being created, updated, or deleted. This data can be invaluable in understanding the usage patterns of your modules, identifying popular modules, and recognizing those that are no longer in use.

The ModTM provider is designed with respect for data privacy and control. The only data collected and transmitted are the tags you define in module's `modtm_telemetry` resource, an uuid which represents a module instance's identifier, and the operation the module's caller is executing (Create/Update/Delete/Read). No other data from your Terraform modules or your environment is collected or transmitted.

One of the primary design principles of the ModTM provider is its non-blocking nature. The provider is designed to work in a way that any network disconnectedness or errors during the telemetry data sending process will not cause a Terraform error or interrupt your Terraform operations. This makes the ModTM provider safe to use even in network-restricted or air-gaped environments.

If the telemetry data cannot be sent due to network issues, the failure will be logged, but it will not affect the Terraform operation in progress(it might delay your operations for no more than 5 seconds). This ensures that your Terraform operations always run smoothly and without interruptions, regardless of the network conditions.

You can turn off the telemetry collection by declaring the following `provider` block in your root module:

```hcl
provider "modtm" {
  enabled = false
}
```


Purpose
This module enables Microsoft Defender for Cloud (MDC) plans at subscription or management-group scope.

Requirements
- Terraform >= 1.6.0
- Provider: azurerm >= 4.x

Quick start
1. Edit variables as needed (see `examples/` and `variables.tf`).
2. From an example folder:

```bash
terraform init
terraform apply
```

Key variables
- `subscription_id` — target a specific subscription ID; if null, uses current subscription context (default: `null`).
- `mdc_plans_list` — set of plans to enable (e.g. `"VirtualMachines"`, `"Containers"`).
- `create_policy_assignments` — if `true`, module creates policy and RBAC artifacts (default: `true`).
- Per-plan toggles `enableAscFor*` — set to `"DeployIfNotExists"` to allow the module to create policy assignments for that plan.
- `existing_dcr_id` + `dcr_association_scope_id` — associate an existing AMA/DCR; module will not create DCRs.

Behavior notes
- The deprecated `Api` plan is rejected by input validation.
- Classic MMA auto-provisioning is removed. Use AMA/DCR for data collection; provide existing DCRs for association.

Where to look next
- Examples: `examples/`
- Inputs: `variables.tf`
- Pricing and plan wiring: `main.tf`
- Changelog: `CHANGELOG.md`

Contributing
See `NoticeOnUpgradeTov2.0.md` for migration notes. Use `mcr.microsoft.com/azterraform:latest` for local checks if needed.


## Inputs

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0 |
| <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) | ~> 0.3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.5 |

## Providers

| Name | Version |
|------|---------|
