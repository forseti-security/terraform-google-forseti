# Simple Example

This example illustrates how to set up a Forseti installation with shared VPC.

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials\_path | Path to service account json | string | n/a | yes |
| domain | Organization domain | string | n/a | yes |
| gsuite\_admin\_email | G Suite admin email | string | n/a | yes |
| instance\_metadata | Metadata key/value pairs to make available from within the client and server instances. | map | `<map>` | no |
| network | Name of the shared VPC | string | n/a | yes |
| network\_project | ID of the project that will have shared VPC | string | n/a | yes |
| org\_id | Organization ID | string | n/a | yes |
| project\_id | ID of the project that will have forseti server | string | n/a | yes |
| region | Region where forseti subnetwork will be deployed | string | `"us-central1"` | no |
| subnetwork | Name of the subnetwork where forseti will be deployed | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| credentials\_path | Pass through the `credentials_path` variable so that InSpec can reuse the credentials |
| forseti-client-service-account | Forseti Client service account |
| forseti-client-storage-bucket | Forseti Client storage bucket |
| forseti-client-vm-ip | Forseti Client VM private IP address |
| forseti-client-vm-name | Forseti Client VM name |
| forseti-server-service-account | Forseti Server service account |
| forseti-server-storage-bucket | Forseti Server storage bucket |
| forseti-server-vm-ip | Forseti Server VM private IP address |
| forseti-server-vm-name | Forseti Server VM name |
| network | Network where server and client will be deployed |
| network\_project | ID of the network project holding shared VPC |
| project\_id | ID of the service project |
| region | Region in which server and client will be deployed |
| subnetwork | Subnetwork where server and client will be deployed |
| suffix | The random suffix appended to Forseti resources |

[^]: (autogen_docs_end)
