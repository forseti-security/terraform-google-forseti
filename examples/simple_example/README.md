# Simple Example

This example illustrates how to set up a minimal Forseti installation.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| domain | The domain associated with the GCP Organization ID | string | n/a | yes |
| forseti\_email\_recipient | Forseti email recipient. | string | `""` | no |
| forseti\_email\_sender | Forseti email sender. | string | `""` | no |
| forseti\_version | The version of Forseti to install | string | `"v2.23.0"` | no |
| gsuite\_admin\_email | The email of a GSuite super admin, used for pulling user directory information *and* sending notifications. | string | n/a | yes |
| instance\_metadata | Metadata key/value pairs to make available from within the client and server instances. | map(string) | `<map>` | no |
| instance\_tags | Tags to assign the client and server instances. | list(string) | `<list>` | no |
| network | Name of the shared VPC | string | n/a | yes |
| org\_id | GCP Organization ID that Forseti will have purview over | string | n/a | yes |
| private | Private client, server, and CloudSQL instances (no public IPs) | bool | `"true"` | no |
| project\_id | The ID of an existing Google project where Forseti will be installed | string | n/a | yes |
| region | Region where forseti subnetwork will be deployed | string | `"us-central1"` | no |
| sendgrid\_api\_key | Sendgrid API key. | string | `""` | no |
| subnetwork | Name of the subnetwork where forseti will be deployed | string | n/a | yes |

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

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
