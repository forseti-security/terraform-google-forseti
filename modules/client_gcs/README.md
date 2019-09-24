# Client GCS

This sub-module deploys a Google Cloud Storage (GCS) bucket for the Forseti Client.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id | Google Project ID that you want Forseti deployed into | string | n/a | yes |
| services | An artificial dependency to bypass #10462 | list(string) | `<list>` | no |
| storage\_bucket\_location | GCS storage bucket location | string | `"us-central1"` | no |
| suffix | The random suffix to append to all Forseti resources | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| forseti-client-storage-bucket | Forseti Client storage bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
