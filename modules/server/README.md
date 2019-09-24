# Server

This sub-module deploys the Forseti Server VM and associated firewall rules.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| client\_iam\_module | The Forseti Client IAM module | string | n/a | yes |
| cloudsql\_module | The CloudSQL module | string | n/a | yes |
| cloudsql\_proxy\_arch | CloudSQL Proxy architecture | string | `"linux.amd64"` | no |
| forseti\_home | Forseti installation directory | string | `"$USER_HOME/forseti-security"` | no |
| forseti\_repo\_url | Git repo for the Forseti installation | string | `"https://github.com/forseti-security/forseti-security"` | no |
| forseti\_run\_frequency | Schedule of running the Forseti scans | string | `"0 */2 * * *"` | no |
| forseti\_version | The version of Forseti to install | string | `"v2.21.0"` | no |
| network | The VPC where the Forseti client and server will be created | string | `"default"` | no |
| network\_project | The project containing the VPC and subnetwork where the Forseti client and server will be created | string | `""` | no |
| policy\_library\_home | The local policy library directory. | string | `"$USER_HOME/policy-library"` | no |
| policy\_library\_repository\_url | The git repository containing the policy-library. | string | `""` | no |
| policy\_library\_sync\_enabled | Sync config validator policy library from private repository. | string | `"false"` | no |
| policy\_library\_sync\_gcs\_directory\_name | The directory name of the GCS folder used for the policy library sync config. | string | `"policy_library_sync"` | no |
| policy\_library\_sync\_git\_sync\_tag | Tag for the git-sync image. | string | `"v3.1.2"` | no |
| policy\_library\_sync\_ssh\_known\_hosts | List of authorized public keys for SSH host of the policy library repository. | string | `""` | no |
| project\_id | Google Project ID that you want Forseti deployed into | string | n/a | yes |
| server\_access\_config | Server instance 'access_config' block | map(any) | `<map>` | no |
| server\_boot\_disk\_size | Size of the GCE instance boot disk in GBs. | string | `"100"` | no |
| server\_boot\_disk\_type | GCE instance boot disk type, can be pd-standard or pd-ssd. | string | `"pd-ssd"` | no |
| server\_boot\_image | GCE Forseti Server boot image - Currently only Ubuntu is supported | string | `"ubuntu-os-cloud/ubuntu-1804-lts"` | no |
| server\_config\_module | The Forseti Server config module | string | n/a | yes |
| server\_gcs\_module | The Forseti Server GCS module | string | n/a | yes |
| server\_grpc\_allow\_ranges | List of CIDRs that will be allowed gRPC access to forseti server | list(string) | `<list>` | no |
| server\_iam\_module | The Forseti Server IAM module | string | n/a | yes |
| server\_instance\_metadata | Metadata key/value pairs to make available from within the server instance. | map(string) | `<map>` | no |
| server\_private | Enable private Forseti server VM (no public IP) | string | `"false"` | no |
| server\_region | GCE Forseti Server region | string | `"us-central1"` | no |
| server\_rules\_module | The Forseti Server rules module | string | n/a | yes |
| server\_ssh\_allow\_ranges | List of CIDRs that will be allowed ssh access to forseti server | list(string) | `<list>` | no |
| server\_tags | VM instance tags | list(string) | `<list>` | no |
| server\_type | GCE Forseti Server machine type | string | `"n1-standard-8"` | no |
| services | An artificial dependency to bypass #10462 | list(string) | `<list>` | no |
| subnetwork | The VPC subnetwork where the Forseti client and server will be created | string | `"default"` | no |
| suffix | The random suffix to append to all Forseti resources | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| forseti-server-git-public-key-openssh | The public OpenSSH key generated to allow the Forseti Server to clone the policy library repository. |
| forseti-server-vm-ip | Forseti Server VM private IP address |
| forseti-server-vm-name | Forseti Server VM name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
