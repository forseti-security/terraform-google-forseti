# Terraform Forseti Install

The Terraform Forseti module can be used to quickly install and configure [Forseti](https://forsetisecurity.org/) in a fresh cloud project.

## Usage
A simple setup is provided in the examples folder; however, the usage of the module within your own main.tf file is as follows:

```hcl
    module "forseti-install-simple" {
      source                       = "github.com/terraform-google-modules/terraform-google-forseti"
      gsuite_admin_email           = "superadmin@yourdomain.com"
      project_id                   = "my-forseti-project"
      org_id                       = "2313934234"
      forseti_repo_url             = "https://github.com/GoogleCloudPlatform/forseti-security"
      forseti_version              = "dev"
    }
```

Then perform the following commands on the config folder:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bucket\_cai\_lifecycle\_age | GCS CAI lifecycle age value | string | `14` | no |
| bucket\_cai\_location | GCS CAI storage bucket location | string | `` | no |
| client\_boot\_image | GCE Forseti Client role instance size | string | `ubuntu-os-cloud/ubuntu-1804-lts` | no |
| client\_region | GCE Forseti Client role region size | string | `us-central1` | no |
| client\_type | GCE Forseti Client role instance size | string | `n1-standard-2` | no |
| cloudsql\_db\_name | CloudSQL database name | string | `forseti_security` | no |
| cloudsql\_db\_port | CloudSQL database port | string | `3306` | no |
| cloudsql\_proxy\_arch | CloudSQL Proxy architecture | string | `linux.amd64` | no |
| cloudsql\_region | CloudSQL region | string | `us-central1` | no |
| cloudsql\_type | CloudSQL Instance size | string | `db-n1-standard-1` | no |
| enable\_cai\_bucket | Enabling/Disabling the CAI Bucket | string | `false` | no |
| enable\_write | Enabling/Disabling write actions | string | `false` | no |
| folder\_id | GCP Folder that the Forseti project will be deployed into | string | `` | no |
| forseti\_email\_recipient | Email address that receives Forseti notifications | string | `` | no |
| forseti\_email\_sender | Email address that sends the Forseti notifications | string | `` | no |
| forseti\_home | Forseti installation directory | string | `$USER_HOME/forseti-security` | no |
| forseti\_repo\_url | Git repo for the Forseti installation | string | `https://github.com/GoogleCloudPlatform/forseti-security` | no |
| forseti\_run\_frequency | Schedule of running the Forseti scans | string | `* */2 * * *` | no |
| forseti\_version | Forseti software revision that you want | string | `stable` | no |
| gsuite\_admin\_email | G-Suite administrator email address to manage your Forseti installation | string | - | yes |
| org\_id | GCP Organization ID that Forseti will have purview over | string | `` | no |
| project\_id | Google Project ID that you want Forseti deployed into | string | - | yes |
| sendgrid\_api\_key | Sendgrid.com API key to enable email notifications | string | `` | no |
| server\_boot\_image | GCE instance image that is being used, currently Debian only support is available | string | `ubuntu-os-cloud/ubuntu-1804-lts` | no |
| server\_region | GCP region where Forseti will be deployed | string | `us-central1` | no |
| server\_type | GCE Forseti Server role instance size | string | `n1-standard-2` | no |
| storage\_bucket\_location | GCS storage bucket location | string | `us-central1` | no |
| vpc\_host\_network | VPC host network | string | `default` | no |
| vpc\_host\_project\_id | Shared VPC host project | string | `` | no |
| vpc\_host\_subnetwork | VPC subnetwork | string | `default` | no |
## Outputs


| Name | Description |
|------|-------------|
| forseti-client-vm-ip | - |
| forseti-client-vm-name | - |
| forseti-server-vm-ip | - |
| forseti-server-vm-name | - |
| foseti-client-service-account | - |
| foseti-server-service-account | - |

[^]: (autogen_docs_end)

## Requirements
### Installation Dependencies
- [Terraform](https://www.terraform.io/downloads.html) 0.11.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v1.12.0
- [Python 2.7.x](https://www.python.org/getit/)
- [terraform-docs](https://github.com/segmentio/terraform-docs/releases) (optional) 0.3.0

### Service Account
In order to execute this module you must have a Service Account with the following roles assigned. There is a helpful setup script documented below which can automatically create this account for you.

### IAM Roles
For this module to work, you need the following roles enabled on the Service Account.

On the organization:
- `roles/resourcemanager.organizationAdmin`

On the project:
- `roles/owner`

### GSuite Admin
To use the IAM exploration functionality of Forseti, you will need a Super Admin on the Google Admin console. This admin's email must be passed in the `gsuite_admin_email` variable.

## Install
### Create the Service Account
You can create the service account manually, or by running the following command:

```bash
./helpers/setup.sh <project_id>
```

This will create a service account called `cloud-foundation-forseti-<random_numbers>`, give it the proper roles, and download it to your current directory. Note, that using this script assumes that you are currently authenticated as a user that can create/authorize service accounts at both the organization and project levels.

### Terraform
Be sure you have the correct Terraform version (0.11.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

Additionally, you will need to export `TF_WARN_OUTPUT_ERRORS=1` to work around a [known issue](https://github.com/hashicorp/terraform/issues/17862) with Terraform when running terraform destroy.

### Manual steps
The following steps need to be performed manually/outside of this module.

#### Domain Wide Delegation
Remember to activate the Domain Wide Delegation on the Service Account that Forseti creates for the server operations.

The service account has the form `forseti-server-gcp-<number>@<project_id>.iam.gserviceaccount.com`.

Please refer to [the Forseti documentation](https://forsetisecurity.org/docs/howto/configure/gsuite-group-collection.html) for step by step directions.

More information about Domain Wide Delegation can be found [here](https://developers.google.com/admin-sdk/directory/v1/guides/delegation).

### Cleanup
Remember to cleanup the service account used to install Forseti either manually, or by running the command:

`./scripts/cleanup.sh <project_id> <service_account_id>`

This will deprovision and delete the service account, and then delete the credentials file.

## Autogeneration of documentation from .tf files
Run
```
make generate_docs
```

## File structure
The project has the following folders and files:

- /: root folder
- /examples: examples for using this module
- /main.tf: main file for this module, contains all the resources to create
- /variables.tf: all the variables for the module
- /README.md: this file
