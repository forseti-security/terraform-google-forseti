# Simple Installation

This configuration is used to simply install Forseti. It includes a full Cloud Shell [tutorial](./tutorial.md).

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/open?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fforseti-security%2Fterraform-google-forseti.git&cloudshell_git_branch=modulerelease521&cloudshell_working_dir=examples/install_simple&cloudshell_image=gcr.io%2Fgraphite-cloud-shell-images%2Fterraform%3Alatest&cloudshell_tutorial=.%2Ftutorial.md)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| config\_validator\_enabled | Config Validator scanner enabled. | bool | `"false"` | no |
| domain | The domain associated with the GCP Organization ID | string | n/a | yes |
| forseti\_email\_recipient | Forseti email recipient. | string | `""` | no |
| forseti\_email\_sender | Forseti email sender. | string | `""` | no |
| forseti\_version | The version of Forseti to install | string | `"v2.25.1"` | no |
| gsuite\_admin\_email | The email of a GSuite super admin, used for pulling user directory information *and* sending notifications. | string | n/a | yes |
| instance\_metadata | Metadata key/value pairs to make available from within the client and server instances. | map(string) | `<map>` | no |
| instance\_tags | Tags to assign the client and server instances. | list(string) | `<list>` | no |
| network | The VPC where the Forseti client and server will be created | string | n/a | yes |
| org\_id | GCP Organization ID that Forseti will have purview over | string | n/a | yes |
| private | Private client and server instances (no public IPs) | bool | `"true"` | no |
| project\_id | The ID of an existing Google project where Forseti will be installed | string | n/a | yes |
| region | The region where the Forseti GCE Instance VMs and CloudSQL Instances will be deployed | string | n/a | yes |
| sendgrid\_api\_key | Sendgrid API key. | string | `""` | no |
| subnetwork | The VPC subnetwork where the Forseti client and server will be created | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| forseti-client-service-account | Forseti Client service account |
| forseti-client-storage-bucket | Forseti Client storage bucket |
| forseti-client-vm-ip | Forseti Client VM private IP address |
| forseti-client-vm-name | Forseti Client VM name |
| forseti-server-google-cloud-sdk-version | Version of the Google Cloud SDK installed on the Forseti server |
| forseti-server-service-account | Forseti Server service account |
| forseti-server-storage-bucket | Forseti Server storage bucket |
| forseti-server-vm-internal-dns | Forseti Server internal DNS |
| forseti-server-vm-ip | Forseti Server VM private IP address |
| forseti-server-vm-name | Forseti Server VM name |
| suffix | The random suffix appended to Forseti resources |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
