# terraform-azure-mdc-defender-plans-azure

Terraform module to enable Microsoft Defender for Cloud (MDC) plans across Azure subscriptions.

## Quick Start

1. Navigate to the appropriate example folder:
   - `examples/single_subscription` - Enable for current subscription

2. Run Terraform:
   ```bash
   terraform init
   terraform apply
   ```

## Usage

### Enable Plans
Set `mdc_plans_list` variable with desired plans (e.g., `["VirtualMachines", "Containers"]`) and run `terraform apply`.

### Disable Plans
- **All plans**: `terraform destroy`
- **Specific plan**: Remove from `mdc_plans_list` and run `terraform apply`

### Existing Subscriptions
If your subscription is already onboarded to MDC:
- **Import resources**: Use `terraform import` to manage existing resources
- **Manual cleanup**: Disable plans via Azure portal before applying
- **Fresh start**: Destroy existing Terraform state and begin new

## Key Variables

- `mdc_plans_list` - Plans to enable (e.g., `["VirtualMachines", "Containers"]`)
- `subscription_id` - Target subscription (defaults to current context)
- `create_policy_assignments` - Create policy/RBAC artifacts (default: `true`)
- `existing_dcr_id` + `dcr_association_scope_id` - Use existing Data Collection Rules

## Telemetry

Uses `modtm` provider for minimal telemetry (module UUID, operation type, custom tags only). 

Disable telemetry:
```hcl
provider "modtm" {
  enabled = false
}
```

## Reference

- **Examples**: `examples/`
- **Variables**: `variables.tf`  
- **Core logic**: `main.tf`
- **Changelog**: `CHANGELOG.md`


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
