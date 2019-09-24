# Server IAM

This sub-module creates the Forseti Server service account and assigns the appropriate roles and permissions.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cscc\_violations\_enabled | Notify for CSCC violations | bool | `"false"` | no |
| enable\_write | Enabling/Disabling write actions | bool | `"false"` | no |
| folder\_id | GCP Folder that the Forseti project will be deployed into | string | `""` | no |
| org\_id | GCP Organization ID that Forseti will have purview over | string | n/a | yes |
| project\_id | Google Project ID that you want Forseti deployed into | string | n/a | yes |
| suffix | The random suffix to append to all Forseti resources | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| forseti-server-service-account | Forseti Server service account |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
