[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials\_path | Path to service account json | string | - | yes |
| domain | The domain associated with the GCP Organization ID | string | - | yes |
| gsuite\_admin\_email | The email of a GSuite super admin, used for pulling user directory information *and* sending notifications. | string | - | yes |
| org\_id | GCP Organization ID that Forseti will have purview over | string | - | yes |
| project\_id | The ID of an existing Google project where Forseti will be installed | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| forseti-client-service-account | Forseti Client service account |
| forseti-client-storage-bucket | Forseti Client storage bucket |
| forseti-client-vm-ip | Forseti Client VM ip address |
| forseti-client-vm-name | Forseti Client VM name |
| forseti-server-service-account | Forseti Server service account |
| forseti-server-storage-bucket | Forseti Server storage bucket |
| forseti-server-vm-ip | Forseti Server VM ip address |
| forseti-server-vm-name | Forseti Server VM name |
| project\_id | A forwarded copy of `project_id` for InSpec |

[^]: (autogen_docs_end)
