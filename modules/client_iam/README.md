# Client IAM

This sub-module creates the Forseti Client service account and assigns the appropriate roles and permissions.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id | Google Project ID that you want Forseti deployed into | string | n/a | yes |
| suffix | The random suffix to append to all Forseti resources | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| forseti-client-service-account | Forseti Client service account |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
