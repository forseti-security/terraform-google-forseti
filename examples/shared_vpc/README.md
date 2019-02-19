# Simple Example

This example illustrates how to set up a Forseti installation with shared VPC.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials\_path | Path to service account json | string | - | yes |
| domain | The domain associated with the GCP Organization ID | string | - | yes |
| gsuite\_admin\_email | The email of a GSuite super admin, used for pulling user directory information *and* sending notifications. | string | - | yes |
| org\_id | GCP Organization ID that Forseti will have purview over | string | - | yes |
| project\_id | The ID of an existing service Google project where Forseti will be installed | string | - | yes |
| network\_project | The ID of an existing host Google project where shared VPC lives | string | - | yes |
| network | The name of an existing VPC in host Google project | string | - | yes |
| subnetwork | The ID of a subnetwork in the shared VPC network  | string | - | yes |
| region | The ID of an existing Google project where Forseti will be installed | string | us-east1 | no |

## Outputs

| Name | Description |
|------|-------------|
| forseti-client-vm-ip | Forseti Client VM ip address |
| forseti-client-vm-name | Forseti Client VM name |
| forseti-server-vm-ip | Forseti Server VM ip address |
| forseti-server-vm-name | Forseti Server VM name |
| project\_id | A forwarded copy of `project_id` for InSpec |
| network\_project | A forwarded copy of `network_project` for InSpec |
| network | A forwarded copy of `network_name` for InSpec |
| region | A forwarded copy of `region` for InSpec |

