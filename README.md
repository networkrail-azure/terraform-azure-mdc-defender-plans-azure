# terraform-azure-mdc-defender-plans-azure

Terraform module to enable Microsoft Defender for Cloud (MDC) plans across Azure subscriptions.

## Quick Start

1. Navigate to the appropriate example folder:
   - `examples/single_subscription` - Enable for current subscription

## Usage

### Enable Plans
Set `mdc_plans_list` variable with desired plans (e.g., `["VirtualMachines", "Containers"]`) and run `terraform apply`.

### Existing Subscriptions
If your subscription is already onboarded to MDC:
- **Import resources**: Use `terraform import` to manage existing resources
- **Manual cleanup**: Disable plans via Azure portal before applying
- **Fresh start**: Destroy existing Terraform state and begin new

## Key Variables

- `mdc_plans_list` - Plans to enable (e.g., `["VirtualMachines", "Containers"]`)
- `subscription_id` - Target subscription (defaults to current context)
- `create_policy_assignments` - Create policy/RBAC artifacts (default: `true`)
- `dcr_association_scope_id` - Use existing Data Collection Rules

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


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.0 |
| <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) | ~> 0.3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.0 |
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~> 2.0 |
| <a name="provider_modtm"></a> [modtm](#provider\_modtm) | ~> 0.3 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.5 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ascExportResourceGroupLocation"></a> [ascExportResourceGroupLocation](#input\_ascExportResourceGroupLocation) | Location to create the export resource group | `string` | `"uksouth"` | no |
| <a name="input_ascExportResourceGroupName"></a> [ascExportResourceGroupName](#input\_ascExportResourceGroupName) | Name for the export resource group | `string` | `"rg-mdc-export"` | no |
| <a name="input_create_policy_assignments"></a> [create\_policy\_assignments](#input\_create\_policy\_assignments) | Toggle to create policy assignment resources and their role assignments. | `bool` | `true` | no |
| <a name="input_createResourceGroup"></a> [createResourceGroup](#input\_createResourceGroup) | If true, the module will create the export resource group specified by `ascExportResourceGroupName` | `bool` | `true` | no |
| <a name="input_dcr_association_scope_id"></a> [dcr\_association\_scope\_id](#input\_dcr\_association\_scope\_id) | Resource ID to associate the DCR to (subscription, resource group, VM/VMSS, etc.). | `string` | `null` | no |
| <a name="input_default_subplan"></a> [default\_subplan](#input\_default\_subplan) | (Optional) Resource type pricing default subplan. Contact your MSFT representative for possible values | `string` | `null` | no |
| <a name="input_default_tier"></a> [default\_tier](#input\_default\_tier) | (Optional) The pricing tier to use. Possible values are `Free` and `Standard` | `string` | `"Standard"` | no |
| <a name="input_emailSecurityContact"></a> [emailSecurityContact](#input\_emailSecurityContact) | Email address for a security contact to use for notifications | `string` | `""` | no |
| <a name="input_enableAscForAppServices"></a> [enableAscForAppServices](#input\_enableAscForAppServices) | n/a | `string` | `"DeployIfNotExists"` | no |
| <a name="input_enableAscForArm"></a> [enableAscForArm](#input\_enableAscForArm) | n/a | `string` | `"DeployIfNotExists"` | no |
| <a name="input_enableAscForContainers"></a> [enableAscForContainers](#input\_enableAscForContainers) | n/a | `string` | `"DeployIfNotExists"` | no |
| <a name="input_enableAscForCosmosDbs"></a> [enableAscForCosmosDbs](#input\_enableAscForCosmosDbs) | n/a | `string` | `"DeployIfNotExists"` | no |
| <a name="input_enableAscForCspm"></a> [enableAscForCspm](#input\_enableAscForCspm) | n/a | `string` | `"DeployIfNotExists"` | no |
| <a name="input_enableAscForKeyVault"></a> [enableAscForKeyVault](#input\_enableAscForKeyVault) | n/a | `string` | `"DeployIfNotExists"` | no |
| <a name="input_enableAscForOssDb"></a> [enableAscForOssDb](#input\_enableAscForOssDb) | n/a | `string` | `"DeployIfNotExists"` | no |
| <a name="input_enableAscForServers"></a> [enableAscForServers](#input\_enableAscForServers) | n/a | `string` | `"DeployIfNotExists"` | no |
| <a name="input_enableAscForServersVulnerabilityAssessments"></a> [enableAscForServersVulnerabilityAssessments](#input\_enableAscForServersVulnerabilityAssessments) | n/a | `string` | `"DeployIfNotExists"` | no |
| <a name="input_enableAscForSql"></a> [enableAscForSql](#input\_enableAscForSql) | n/a | `string` | `"DeployIfNotExists"` | no |
| <a name="input_enableAscForSqlOnVm"></a> [enableAscForSqlOnVm](#input\_enableAscForSqlOnVm) | n/a | `string` | `"DeployIfNotExists"` | no |
| <a name="input_enableAscForStorage"></a> [enableAscForStorage](#input\_enableAscForStorage) | n/a | `string` | `"DeployIfNotExists"` | no |
| <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry) | This variable controls whether or not telemetry is enabled for the module.<br>For more information see https://aka.ms/avm/telemetryinfo.<br>If it is set to false, then no telemetry will be collected. | `bool` | `true` | no |
| <a name="input_enableTvmCheck"></a> [enableTvmCheck](#input\_enableTvmCheck) | n/a | `string` | `"DeployIfNotExists"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Optional) The location/region where the policy should exist. | `string` | `"uksouth"` | no |
| <a name="input_mdc_databases_plans"></a> [mdc\_databases\_plans](#input\_mdc\_databases\_plans) | (Optional) Set of all MDC databases plans | `set(string)` | <pre>[<br>  "OpenSourceRelationalDatabases",<br>  "SqlServers",<br>  "SqlServerVirtualMachines",<br>  "CosmosDbs"<br>]</pre> | no |
| <a name="input_mdc_plans_list"></a> [mdc\_plans\_list](#input\_mdc\_plans\_list) | (Optional) Set of all MDC plans | `set(string)` | <pre>[<br>  "AppServices",<br>  "Arm",<br>  "CloudPosture",<br>  "Containers",<br>  "KeyVaults",<br>  "OpenSourceRelationalDatabases",<br>  "SqlServers",<br>  "SqlServerVirtualMachines",<br>  "CosmosDbs",<br>  "StorageAccounts",<br>  "VirtualMachines"<br>]</pre> | no |
| <a name="input_minimalSeverity"></a> [minimalSeverity](#input\_minimalSeverity) | Minimal severity level for notifications (Low\|Medium\|High\|Critical) | `string` | `"High"` | no |
| <a name="input_storage_accounts_malware_scan_cap_gb_per_month"></a> [storage\_accounts\_malware\_scan\_cap\_gb\_per\_month](#input\_storage\_accounts\_malware\_scan\_cap\_gb\_per\_month) | (Optional) Sets the maximum GB limit for malware scanning on uploaded files per storage account per month | `string` | `"5000"` | no |
| <a name="input_subplans"></a> [subplans](#input\_subplans) | (Optional) A map of resource type pricing subplan, the key is resource type. This variable takes precedence over `var.default_subplan`. Contact your MSFT representative for possible values | `map(string)` | `{}` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | (Optional) The subscription ID to target. If null, uses the current subscription context. | `string` | `null` | no |
| <a name="input_vulnerabilityAssessmentProvider"></a> [vulnerabilityAssessmentProvider](#input\_vulnerabilityAssessmentProvider) | n/a | `string` | `"mdeTvm"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_plans_details"></a> [plans\_details](#output\_plans\_details) | All plans details |
| <a name="output_subscription_pricing_id"></a> [subscription\_pricing\_id](#output\_subscription\_pricing\_id) | The subscription pricing ID |
