# Upgrading to v5.0

The v4.0 release of the *forseti* module is a backwards incompatible
release.

## Migration Instructions

Version 5.0.0 of this module introduces a breaking change.  The various components of Forseti are in more granular submodules.  If trying to apply a plan against a state created by a 4.x version of this module, will result in the destruction of existing Forseti resources.

Following these instructions will import existing Forseti infrastructure resources to a state compatible with version 5.x of this module.

### Clean-up Existing State
Do ONE of the following.
1. Use Terraform to clean up the state and [automatically create a backup](https://www.terraform.io/docs/commands/state/index.html#backups).
```
terraform state rm $(terraform state list)
```
OR<br />

2. Manually backup and delete the current state.
  - Make a backup of the existing Terraform state state (terraform.tfstate).
    - This may be on a local filesystem in the directory from where you execute the Terraform command.
    - This may also be in a remote storage.
  - Remove current state file: terraform.tfstate

### Steps to Import State
1. Execute the import script: [helpers/import.sh](../helpers/import.sh)
2. Re-initialize Terraform. 
```
terraform init
```
3. Review the Terraform plan.
```
terraform plan
```
**NOTE:** After reviewing the plan, if there are *any* questions about what's being created, destroyed or changed, please feel free to contact the [Forseti Security](https://forsetisecurity.org/docs/latest/use/get-help.html) team.

4. Apply the plan.
```
terraform apply
```