# Cloud SQL

This sub-module deploys the Cloud SQL instance, database, and root user for Forseti Security.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cloudsql\_db\_name | CloudSQL database name | string | `"forseti_security"` | no |
| cloudsql\_disk\_size | The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased. | string | `"25"` | no |
| cloudsql\_private | Whether to enable private network and not to create public IP for CloudSQL Instance | string | `"false"` | no |
| cloudsql\_region | CloudSQL region | string | `"us-central1"` | no |
| cloudsql\_type | CloudSQL Instance size | string | `"db-n1-standard-4"` | no |
| cloudsql\_user\_host | The host the user can connect from. Can be an IP address or IP address range. Changing this forces a new resource to be created. | string | `"%"` | no |
| network | The VPC where the Forseti client and server will be created | string | `"default"` | no |
| network\_project | The project containing the VPC and subnetwork where the Forseti client and server will be created | string | `""` | no |
| project\_id | Google Project ID that you want Forseti deployed into | string | n/a | yes |
| services | An artificial dependency to bypass #10462 | list(string) | `<list>` | no |
| suffix | The random suffix to append to all Forseti resources | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| forseti-clodusql-db-port | CloudSQL database port |
| forseti-cloudsql-connection-name | The connection string to the CloudSQL instance |
| forseti-cloudsql-db-name | CloudSQL region |
| forseti-cloudsql-instance-name | The name of the master CloudSQL instance |
| forseti-cloudsql-region | CloudSQL region |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
