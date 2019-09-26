# Real time enforcer

This example illustrates how to set up a Forseti installation with real-time policy enforcer.

By default, terraform will use your application default credentials.  If you'd like to use a different service account key, set the environment variable `GOOGLE_APPLICATION_CREDENTIALS` to the desired key's path.  For more info on using the GCP provider, refer to the terraform documentation.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| enforcer\_project\_id | A project to be managed by the real time enforcer | string | n/a | yes |
| instance\_metadata | Metadata key/value pairs to make available from within the client and server instances. | map(string) | `<map>` | no |
| network | Name of the shared VPC | string | n/a | yes |
| org\_id | GCP Organization ID that Forseti will have purview over | string | n/a | yes |
| project\_id | The ID of an existing Google project where Forseti will be installed | string | n/a | yes |
| region | Region where forseti subnetwork will be deployed | string | `"us-central1"` | no |
| subnetwork | Name of the subnetwork where forseti will be deployed | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| forseti-rt-enforcer-service-account | Forseti Enforcer service account |
| forseti-rt-enforcer-storage-bucket | Forseti Enforcer storage bucket |
| forseti-rt-enforcer-topic | The Forseti Enforcer events topic |
| forseti-rt-enforcer-viewer-role-id | The forseti real time enforcer viewer Role ID. |
| forseti-rt-enforcer-vm-ip | Forseti Enforcer VM private IP address |
| forseti-rt-enforcer-vm-name | Forseti Enforcer VM name |
| forseti-rt-enforcer-writer-role-id | The forseti real time enforcer writer Role ID. |
| suffix | The random suffix appended to Forseti resources |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
