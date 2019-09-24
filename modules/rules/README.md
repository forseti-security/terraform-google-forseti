# Rules

This sub-module renders Forseti rule files and loads them into Google Cloud Storage (GCS).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| domain | The domain associated with the GCP Organization ID | string | n/a | yes |
| manage\_rules\_enabled | A toggle to enable or disable the management of rules | bool | `"true"` | no |
| org\_id | The organization ID | string | n/a | yes |
| server\_gcs\_module | The Forseti Server GCS module | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| files | A list of files that will be uploaded as Forseti rules |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
