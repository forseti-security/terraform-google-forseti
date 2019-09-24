# Server GCS

This sub-module deploys a Google Cloud Storage (GCS) bucket for the Forseti Server.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bucket\_cai\_lifecycle\_age | GCS CAI lifecycle age value | string | `"14"` | no |
| bucket\_cai\_location | GCS CAI storage bucket location | string | `"us-central1"` | no |
| enable\_cai\_bucket | Create a GCS bucket for CAI exports | bool | `"true"` | no |
| project\_id | Google Project ID that you want Forseti deployed into | string | n/a | yes |
| services | An artificial dependency to bypass #10462 | list(string) | `<list>` | no |
| storage\_bucket\_location | GCS storage bucket location | string | `"us-central1"` | no |
| suffix | The random suffix to append to all Forseti resources | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| forseti-cai-bucket-enabled | Whether or not the GCS bucket for CAI exports is enabled |
| forseti-cai-storage-bucket | Forseti CAI storage bucket |
| forseti-server-storage-bucket | Forseti Server storage bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
