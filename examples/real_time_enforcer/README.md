# Real time enforcer

This example illustrates how to set up a Forseti installation with real-time policy enforcer.

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials\_path | Path to service account json | string | n/a | yes |
| domain | The domain associated with the GCP Organization ID | string | n/a | yes |
| enforcer\_project\_id | A project to be managed by the real time enforcer | string | n/a | yes |
| gsuite\_admin\_email | The email of a GSuite super admin, used for pulling user directory information *and* sending notifications. | string | n/a | yes |
| instance\_metadata | Metadata key/value pairs to make available from within the client and server instances. | map | `<map>` | no |
| org\_id | GCP Organization ID that Forseti will have purview over | string | n/a | yes |
| project\_id | The ID of an existing Google project where Forseti will be installed | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| forseti-client-service-account | Forseti Client service account |
| forseti-client-storage-bucket | Forseti Client storage bucket |
| forseti-client-vm-ip | Forseti Client VM private IP address |
| forseti-client-vm-name | Forseti Client VM name |
| forseti-client-vm-public-ip | Forseti Client VM public IP address |
| forseti-rt-enforcer-service-account | Forseti Enforcer service account |
| forseti-rt-enforcer-storage-bucket | Forseti Enforcer storage bucket |
| forseti-rt-enforcer-topic | The Forseti Enforcer events topic |
| forseti-rt-enforcer-vm-ip | Forseti Enforcer VM private IP address |
| forseti-rt-enforcer-vm-name | Forseti Enforcer VM name |
| forseti-rt-enforcer-vm-public-ip | Forseti Enforcer VM public IP address |
| forseti-server-service-account | Forseti Server service account |
| forseti-server-storage-bucket | Forseti Server storage bucket |
| forseti-server-vm-ip | Forseti Server VM private IP address |
| forseti-server-vm-name | Forseti Server VM name |
| forseti-server-vm-public-ip | Forseti Server VM public IP address |
| suffix | The random suffix appended to Forseti resources |

[^]: (autogen_docs_end)
