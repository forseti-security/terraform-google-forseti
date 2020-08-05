# Simple Installation

This example deploys Forseti with the following recommended settings:

-   Cloud NAT
-   Private GCE instances
-   Private CloudSQL instance
-   Config Validator enabled with the Forseti policy bundle

Config Validator is enabled in this configuration, and the
[Forseti policy bundle](https://github.com/forseti-security/policy-library/blob/master/docs/bundles/forseti-security.md)
replaces the
[default rules](https://forsetisecurity.org/docs/latest/configure/scanner/default-rules.html)
of these scanners:

-   BigQuery
-   CloudSQL
-   IAM
-   Firewall
-   KMS
-   Service Account Key

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/open?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fforseti-security%2Fterraform-google-forseti.git&cloudshell_git_branch=modulerelease521&cloudshell_working_dir=examples/install_simple&cloudshell_image=gcr.io%2Fgraphite-cloud-shell-images%2Fterraform%3Alatest&cloudshell_tutorial=.%2Ftutorial.md)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bigquery\_enabled | Big Query scanner enabled. | bool | `"false"` | no |
| cloudsql\_acl\_enabled | Cloud SQL scanner enabled. | bool | `"false"` | no |
| config\_validator\_enabled | Config Validator scanner enabled. | bool | `"true"` | no |
| domain | The domain associated with the GCP Organization ID | string | n/a | yes |
| firewall\_rule\_enabled | Firewall rule scanner enabled. | bool | `"false"` | no |
| forseti\_email\_recipient | Forseti email recipient. | string | `""` | no |
| forseti\_email\_sender | Forseti email sender. | string | `""` | no |
| forseti\_version | The version of Forseti to install | string | `"v2.25.1"` | no |
| gsuite\_admin\_email | The email of a GSuite super admin, used for pulling user directory information *and* sending notifications. | string | n/a | yes |
| iam\_policy\_enabled | IAM Policy scanner enabled. | bool | `"false"` | no |
| instance\_metadata | Metadata key/value pairs to make available from within the client and server instances. | map(string) | `<map>` | no |
| instance\_tags | Tags to assign the client and server instances. | list(string) | `<list>` | no |
| kms\_scanner\_enabled | KMS scanner enabled. | bool | `"false"` | no |
| network | The VPC where the Forseti client and server will be created | string | n/a | yes |
| org\_id | GCP Organization ID that Forseti will have purview over | string | n/a | yes |
| policy\_library\_bundle | Policy Library bundle to use with Config Validator. For more info, visit: https://github.com/forseti-security/policy-library/blob/master/docs/index.md#policy-bundles | string | `"forseti-security"` | no |
| policy\_library\_repository\_url | The git repository containing the policy-library. | string | `"https://github.com/forseti-security/policy-library.git"` | no |
| policy\_library\_sync\_gcs\_enabled | Sync Config Validator policy library from GCS. | bool | `"false"` | no |
| private | Private client and server instances (no public IPs) | bool | `"true"` | no |
| project\_id | The ID of an existing Google project where Forseti will be installed | string | n/a | yes |
| region | The region where the Forseti GCE Instance VMs and CloudSQL Instances will be deployed | string | n/a | yes |
| sendgrid\_api\_key | Sendgrid API key. | string | `""` | no |
| service\_account\_key\_enabled | Service account key scanner enabled. | bool | `"false"` | no |
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
