# Simple Example

This example illustrates how to set up a minimal Forseti installation.

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials\_path | Path to service account json | string | n/a | yes |
| domain | The domain associated with the GCP Organization ID | string | n/a | yes |
| gsuite\_admin\_email | The email of a GSuite super admin, used for pulling user directory information *and* sending notifications. | string | n/a | yes |
| instance\_metadata | Metadata key/value pairs to make available from within the client and server instances. | map | `<map>` | no |
| instance\_tags | Tags to assign the client and server instances. | list | `<list>` | no |
| org\_id | GCP Organization ID that Forseti will have purview over | string | n/a | yes |
| private | Private client and server instances (no public IPs) | string | `"true"` | no |
| project\_id | The ID of an existing Google project where Forseti will be installed | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| forseti-client-service-account | Forseti Client service account |
| forseti-client-storage-bucket | Forseti Client storage bucket |
| forseti-client-vm-ip | Forseti Client VM private IP address |
| forseti-client-vm-name | Forseti Client VM name |
| forseti-server-service-account | Forseti Server service account |
| forseti-server-storage-bucket | Forseti Server storage bucket |
| forseti-server-vm-ip | Forseti Server VM private IP address |
| forseti-server-vm-name | Forseti Server VM name |
| suffix | The random suffix appended to Forseti resources |

[^]: (autogen_docs_end)
