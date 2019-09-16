# Terraform Forseti Install

The Terraform Forseti module can be used to quickly install and configure [Forseti](https://forsetisecurity.org/) in a fresh cloud project.

## Compatibility

This module is meant for use with Terraform 0.12. If you haven't
[upgraded][terraform-0.12-upgrade] and need a Terraform 0.11.x-compatible
version of this module, the last released version intended for Terraform 0.11.x
is [2.3.0][v2.3.0].

## Usage
Example setups are included in the [examples](./examples/), but you can can also get started using a Cloud Shell Tutorial.

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/open?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fforseti-security%2Fterraform-google-forseti.git&cloudshell_git_branch=master&cloudshell_working_dir=examples/install_simple&cloudshell_image=gcr.io%2Fgraphite-cloud-shell-images%2Fterraform%3Alatest&cloudshell_tutorial=.%2Ftutorial.md)

Simple usage of the module within your own main.tf file is as follows:

```hcl
    module "forseti" {
      source  = "terraform-google-modules/forseti/google"
      version = "~> 3.0"

      gsuite_admin_email = "superadmin@yourdomain.com"
      domain             = "yourdomain.com"
      project_id         = "my-forseti-project"
      org_id             = "2313934234"
    }
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| admin\_disable\_polling | Whether to disable polling for Admin API | bool | `"false"` | no |
| admin\_max\_calls | Maximum calls that can be made to Admin API | string | `"14"` | no |
| admin\_period | The period of max calls for the Admin API (in seconds) | string | `"1.0"` | no |
| appengine\_disable\_polling | Whether to disable polling for App Engine API | bool | `"false"` | no |
| appengine\_max\_calls | Maximum calls that can be made to App Engine API | string | `"18"` | no |
| appengine\_period | The period of max calls for the App Engine API (in seconds) | string | `"1.0"` | no |
| audit\_logging\_enabled | Audit Logging scanner enabled. | string | `"false"` | no |
| audit\_logging\_violations\_should\_notify | Notify for Audit logging violations | string | `"true"` | no |
| bigquery\_acl\_violations\_should\_notify | Notify for BigQuery ACL violations | string | `"true"` | no |
| bigquery\_disable\_polling | Whether to disable polling for Big Query API | bool | `"false"` | no |
| bigquery\_enabled | Big Query scanner enabled. | string | `"true"` | no |
| bigquery\_max\_calls | Maximum calls that can be made to Big Query API | string | `"160"` | no |
| bigquery\_period | The period of max calls for the Big Query API (in seconds) | string | `"1.0"` | no |
| blacklist\_enabled | Audit Logging scanner enabled. | string | `"true"` | no |
| blacklist\_violations\_should\_notify | Notify for Blacklist violations | string | `"true"` | no |
| bucket\_acl\_enabled | Bucket ACL scanner enabled. | string | `"true"` | no |
| bucket\_cai\_lifecycle\_age | GCS CAI lifecycle age value | string | `"14"` | no |
| bucket\_cai\_location | GCS CAI storage bucket location | string | `"us-central1"` | no |
| buckets\_acl\_violations\_should\_notify | Notify for Buckets ACL violations | string | `"true"` | no |
| cai\_api\_timeout | Timeout in seconds to wait for the exportAssets API to return success. | string | `"3600"` | no |
| client\_access\_config | Client instance 'access\_config' block | map(any) | `<map>` | no |
| client\_boot\_image | GCE Forseti Client role instance size | string | `"ubuntu-os-cloud/ubuntu-1804-lts"` | no |
| client\_instance\_metadata | Metadata key/value pairs to make available from within the client instance. | map(string) | `<map>` | no |
| client\_private | Private GCE Forseti Client VM (no public IP) | bool | `"false"` | no |
| client\_region | GCE Forseti Client role region size | string | `"us-central1"` | no |
| client\_ssh\_allow\_ranges | List of CIDRs that will be allowed ssh access to forseti client | list(string) | `<list>` | no |
| client\_tags | GCE Forseti Client VM Tags | list(string) | `<list>` | no |
| client\_type | GCE Forseti Client role instance size | string | `"n1-standard-2"` | no |
| cloudasset\_disable\_polling | Whether to disable polling for Cloud Asset API | bool | `"false"` | no |
| cloudasset\_max\_calls | Maximum calls that can be made to Cloud Asset API | string | `"1"` | no |
| cloudasset\_period | The period of max calls for the Cloud Asset API (in seconds) | string | `"1.0"` | no |
| cloudbilling\_disable\_polling | Whether to disable polling for Cloud Billing API | bool | `"false"` | no |
| cloudbilling\_max\_calls | Maximum calls that can be made to Cloud Billing API | string | `"5"` | no |
| cloudbilling\_period | The period of max calls for the Cloud Billing API (in seconds) | string | `"1.2"` | no |
| cloudsql\_acl\_enabled | Cloud SQL scanner enabled. | string | `"true"` | no |
| cloudsql\_acl\_violations\_should\_notify | Notify for CloudSQL ACL violations | string | `"true"` | no |
| cloudsql\_db\_name | CloudSQL database name | string | `"forseti_security"` | no |
| cloudsql\_db\_port | CloudSQL database port | string | `"3306"` | no |
| cloudsql\_disk\_size | The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased. | string | `"25"` | no |
| cloudsql\_private | Whether to enable private network and not to create public IP for CloudSQL Instance | bool | `"false"` | no |
| cloudsql\_proxy\_arch | CloudSQL Proxy architecture | string | `"linux.amd64"` | no |
| cloudsql\_region | CloudSQL region | string | `"us-central1"` | no |
| cloudsql\_type | CloudSQL Instance size | string | `"db-n1-standard-1"` | no |
| cloudsql\_user\_host | The host the user can connect from.  Can be an IP address or IP address range. Changing this forces a new resource to be created. | string | `"%"` | no |
| composite\_root\_resources | A list of root resources that Forseti will monitor. This supersedes the root\_resource\_id when set. | list(string) | `<list>` | no |
| compute\_disable\_polling | Whether to disable polling for Compute API | bool | `"false"` | no |
| compute\_max\_calls | Maximum calls that can be made to Compute API | string | `"18"` | no |
| compute\_period | The period of max calls for the Compute API (in seconds) | string | `"1.0"` | no |
| config\_validator\_enabled | Config Validator scanner enabled. | string | `"false"` | no |
| config\_validator\_violations\_should\_notify | Notify for Config Validator violations. | string | `"true"` | no |
| container\_disable\_polling | Whether to disable polling for Container API | bool | `"false"` | no |
| container\_max\_calls | Maximum calls that can be made to Container API | string | `"9"` | no |
| container\_period | The period of max calls for the Container API (in seconds) | string | `"1.0"` | no |
| crm\_disable\_polling | Whether to disable polling for CRM API | bool | `"false"` | no |
| crm\_max\_calls | Maximum calls that can be made to CRN API | string | `"4"` | no |
| crm\_period | The period of max calls for the CRM  API (in seconds) | string | `"1.2"` | no |
| cscc\_source\_id | Source ID for CSCC Beta API | string | `""` | no |
| cscc\_violations\_enabled | Notify for CSCC violations | string | `"false"` | no |
| domain | The domain associated with the GCP Organization ID | string | n/a | yes |
| enable\_cai\_bucket | Create a GCS bucket for CAI exports | string | `"true"` | no |
| enable\_write | Enabling/Disabling write actions | string | `"false"` | no |
| enabled\_apis\_enabled | Enabled APIs scanner enabled. | string | `"false"` | no |
| enabled\_apis\_violations\_should\_notify | Notify for enabled APIs violations | string | `"true"` | no |
| excluded\_resources | A list of resources to exclude during the inventory phase. | list(string) | `<list>` | no |
| external\_project\_access\_violations\_should\_notify | Notify for External Project Access violations | string | `"true"` | no |
| firewall\_rule\_enabled | Firewall rule scanner enabled. | string | `"true"` | no |
| firewall\_rule\_violations\_should\_notify | Notify for Firewall rule violations | string | `"true"` | no |
| folder\_id | GCP Folder that the Forseti project will be deployed into | string | `""` | no** |
| forseti\_email\_recipient | Email address that receives Forseti notifications | string | `""` | no |
| forseti\_email\_sender | Email address that sends the Forseti notifications | string | `""` | no |
| forseti\_home | Forseti installation directory | string | `"$USER_HOME/forseti-security"` | no |
| forseti\_repo\_url | Git repo for the Forseti installation | string | `"https://github.com/forseti-security/forseti-security"` | no |
| forseti\_run\_frequency | Schedule of running the Forseti scans | string | `"0 */2 * * *"` | no |
| forseti\_version | The version of Forseti to install | string | `"v2.20.0"` | no |
| forwarding\_rule\_enabled | Forwarding rule scanner enabled. | string | `"false"` | no |
| forwarding\_rule\_violations\_should\_notify | Notify for forwarding rule violations | string | `"true"` | no |
| group\_enabled | Group scanner enabled. | string | `"true"` | no |
| groups\_settings\_disable\_polling | Whether to disable polling for the G Suite Groups API | bool | `"false"` | no |
| groups\_settings\_enabled | Groups settings scanner enabled. | string | `"true"` | no |
| groups\_settings\_max\_calls | Maximum calls that can be made to the G Suite Groups API | string | `"5"` | no |
| groups\_settings\_period | the period of max calls to the G Suite Groups API | string | `"1.1"` | no |
| groups\_settings\_violations\_should\_notify | Notify for groups settings violations | string | `"true"` | no |
| groups\_violations\_should\_notify | Notify for Groups violations | string | `"true"` | no |
| gsuite\_admin\_email | G-Suite administrator email address to manage your Forseti installation | string | `""` | no |
| iam\_disable\_polling | Whether to disable polling for IAM API | bool | `"false"` | no |
| iam\_max\_calls | Maximum calls that can be made to IAM API | string | `"90"` | no |
| iam\_period | The period of max calls for the IAM API (in seconds) | string | `"1.0"` | no |
| iam\_policy\_enabled | IAM Policy scanner enabled. | string | `"true"` | no |
| iam\_policy\_violations\_should\_notify | Notify for IAM Policy violations | string | `"true"` | no |
| iam\_policy\_violations\_slack\_webhook | Slack webhook for IAM Policy violations | string | `""` | no |
| iap\_enabled | IAP scanner enabled. | string | `"true"` | no |
| iap\_violations\_should\_notify | Notify for IAP violations | string | `"true"` | no |
| instance\_network\_interface\_enabled | Instance network interface scanner enabled. | string | `"false"` | no |
| instance\_network\_interface\_violations\_should\_notify | Notify for instance network interface violations | string | `"true"` | no |
| inventory\_email\_summary\_enabled | Email summary for inventory enabled | string | `"false"` | no |
| inventory\_gcs\_summary\_enabled | GCS summary for inventory enabled | string | `"true"` | no |
| inventory\_retention\_days | Number of days to retain inventory data. | string | `"-1"` | no |
| ke\_scanner\_enabled | KE scanner enabled. | string | `"false"` | no |
| ke\_version\_scanner\_enabled | KE version scanner enabled. | string | `"true"` | no |
| ke\_version\_violations\_should\_notify | Notify for KE version violations | string | `"true"` | no |
| ke\_violations\_should\_notify | Notify for KE violations | string | `"true"` | no |
| kms\_scanner\_enabled | KMS scanner enabled. | string | `"true"` | no |
| kms\_violations\_should\_notify | Notify for KMS violations | string | `"true"` | no |
| kms\_violations\_slack\_webhook | Slack webhook for KMS violations | string | `""` | no |
| lien\_enabled | Lien scanner enabled. | string | `"true"` | no |
| lien\_violations\_should\_notify | Notify for lien violations | string | `"true"` | no |
| location\_enabled | Location scanner enabled. | string | `"true"` | no |
| location\_violations\_should\_notify | Notify for location violations | string | `"true"` | no |
| log\_sink\_enabled | Log sink scanner enabled. | string | `"true"` | no |
| log\_sink\_violations\_should\_notify | Notify for log sink violations | string | `"true"` | no |
| logging\_disable\_polling | Whether to disable polling for Logging API | bool | `"false"` | no |
| logging\_max\_calls | Maximum calls that can be made to Logging API | string | `"9"` | no |
| logging\_period | The period of max calls for the Logging API (in seconds) | string | `"1.0"` | no |
| network | The VPC where the Forseti client and server will be created | string | `"default"` | no |
| network\_project | The project containing the VPC and subnetwork where the Forseti client and server will be created | string | `""` | no |
| org\_id | GCP Organization ID that Forseti will have purview over | string | `""` | no** |
| policy\_library\_home | The local policy library directory. | string | `"$USER_HOME/policy-library"` | no |
| policy\_library\_repository\_url | The git repository containing the policy-library. | string | `""` | no |
| policy\_library\_sync\_enabled | Sync config validator policy library from private repository. | bool | `"false"` | no |
| policy\_library\_sync\_gcs\_directory\_name | The directory name of the GCS folder used for the policy library sync config. | string | `"policy_library_sync"` | no |
| policy\_library\_sync\_git\_sync\_tag | Tag for the git-sync image. | string | `"v3.1.2"` | no |
| policy\_library\_sync\_ssh\_known\_hosts | List of authorized public keys for SSH host of the policy library repository. | string | `""` | no |
| project\_id | Google Project ID that you want Forseti deployed into | string | n/a | yes |
| resource\_enabled | Resource scanner enabled. | string | `"true"` | no |
| resource\_violations\_should\_notify | Notify for resource violations | string | `"true"` | no |
| securitycenter\_disable\_polling | Whether to disable polling for Security Center API | bool | `"false"` | no |
| securitycenter\_max\_calls | Maximum calls that can be made to Security Center API | string | `"1"` | no |
| securitycenter\_period | The period of max calls for the Security Center API (in seconds) | string | `"1.1"` | no |
| sendgrid\_api\_key | Sendgrid.com API key to enable email notifications | string | `""` | no |
| server\_access\_config | Server instance 'access\_config' block | map(any) | `<map>` | no |
| server\_boot\_disk\_size | Size of the GCE instance boot disk in GBs. | string | `"100"` | no |
| server\_boot\_disk\_type | GCE instance boot disk type, can be pd-standard or pd-ssd. | string | `"pd-ssd"` | no |
| server\_boot\_image | GCE instance image that is being used, currently Ubuntu only support is available | string | `"ubuntu-os-cloud/ubuntu-1804-lts"` | no |
| server\_grpc\_allow\_ranges | List of CIDRs that will be allowed gRPC access to forseti server | list(string) | `<list>` | no |
| server\_instance\_metadata | Metadata key/value pairs to make available from within the server instance. | map(string) | `<map>` | no |
| server\_private | Private GCE Forseti Server VM (no public IP) | bool | `"false"` | no |
| server\_region | GCP region where Forseti will be deployed | string | `"us-central1"` | no |
| server\_ssh\_allow\_ranges | List of CIDRs that will be allowed ssh access to forseti server | list(string) | `<list>` | no |
| server\_tags | GCE Forseti Server VM Tags | list(string) | `<list>` | no |
| server\_type | GCE Forseti Server role instance size | string | `"n1-standard-2"` | no |
| service\_account\_key\_enabled | Service account key scanner enabled. | string | `"true"` | no |
| service\_account\_key\_violations\_should\_notify | Notify for service account key violations | string | `"true"` | no |
| servicemanagement\_disable\_polling | Whether to disable polling for Service Management API | bool | `"false"` | no |
| servicemanagement\_max\_calls | Maximum calls that can be made to Service Management API | string | `"2"` | no |
| servicemanagement\_period | The period of max calls for the Service Management API (in seconds) | string | `"1.1"` | no |
| sqladmin\_disable\_polling | Whether to disable polling for SQL Admin API | bool | `"false"` | no |
| sqladmin\_max\_calls | Maximum calls that can be made to SQL Admin API | string | `"1"` | no |
| sqladmin\_period | The period of max calls for the SQL Admin API (in seconds) | string | `"1.1"` | no |
| storage\_bucket\_location | GCS storage bucket location | string | `"us-central1"` | no |
| storage\_disable\_polling | Whether to disable polling for Storage API | bool | `"false"` | no |
| subnetwork | The VPC subnetwork where the Forseti client and server will be created | string | `"default"` | no |
| violations\_slack\_webhook | Slack webhook for any violation. Will apply to all scanner violation notifiers. | string | `""` | no |

** Either the **folder\_id** or **org\_id** input is required to be set for a simple deployment.

## Outputs

| Name | Description |
|------|-------------|
| forseti-client-service-account | Forseti Client service account |
| forseti-client-storage-bucket | Forseti Client storage bucket |
| forseti-client-vm-ip | Forseti Client VM private IP address |
| forseti-client-vm-name | Forseti Client VM name |
| forseti-cloudsql-connection-name | Forseti CloudSQL Connection String |
| forseti-server-git-public-key-openssh | The public OpenSSH key generated to allow the Forseti Server to clone the policy library repository. |
| forseti-server-service-account | Forseti Server service account |
| forseti-server-storage-bucket | Forseti Server storage bucket |
| forseti-server-vm-ip | Forseti Server VM private IP address |
| forseti-server-vm-name | Forseti Server VM name |
| suffix | The random suffix appended to Forseti resources |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements
### Installation Dependencies
- [Terraform](https://www.terraform.io/downloads.html) 0.12
- [Terraform Provider for GCP][terraform-provider-google] plugin v2.11
- [terraform-provider-template](https://github.com/terraform-providers/terraform-provider-template) plugin >= v2.0
- [Python 3.7.x](https://www.python.org/getit/)
- [terraform-docs](https://github.com/segmentio/terraform-docs/releases) (optional) 0.6.0

### Service Account
In order to execute this module you must have a Service Account with the following roles assigned. There is a helpful setup script documented below which can automatically create this account for you.

### IAM Roles
For this module to work, you need the following roles enabled on the Service Account.

On the organization:
- `roles/resourcemanager.organizationAdmin`
- `roles/securityReviewer`

On the project:
- `roles/owner`
- `roles/compute.instanceAdmin`
- `roles/compute.networkViewer`
- `roles/compute.securityAdmin`
- `roles/iam.serviceAccountAdmin`
- `roles/serviceusage.serviceUsageAdmin`
- `roles/iam.serviceAccountUser`
- `roles/storage.admin`
- `roles/cloudsql.admin`

On the host project (when using shared VPC)
- `roles/compute.securityAdmin`
- `roles/compute.networkAdmin`

### GSuite Admin
To use the IAM exploration functionality of Forseti, you will need a Super Admin on the Google Admin console. This admin's email must be passed in the `gsuite_admin_email` variable.

### APIs
For this module to work, you need the following APIs enabled on the Forseti project.

- compute.googleapis.com
- serviceusage.googleapis.com
- cloudresourcemanager.googleapis.com

## Install
### Create the Service Account and enable required APIs
You can create the service account manually, or by running the following command:

```bash
./helpers/setup.sh -p PROJECT_ID -o ORG_ID
```

This will create a service account called `cloud-foundation-forseti-<suffix>`,
give it the proper roles, and download service account credentials to
`${PWD}/credentials.json`. Note, that using this script assumes that you are
currently authenticated as a user that can create/authorize service accounts at
both the organization and project levels.

This script will also activate necessary APIs required for terraform to run.

If you are using the real time policy enforcer, you will need to generate a
service account with a few extra roles. This can be enabled with the `-e`
flag:

```bash
./helpers/setup.sh -p PROJECT_ID -o ORG_ID -e
```

Utilizing a shared VPC via a host project is supported with the `-f` flag:

```bash
./helpers/setup.sh -p PROJECT_ID -f HOST_PROJECT_ID -o ORG_ID
```

### Terraform
Be sure you have the correct Terraform version (0.12), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

Additionally, you will need to export `TF_WARN_OUTPUT_ERRORS=1` to work around a [known issue](https://github.com/hashicorp/terraform/issues/17862) with Terraform when running terraform destroy.

### Manual steps
The following steps need to be performed manually/outside of this module.

#### GSuite Scanning

To **enable GSuite groups and users scanning**, you must activate [Domain Wide
Delegation](https://developers.google.com/admin-sdk/directory/v1/guides/delegation) on the Service Account used for Forseti server VM: `forseti-server-gcp-<number>@<project_id>.iam.gserviceaccount.com`.

Please refer to [the Forseti documentation](https://forsetisecurity.org/docs/latest/configure/inventory/gsuite.html) for step by step directions.

#### CSCC Integration

To **send Forseti notifications to the Cloud Security Command Center**, you need to
enable the Forseti add-on in the CSCC.

After activating the add-on, copy the integration's
`source_id` and paste it into the `cscc_source_id` field in your Terraform
configuration.

Run `terraform apply` again to complete the configuration.

### Cleanup
Remember to cleanup the service account used to install Forseti either manually, or by running the command:

```bash
./scripts/cleanup.sh -p PROJECT_ID -o ORG_ID -s cloud-foundation-forseti-<suffix>
```

This will deprovision and delete the service account, and then delete the credentials file.

If the service account was provisioned with the roles needed for the real time
policy enforcer, you can set the `-e` flag to clean up those roles as well:

```bash
./scripts/cleanup.sh -p PROJECT_ID -o ORG_ID -S cloud-foundation-forseti-<suffix> -e
```

## Autogeneration of documentation from .tf files
Run
```
make generate_docs
```

## Additional Documentation included

- (test/README.md):  Overview on howto run the test suite
- (test/integration/gcp/README.md): Detailed information about the base test suite
- (examples/simple/README.md): Overview of basic usage of the module


## File structure
The project has the following folders and files:

- (/): root folder
- (/examples): examples for using this module
- (/main.tf): main file for this module, contains all the resources to create
- (/variables.tf): all the variables for the module
- (/test): all integration tests are located here
- (/README.md): this file

[v2.3.0]: https://registry.terraform.io/modules/terraform-google-modules/forseti/google/2.3.0
[terraform-0.12-upgrade]: https://www.terraform.io/upgrade-guides/0-12.html
[terraform-provider-google]: https://github.com/terraform-providers/terraform-provider-google
