# Forseti Terraform Module

The Google Terraform Forseti module is the only supported method of installing [Forseti Security](https://forsetisecurity.org/). The default infrastructure for Forseti is Google Compute Engine. This module also supports installing Forseti on Google Kubernetes Engine (GKE), and at some point in the future will become the default. For more information on installing Forseti on GKE, please see the [detailed guide on the Forseti Security website](https://forsetisecurity.org/docs/latest/setup/forseti-on-gke.html).

## Google Cloud Shell Walkthrough
A Google Cloud Shell Walkthrough has been setup to make it easy for users who are new to Forseti and Terraform. This walkthrough provides a set of instructions to get a default installation of Forseti setup that can be used in a production environment.

If you are familiar with Terraform and would like to run Terraform from a different machine, you can skip this walkthrough and move onto the [How to Deploy](#how-to-deploy) section.

[![Open in Google Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/open?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fforseti-security%2Fterraform-google-forseti.git&cloudshell_git_branch=modulerelease511&cloudshell_working_dir=examples/install_simple&cloudshell_image=gcr.io%2Fgraphite-cloud-shell-images%2Fterraform%3Alatest&cloudshell_tutorial=.%2Ftutorial.md)

## How to Deploy
In order to run this module you will need to be authenticated as a user that has access to the project and can create/authorize service accounts at both the organization and project levels. To login to GCP from a shell:

```bash
gcloud auth login
```

### Clone the Forseti Terraform Module repository
The repository has several helper scripts that can be used with the deployment process.

```bash
git clone --branch modulerelease511 --depth 1 https://github.com/forseti-security/terraform-google-forseti.git
```

### Install Terraform
Terraform version 0.12 is required for this module, which can be downloaded from the [Terraform website](https://www.terraform.io/downloads.html).

### Create the Service Account and enable required APIs
The Service Account and required APIs can be setup automatically with a provided script. This can also be done manually by reviewing the [Requirements](#requirements) section.
__Note:__ The setup script should be sourced by calling it with a preceding `.` so that exported environment variables are preserved.

```bash
. ./helpers/setup.sh -p PROJECT_ID -o ORG_ID
```

This will create a service account called `cloud-foundation-forseti-<suffix>`,
assign it the proper roles, and download the service account credentials to
`${PWD}/credentials.json`.

If you are using the real time policy enforcer, you will need to generate a
service account with a few extra roles. This can be enabled with the `-e`
flag:

```bash
. ./helpers/setup.sh -p PROJECT_ID -o ORG_ID -e
```

Utilizing a shared VPC via a host project is supported with the `-f` flag:

```bash
. ./helpers/setup.sh -p PROJECT_ID -f HOST_PROJECT_ID -o ORG_ID
```

### Terraform Configuration
Example configurations are included in the [examples](./examples/) directory. You can copy these examples or use the snippet below as a starting point to your own custom configuration.

The default Forseti Server VM [machine type](https://cloud.google.com/compute/docs/machine-types) and Cloud SQL [machine type](https://cloud.google.com/sql/pricing#2nd-gen-pricing) have been set to `n1-standard-8` and `db-n1-standard-4` to account for larger GCP environments. These can be changed by providing the `server_type` and `cloudsql_type` variables.

Create a file named `main.tf` in an empty directory and copy the contents below into the file.

```hcl
    module "forseti" {
      source  = "terraform-google-modules/forseti/google"
      version = "~> 5.1"

      gsuite_admin_email = "superadmin@yourdomain.com"
      domain             = "yourdomain.com"
      project_id         = "my-forseti-project"
      org_id             = "2313934234"
    }
```

Forseti provides many optional settings for users to customize for their environment and security requirements. View the list of [inputs](#inputs) to see all of the available options.

### Run Terraform
Forseti is ready to be installed! First you will need to initialize Terraform to download any of the module dependencies.

```bash
terraform init
```

The configuration can now be applied which will determine the necessary actions to perform on the GCP project.

```bash
terraform apply
```

Review the Terraform plan and enter `yes` to perform these actions.

### Cleanup
Remember to cleanup the service account used to install Forseti either manually or by running the command:

```bash
./scripts/cleanup.sh -p PROJECT_ID -o ORG_ID -s cloud-foundation-forseti-<suffix>
```

This will deprovision and delete the service account, and then delete the credentials file.

If the service account was provisioned with the roles needed for the real time
policy enforcer, you can set the `-e` flag to clean up those roles as well:

```bash
./scripts/cleanup.sh -p PROJECT_ID -o ORG_ID -S cloud-foundation-forseti-<suffix> -e
```

## Forseti Configuration
Now that Forseti has been deployed, there are additional steps that you can follow to further [configure Forseti](https://forsetisecurity.org/docs/latest/configure/). Some of the commonly used features are listed below:

- [Enable G Suite Scanning](https://forsetisecurity.org/docs/latest/configure/inventory/gsuite.html)
- [Enable Cloud Security Command Center Notifications](https://forsetisecurity.org/docs/latest/configure/notifier/index.html#cloud-scc-notification)
  - After activating this integration, add the Source ID into the Terraform configuration using the `cscc_source_id` input and re-run the Terraform apply command.

## Requirements
This section describes in detail the requirements necessary to deploy Forseti. The setup helper script automates the service account creation and enabling the APIs for you. Read through this section if you are not using the setup script or want to understand these details.

1. Install Terraform.
2. A GCP project to deploy Forseti into. The [Google Project Factory Terraform](https://github.com/terraform-google-modules/terraform-google-project-factory) module can be used to provision the project with the required APIs enabled, along with a Shared VPC connection.
3. The Service Account used to execute this module has the right permissions.
4. Enable the required GCP APIs to allow the Terraform module to deploy Forseti.

### Software Dependencies

#### Terraform and Plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.12
- [Terraform Provider for GCP](https://github.com/terraform-providers/terraform-provider-google) 2.11.0
- [Terraform Provider Templates](https://www.terraform.io/docs/providers/template/index.html) 2.0

### Service Account
In order to execute this module you must have a Service Account with the following IAM roles assigned.

#### IAM Roles
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

### APIs
For this module to work, you need the following APIs enabled on the Forseti project.

- cloudresourcemanager.googleapis.com
- compute.googleapis.com
- serviceusage.googleapis.com

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
| audit\_logging\_enabled | Audit Logging scanner enabled. | bool | `"false"` | no |
| audit\_logging\_violations\_should\_notify | Notify for Audit logging violations | bool | `"true"` | no |
| bigquery\_acl\_violations\_should\_notify | Notify for BigQuery ACL violations | bool | `"true"` | no |
| bigquery\_disable\_polling | Whether to disable polling for Big Query API | bool | `"false"` | no |
| bigquery\_enabled | Big Query scanner enabled. | bool | `"true"` | no |
| bigquery\_max\_calls | Maximum calls that can be made to Big Query API | string | `"160"` | no |
| bigquery\_period | The period of max calls for the Big Query API (in seconds) | string | `"1.0"` | no |
| blacklist\_enabled | Audit Logging scanner enabled. | bool | `"true"` | no |
| blacklist\_violations\_should\_notify | Notify for Blacklist violations | bool | `"true"` | no |
| bucket\_acl\_enabled | Bucket ACL scanner enabled. | bool | `"true"` | no |
| bucket\_cai\_lifecycle\_age | GCS CAI lifecycle age value | string | `"14"` | no |
| bucket\_cai\_location | GCS CAI storage bucket location | string | `"us-central1"` | no |
| buckets\_acl\_violations\_should\_notify | Notify for Buckets ACL violations | bool | `"true"` | no |
| cai\_api\_timeout | Timeout in seconds to wait for the exportAssets API to return success. | string | `"3600"` | no |
| client\_access\_config | Client instance 'access_config' block | map(any) | `<map>` | no |
| client\_boot\_image | GCE Forseti Client boot image | string | `"ubuntu-os-cloud/ubuntu-1804-lts"` | no |
| client\_instance\_metadata | Metadata key/value pairs to make available from within the client instance. | map(string) | `<map>` | no |
| client\_private | Private GCE Forseti Client VM (no public IP) | bool | `"false"` | no |
| client\_region | GCE Forseti Client region | string | `"us-central1"` | no |
| client\_ssh\_allow\_ranges | List of CIDRs that will be allowed ssh access to forseti client | list(string) | `<list>` | no |
| client\_tags | GCE Forseti Client VM Tags | list(string) | `<list>` | no |
| client\_type | GCE Forseti Client machine type | string | `"n1-standard-2"` | no |
| cloud\_profiler\_enabled | Enable the Cloud Profiler | bool | `"false"` | no |
| cloudasset\_disable\_polling | Whether to disable polling for Cloud Asset API | bool | `"false"` | no |
| cloudasset\_max\_calls | Maximum calls that can be made to Cloud Asset API | string | `"1"` | no |
| cloudasset\_period | The period of max calls for the Cloud Asset API (in seconds) | string | `"1.0"` | no |
| cloudbilling\_disable\_polling | Whether to disable polling for Cloud Billing API | bool | `"false"` | no |
| cloudbilling\_max\_calls | Maximum calls that can be made to Cloud Billing API | string | `"5"` | no |
| cloudbilling\_period | The period of max calls for the Cloud Billing API (in seconds) | string | `"1.2"` | no |
| cloudsql\_acl\_enabled | Cloud SQL scanner enabled. | bool | `"true"` | no |
| cloudsql\_acl\_violations\_should\_notify | Notify for CloudSQL ACL violations | bool | `"true"` | no |
| cloudsql\_db\_name | CloudSQL database name | string | `"forseti_security"` | no |
| cloudsql\_db\_port | CloudSQL database port | string | `"3306"` | no |
| cloudsql\_disk\_size | The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased. | string | `"25"` | no |
| cloudsql\_net\_write\_timeout | See MySQL documentation: https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_net_write_timeout | string | `"240"` | no |
| cloudsql\_private | Whether to enable private network and not to create public IP for CloudSQL Instance | bool | `"false"` | no |
| cloudsql\_proxy\_arch | CloudSQL Proxy architecture | string | `"linux.amd64"` | no |
| cloudsql\_region | CloudSQL region | string | `"us-central1"` | no |
| cloudsql\_type | CloudSQL Instance size | string | `"db-n1-standard-4"` | no |
| cloudsql\_user\_host | The host the user can connect from.  Can be an IP address or IP address range. Changing this forces a new resource to be created. | string | `"%"` | no |
| composite\_root\_resources | A list of root resources that Forseti will monitor. This supersedes the root_resource_id when set. | list(string) | `<list>` | no |
| compute\_disable\_polling | Whether to disable polling for Compute API | bool | `"false"` | no |
| compute\_max\_calls | Maximum calls that can be made to Compute API | string | `"18"` | no |
| compute\_period | The period of max calls for the Compute API (in seconds) | string | `"1.0"` | no |
| config\_validator\_enabled | Config Validator scanner enabled. | bool | `"false"` | no |
| config\_validator\_violations\_should\_notify | Notify for Config Validator violations. | bool | `"true"` | no |
| container\_disable\_polling | Whether to disable polling for Container API | bool | `"false"` | no |
| container\_max\_calls | Maximum calls that can be made to Container API | string | `"9"` | no |
| container\_period | The period of max calls for the Container API (in seconds) | string | `"1.0"` | no |
| crm\_disable\_polling | Whether to disable polling for CRM API | bool | `"false"` | no |
| crm\_max\_calls | Maximum calls that can be made to CRN API | string | `"4"` | no |
| crm\_period | The period of max calls for the CRM  API (in seconds) | string | `"1.2"` | no |
| cscc\_source\_id | Source ID for CSCC Beta API | string | `""` | no |
| cscc\_violations\_enabled | Notify for CSCC violations | bool | `"false"` | no |
| domain | The domain associated with the GCP Organization ID | string | n/a | yes |
| enable\_cai\_bucket | Create a GCS bucket for CAI exports | bool | `"true"` | no |
| enable\_write | Enabling/Disabling write actions | bool | `"false"` | no |
| enabled\_apis\_enabled | Enabled APIs scanner enabled. | bool | `"false"` | no |
| enabled\_apis\_violations\_should\_notify | Notify for enabled APIs violations | bool | `"true"` | no |
| excluded\_resources | A list of resources to exclude during the inventory phase. | list(string) | `<list>` | no |
| external\_project\_access\_violations\_should\_notify | Notify for External Project Access violations | bool | `"true"` | no |
| firewall\_rule\_enabled | Firewall rule scanner enabled. | bool | `"true"` | no |
| firewall\_rule\_violations\_should\_notify | Notify for Firewall rule violations | bool | `"true"` | no |
| folder\_id | GCP Folder that the Forseti project will be deployed into | string | `""` | no |
| forseti\_email\_recipient | Email address that receives Forseti notifications | string | `""` | no |
| forseti\_email\_sender | Email address that sends the Forseti notifications | string | `""` | no |
| forseti\_home | Forseti installation directory | string | `"$USER_HOME/forseti-security"` | no |
| forseti\_repo\_url | Git repo for the Forseti installation | string | `"https://github.com/forseti-security/forseti-security"` | no |
| forseti\_run\_frequency | Schedule of running the Forseti scans | string | `"null"` | no |
| forseti\_version | The version of Forseti to install | string | `"v2.24.0"` | no |
| forwarding\_rule\_enabled | Forwarding rule scanner enabled. | bool | `"false"` | no |
| forwarding\_rule\_violations\_should\_notify | Notify for forwarding rule violations | bool | `"true"` | no |
| group\_enabled | Group scanner enabled. | bool | `"true"` | no |
| groups\_settings\_disable\_polling | Whether to disable polling for the G Suite Groups API | bool | `"false"` | no |
| groups\_settings\_enabled | Groups settings scanner enabled. | bool | `"true"` | no |
| groups\_settings\_max\_calls | Maximum calls that can be made to the G Suite Groups API | string | `"5"` | no |
| groups\_settings\_period | the period of max calls to the G Suite Groups API | string | `"1.1"` | no |
| groups\_settings\_violations\_should\_notify | Notify for groups settings violations | bool | `"true"` | no |
| groups\_violations\_should\_notify | Notify for Groups violations | bool | `"true"` | no |
| gsuite\_admin\_email | G-Suite administrator email address to manage your Forseti installation | string | `""` | no |
| iam\_disable\_polling | Whether to disable polling for IAM API | bool | `"false"` | no |
| iam\_max\_calls | Maximum calls that can be made to IAM API | string | `"90"` | no |
| iam\_period | The period of max calls for the IAM API (in seconds) | string | `"1.0"` | no |
| iam\_policy\_enabled | IAM Policy scanner enabled. | bool | `"true"` | no |
| iam\_policy\_violations\_should\_notify | Notify for IAM Policy violations | bool | `"true"` | no |
| iam\_policy\_violations\_slack\_webhook | Slack webhook for IAM Policy violations | string | `""` | no |
| iap\_enabled | IAP scanner enabled. | bool | `"true"` | no |
| iap\_violations\_should\_notify | Notify for IAP violations | bool | `"true"` | no |
| instance\_network\_interface\_enabled | Instance network interface scanner enabled. | bool | `"false"` | no |
| instance\_network\_interface\_violations\_should\_notify | Notify for instance network interface violations | bool | `"true"` | no |
| inventory\_email\_summary\_enabled | Email summary for inventory enabled | bool | `"false"` | no |
| inventory\_gcs\_summary\_enabled | GCS summary for inventory enabled | bool | `"true"` | no |
| inventory\_retention\_days | Number of days to retain inventory data. | string | `"-1"` | no |
| ke\_scanner\_enabled | KE scanner enabled. | bool | `"false"` | no |
| ke\_version\_scanner\_enabled | KE version scanner enabled. | bool | `"true"` | no |
| ke\_version\_violations\_should\_notify | Notify for KE version violations | bool | `"true"` | no |
| ke\_violations\_should\_notify | Notify for KE violations | bool | `"true"` | no |
| kms\_scanner\_enabled | KMS scanner enabled. | bool | `"true"` | no |
| kms\_violations\_should\_notify | Notify for KMS violations | bool | `"true"` | no |
| kms\_violations\_slack\_webhook | Slack webhook for KMS violations | string | `""` | no |
| lien\_enabled | Lien scanner enabled. | bool | `"true"` | no |
| lien\_violations\_should\_notify | Notify for lien violations | bool | `"true"` | no |
| location\_enabled | Location scanner enabled. | bool | `"true"` | no |
| location\_violations\_should\_notify | Notify for location violations | bool | `"true"` | no |
| log\_sink\_enabled | Log sink scanner enabled. | bool | `"true"` | no |
| log\_sink\_violations\_should\_notify | Notify for log sink violations | bool | `"true"` | no |
| logging\_disable\_polling | Whether to disable polling for Logging API | bool | `"false"` | no |
| logging\_max\_calls | Maximum calls that can be made to Logging API | string | `"9"` | no |
| logging\_period | The period of max calls for the Logging API (in seconds) | string | `"1.0"` | no |
| mailjet\_enabled | Enable mailjet_rest library | bool | `"false"` | no |
| manage\_rules\_enabled | A toggle to enable or disable the management of rules | bool | `"true"` | no |
| network | The VPC where the Forseti client and server will be created | string | `"default"` | no |
| network\_project | The project containing the VPC and subnetwork where the Forseti client and server will be created | string | `""` | no |
| org\_id | GCP Organization ID that Forseti will have purview over | string | `""` | no |
| policy\_library\_home | The local policy library directory. | string | `"$USER_HOME/policy-library"` | no |
| policy\_library\_repository\_url | The git repository containing the policy-library. | string | `""` | no |
| policy\_library\_sync\_enabled | Sync config validator policy library from private repository. | bool | `"false"` | no |
| policy\_library\_sync\_gcs\_directory\_name | The directory name of the GCS folder used for the policy library sync config. | string | `"policy_library_sync"` | no |
| policy\_library\_sync\_git\_sync\_tag | Tag for the git-sync image. | string | `"v3.1.2"` | no |
| policy\_library\_sync\_ssh\_known\_hosts | List of authorized public keys for SSH host of the policy library repository. | string | `""` | no |
| project\_id | Google Project ID that you want Forseti deployed into | string | n/a | yes |
| resource\_enabled | Resource scanner enabled. | bool | `"true"` | no |
| resource\_name\_suffix | A suffix which will be appended to resource names. | string | `"null"` | no |
| resource\_violations\_should\_notify | Notify for resource violations | bool | `"true"` | no |
| securitycenter\_max\_calls | Maximum calls that can be made to Security Center API | string | `"14"` | no |
| securitycenter\_period | The period of max calls for the Security Center API (in seconds) | string | `"1.0"` | no |
| sendgrid\_api\_key | Sendgrid.com API key to enable email notifications | string | `""` | no |
| server\_access\_config | Server instance 'access_config' block | map(any) | `<map>` | no |
| server\_boot\_disk\_size | Size of the GCE instance boot disk in GBs. | string | `"100"` | no |
| server\_boot\_disk\_type | GCE instance boot disk type, can be pd-standard or pd-ssd. | string | `"pd-ssd"` | no |
| server\_boot\_image | GCE Forseti Server boot image - Currently only Ubuntu is supported | string | `"ubuntu-os-cloud/ubuntu-1804-lts"` | no |
| server\_grpc\_allow\_ranges | List of CIDRs that will be allowed gRPC access to forseti server | list(string) | `<list>` | no |
| server\_instance\_metadata | Metadata key/value pairs to make available from within the server instance. | map(string) | `<map>` | no |
| server\_private | Private GCE Forseti Server VM (no public IP) | bool | `"false"` | no |
| server\_region | GCE Forseti Server region | string | `"us-central1"` | no |
| server\_ssh\_allow\_ranges | List of CIDRs that will be allowed ssh access to forseti server | list(string) | `<list>` | no |
| server\_tags | GCE Forseti Server VM Tags | list(string) | `<list>` | no |
| server\_type | GCE Forseti Server machine type | string | `"n1-standard-8"` | no |
| service\_account\_key\_enabled | Service account key scanner enabled. | bool | `"true"` | no |
| service\_account\_key\_violations\_should\_notify | Notify for service account key violations | bool | `"true"` | no |
| servicemanagement\_disable\_polling | Whether to disable polling for Service Management API | bool | `"false"` | no |
| servicemanagement\_max\_calls | Maximum calls that can be made to Service Management API | string | `"2"` | no |
| servicemanagement\_period | The period of max calls for the Service Management API (in seconds) | string | `"1.1"` | no |
| serviceusage\_disable\_polling | Whether to disable polling for Service Usage API | bool | `"false"` | no |
| serviceusage\_max\_calls | Maximum calls that can be made to Service Usage API | string | `"4"` | no |
| serviceusage\_period | The period of max calls for the Service Usage API (in seconds) | string | `"1.1"` | no |
| sqladmin\_disable\_polling | Whether to disable polling for SQL Admin API | bool | `"false"` | no |
| sqladmin\_max\_calls | Maximum calls that can be made to SQL Admin API | string | `"1"` | no |
| sqladmin\_period | The period of max calls for the SQL Admin API (in seconds) | string | `"1.1"` | no |
| storage\_bucket\_location | GCS storage bucket location | string | `"us-central1"` | no |
| storage\_disable\_polling | Whether to disable polling for Storage API | bool | `"false"` | no |
| subnetwork | The VPC subnetwork where the Forseti client and server will be created | string | `"default"` | no |
| violations\_slack\_webhook | Slack webhook for any violation. Will apply to all scanner violation notifiers. | string | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| forseti-cai-storage-bucket | Forseti CAI storage bucket |
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

## File structure
The project has the following folders and files:

- [build/](./build/): Google Cloud Build configuration
- [docs/](./docs/): Additional documentation
- [examples/](./examples/): examples for using this module
- [helpers/](./helpers/): Helper scripts
- [modules/](./modules/): Private and sub-modules
- [test/](./test/): All integration tests are located here
- [CHANGELOG.md](./CHANGELOG.md): A list of changes made for each release
- [CONTRIBUTING.md](./CONTRIBUTING.md): Information on how to contribute to this project
- [LICENSE](./LICENSE): License terms and conditions
- [main.tf](./main.tf): Main Terraform configuration file for this module, contains all the resources to install Forseti
- [README.md](./README.md): This readme file
- [variables.tf](./variables.tf): All the variables for the module
