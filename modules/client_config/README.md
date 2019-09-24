# Client Config

This sub-module deploys the Client configuration file in the Client Google Cloud Storage (GCS) bucket.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| client\_gcs\_module | The Forseti Client GCS module | string | n/a | yes |
| forseti\_home | Forseti installation directory | string | `"$USER_HOME/forseti-security"` | no |
| server\_address | The Forseti server address | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| forseti-client-config | The rendered Forseti client configuration file |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
