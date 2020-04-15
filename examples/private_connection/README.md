# Private Connectivity Example

This example shows how to configure a Forseti instance to use only private connections between its components and limit public egress traffic to only [Google private VIP](https://cloud.google.com/vpc/docs/configure-private-google-access#private-domains) post installation. Note that egress traffic to the public internet is still needed during Forseti installation phase in order to install necessary deb package dependencies. The example creates a network and subnetwork resources unlike other examples in the folder. It is done because the subnet has to enable private google access which is disable for other examples. You control the egress setup by setting `block_egress` input variable to `true` in order to allow egress and to `false` to disable it after the Forseti instance is fully installed. The reason is you need to wait until the VM is fully started up and have the Forseti installed there by the startup script. Just having the Forseti infrastructure provisioned is not enough. The example disables provisioning of the Client VM. The private connectivity expects that all changes to the Forseti configuration will be implemented using script files following IaC paradigm.

This example deploys the following:

1. Forseti infrastructure
   * CloudSQL Database
   * Forseti Server GCS Bucket
   * Forseti Client GCS Bucket
   * Forseti Client VM
   * Forseti Server IAM Service Account
   * Forseti Client IAM Service Account
2. DNS and NAT configurations for private communication between forseti server and GCP services
3. Firewall rules to control ingress and egress connectivity

## Requirements

Before this example can be used, you have to ensure that the following pre-requisites are fulfilled:

* Terraform is [installed](#software-dependencies) on the machine where the script is executed.
* GCP Credentials should be [setup](#setup-credentials)
* (OPTIONAL) Service APIs should be [active](#enable-apis) on the project that you plan to deploy the example

The [project factory](https://github.com/terraform-google-modules/terraform-google-project-factory) can be used to provision projects with the correct APIs active.

### Software Dependencies

#### Terraform and Plugins

* [Terraform](https://www.terraform.io/downloads.html) 0.12+
* [Terraform Provider for GCP](https://www.terraform.io/docs/providers/google/index.html) v2.9+

### Setup Credentials

When [configuring Terraform credentials for GCP](https://www.terraform.io/docs/providers/google/guides/getting_started.html#adding-credentials) you should take care that the identity has proper roles on the example's project. In addition to the [roles](https://github.com/forseti-security/terraform-google-forseti#iam-roles) required for the core module function, the identity must have these roles for this example.

* roles/iam.serviceAccountAdmin
* roles/iam.serviceAccountKeyAdmin
* roles/compute.networkAdmin
* roles/resourcemanager.projectIamAdmin (only required if `service_account` is set to `create`)

### Enable APIs

In order to operate the following APIs should be active on the example's project:

* Compute Engine API - compute.googleapis.com
* Cloud Resource Manager API - cloudresourcemanager.googleapis.com
* Service Usage API - serviceusage.googleapis.com
* Service Networking API - servicenetworking.googleapis.com
* Cloud DNS API - dns.googleapis.com

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| block\_egress | Controls whether the forseti infrastructure components can communicate to internet | bool | `"false"` | no |
| domain | The domain associated with the GCP Organization ID | string | n/a | yes |
| forseti\_version | The version of Forseti to install | string | `"master"` | no |
| instance\_metadata | Metadata key/value pairs to make available from within the client and server instances. | map(string) | `<map>` | no |
| org\_id | GCP Organization ID that Forseti will have purview over | string | n/a | yes |
| project\_id | Google Project ID that you want Forseti deployed into | string | n/a | yes |
| region | GCE Forseti VM and SQL database region | string | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| forseti-server-service-account | Forseti Server service account |
| forseti-server-storage-bucket | Forseti Server storage bucket |
| forseti-server-vm-internal-dns | Forseti Server internal DNS |
| forseti-server-vm-ip | Forseti Server VM private IP address |
| forseti-server-vm-name | Forseti Server VM name |
| network | Network where server and client will be deployed |
| subnetwork | Subnetwork where server and client will be deployed |
| suffix | The random suffix appended to Forseti resources |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
