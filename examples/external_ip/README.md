# Simple Example

This example illustrates how to set up a minimal Forseti installation.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials\_path | Path to service account json | string | n/a | yes |
| domain | The domain associated with the GCP Organization ID | string | n/a | yes |
| gsuite\_admin\_email | The email of a GSuite super admin, used for pulling user directory information *and* sending notifications. | string | n/a | yes |
| instance\_metadata | Metadata key/value pairs to make available from within the client and server instances. | map(string) | `<map>` | no |
| instance\_tags | Tags to assign the client and server instances. | list(string) | `<list>` | no |
| org\_id | GCP Organization ID that Forseti will have purview over | string | n/a | yes |
| project\_id | The ID of an existing Google project where Forseti will be installed | string | n/a | yes |
| public\_ptr\_domain\_name | Forseti server DNS name | string | `""` | no |
| region | Region where forseti subnetwork will be deployed | string | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| forseti-client-service-account | Forseti Client service account |
| forseti-client-storage-bucket | Forseti Client storage bucket |
| forseti-client-vm-ip | Forseti Client VM private IP address |
| forseti-client-vm-name | Forseti Client VM name |
| forseti-server-public-ip | Forseti Server VM public IP address |
| forseti-server-service-account | Forseti Server service account |
| forseti-server-storage-bucket | Forseti Server storage bucket |
| forseti-server-vm-ip | Forseti Server VM private IP address |
| forseti-server-vm-name | Forseti Server VM name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
