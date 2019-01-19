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
| forseti-client-gcs-bucket | - |
| forseti-client-service-account | - |
| forseti-client-vm-ip | - |
| forseti-client-vm-name | - |
| forseti-server-gcs-bucket | - |
| forseti-server-service-account | - |
| forseti-server-vm-ip | - |
| forseti-server-vm-name | - |
| gcp\_project\_id | - |
| project\_id | - |

[^]: (autogen_docs_end)
