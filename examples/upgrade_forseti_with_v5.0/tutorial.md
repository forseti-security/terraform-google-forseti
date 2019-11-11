# Upgrading Forseti with Terraform

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>

This guide explains how to upgrade Forseti previously installed with Terraform,
to version 2.23.  This is due to a breaking change introduced in this Terraform
module, now version 5.0.0.  The steps outlined in this guide should not be needed
after Forseti has been upgraded versions 2.23 or above.


If you have any
questions about this process, please contact us by
[email](mailto:discuss@forsetisecurity.org) or on
[Slack](https://forsetisecurity.slack.com/join/shared_invite/enQtNDIyMzg4Nzg1NjcxLTM1NTUzZmM2ODVmNzE5MWEwYzAwNjUxMjVkZjhmYWZiOGZjMjY3ZjllNDlkYjk1OGU4MTVhZGM4NzgyZjZhNTE).

## Prerequisites

Before you begin the migration process, you will need:

- A Forseti deployment of at least v2.18.0; follow the
  [upgrade guide](https://forsetisecurity.org/docs/latest/setup/upgrade.html) as
  necessary deployed via the [terraform-google-forseti Terraform module](https://github.com/forseti-security/terraform-google-forseti).
  Please note that the upper bound of the upgrades possible for the Python installer is 2.22.
- A version of the
  [Terraform command-line interface](https://www.terraform.io/downloads.html)
  in the 0.12 series.
- The ID of the GCP project in which Forseti is deployed.
- A service account in the organization with the
  [roles required by the Terraform module](https://registry.terraform.io/modules/terraform-google-modules/forseti/google/4.3.0#iam-roles).
- A
  [JSON key file](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#creating_service_account_keys)
  for the service account.
- If you are an Org Admin in the organization in which you deploying Forseti, a separate Service Account and Key are recommended,
  but not required.
- **Strongly recommended out of an overabundance of caution:** A backup of your current state.
  - In the Forseti Server's GCS Bucket
    - Scanner rules
    - Server config file
    - Scanner Violations
    - Inventory summary
  - [CloudSQL database](https://cloud.google.com/sql/docs/mysql/backup-recovery/backups)

## Configuring Terraform

Terraform can assume the identity of a service account through a
strategy called
[Application Default Credentials](https://cloud.google.com/docs/authentication/production#providing_credentials_to_your_application)
when provisioning resources. To enable this approach, set the
appropriate environment variable to the path of the service account JSON
key file:

```sh
export GOOGLE_APPLICATION_CREDENTIALS="PATH_TO_JSON_KEY_FILE"
```
As stated in the pre-requisites, if you have Org Admin privilges, you do not need to complete this step.

## Backup the Terraform State
In a shell, navigate to the folder containing your user-defined Terraform module, most likely in a **main.tf**.

The following command will simultaneously backup your existing Terraform state and remove resource from the current state file.  This will not affect your existing Forseti deployment.
```sh
terraform state rm $(terraform state list)
```
## Update main.tf
In order to support this upgrade, we'll need to update a few input variables.

### Source
The **source** will need to point to the root terraform-google-forseti module.
```
source = "terraform-google-modules/forseti/google"
```
If you have cloned the module to your local file system, you may set the **source** path to
the directory containing the module.

### Version
The **version** will need to be 5.0.0.
```
version = "5.0.0"
```
If you have set the **source** path to the directory containing the module, omit the **version** variable.

### Region
If you have a **region**, it will need to be split into the cloudsql_region, server_region, and client_region
variables.  You will also need to set the location of the Forseti Client and Server storage buckets
(**storage_bucket_location**) as well as the CAI storage bucket (**bucket_cai_location**).

**NOTE:** In order to prevent data loss to your CloudSQL database, please double check the region where
your CloudSQL instance currently exists and update the **cloudsql_region** variable, accourdingly.

Before (example):
```
region = "us-central1"
```
After (example):
```
cloudsql_region = "us-central1"
server_region   = "us-central1"
client_region   = "us-central1"

storage_bucket_location = "us-central1"
bucket_cai_location     = "us-central1"
```
### Credentials path
Remove the **credentials_path** variable if present.  The `google` provider now solely relies on the _GOOGLE_APPLICATION_CREDENTIALS_ environment variable.

### Root Resource identity
Add the **resource_name_suffix** variable and set it to the resource suffix.  The suffix can be found appended to the Forseti Server VM, for example.
```
resource_name_suffix = "abc123efg"
```
### Server Rules and Login
Add the following clause to the bottom of your main.tf.
```
  client_instance_metadata = {
        enable-oslogin = "TRUE"
      }
  enable_write         = true
  manage_rules_enabled = false
```

## Obtain and Run the Import Script
### Obtain the Import Script
This [import script](https://github.com/forseti-security/terraform-google-forseti/blob/module-release-5.0.0/helpers/import.sh) will import the Forseti GCP resources into a local state file.

```sh
curl --location --remote-name https://raw.githubusercontent.com/forseti-security/terraform-google-forseti/module-release-5.0.0/helpers/import.sh
chmod +x import.sh
./import.sh -h
```
### Initialize the Terraform Module
```sh
terraform init
```

### Import the Existing Terraform State
Import the existing resources to the Terraform state, replacing the
uppercase values with the aforementioned values:

```sh
./import.sh -m MODULE_LOCAL_NAME -o ORG_ID -p PROJECT_ID -s RESOURCE_NAME_SUFFIX -z GCE_ZONE [-n NETWORK_PROJECT_ID]
```

Observe the expected Terraform changes by execution `terraform plan`.  As stated in the introduction, if you have any
questions about this process, please contact us by
[email](mailto:discuss@forsetisecurity.org) or on
[Slack](https://forsetisecurity.slack.com/join/shared_invite/enQtNDIyMzg4Nzg1NjcxLTM1NTUzZmM2ODVmNzE5MWEwYzAwNjUxMjVkZjhmYWZiOGZjMjY3ZjllNDlkYjk1OGU4MTVhZGM4NzgyZjZhNTE).

## Terraform Plan
It is strongly recommend to execute `terraform plan` before `terraform apply`.  This
will provide you an opportunity to review changes Terraform is planning to make
to your deployment.

```sh
terraform plan
```

### Terraform Changes

Because there is not an exact mapping between the deprecated Python
Installer and the Terraform module, some changes will occur when
Terraform assumes management of the Forseti deployment.

You should carefully review this section as well as the output from
`terraform plan` to ensure that all changes are expected and acceptable.

Observe the expected Terraform changes.  As stated in the introduction, if you have any
questions about this process, please contact us by
e-mail at discuss@forsetisecurity.org or on
[Slack](https://forsetisecurity.slack.com/join/shared_invite/enQtNDIyMzg4Nzg1NjcxLTM1NTUzZmM2ODVmNzE5MWEwYzAwNjUxMjVkZjhmYWZiOGZjMjY3ZjllNDlkYjk1OGU4MTVhZGM4NzgyZjZhNTE).


#### Created

- The `forseti-client-gcp-RESOURCE_NAME_SUFFIX` service account will
  gain the Cloud Trace Agent (`roles/cloudtrace.agent`) role
- The `forseti-client-gcp-RESOURCE_NAME_SUFFIX` service account will
  gain the Cloud Trace Agent (`roles/storage.objectViewer`) role
- The `forseti-server-gcp-RESOURCE_NAME_SUFFIX` service account will
  gain the following roles.  Note your server service account likely
  has these roles already.  Terraform re-applying them is essentially
  a no-op.
  - Cloud Trace Agent (`roles/cloudtrace.agent`)
  - IAM Service Account Token Creator (`roles/iam.serviceAccountTokenCreator`)
  - App Engine Viewer (`roles/appengine.appViewer`)
  - BigQuery Meta-data Viewer (`roles/bigquery.metadataViewer`)
  - Project Reader (`roles/browser`)
  - Cloud Asset Viewer (`roles/cloudasset.viewer`)
  - CloudSQL Viewer (`roles/cloudsql.viewer`)
  - Network Viewer (`roles/compute.networkViewer`)
  - Security Reviewer (`roles/iam.securityReviewer`)
  - Organization Policy Viewer (`roles/orgpolicy.policyViewer`)
  - Sevice Management Quota Viewer (`roles/servicemanagement.quotaViewer`)
  - Service Usage Consumer (`roles/serviceusage.serviceUsageConsumer`)
  - Compute Security Admin (`roles/compute.securityAdmin`)
  - Storage Object Viewer (`roles/storage.objectViewer`)
  - Storage Object Creator (`roles/storage.objectCreator`)
  - CloudSQL Client (`roles/cloudsql.client`)
  - Stackdriver Log Writer (`roles/logging.logWriter`)
  - Service Account Token Creator (`roles/iam.serviceAccountTokenCreator`)

#### Updated In-Place

- The `forseti-client-deny-all-RESOURCE_NAME_SUFFIX` firewall rule and
  the `forseti-server-deny-all-RESOURCE_NAME_SUFFIX` firewall rule will
  both update from denying all protocols to denying ICMP, TCP, and UDP
- The `forseti-server-allow-grpc-RESOURCE_NAME_SUFFIX` firewall rule
  will update to only allow traffic from the
  `forseti-client-gcp-RESOURCE_NAME_SUFFIX` service account and to allow
  traffic to port 50052 in addition to 50051
- The `forseti-cai-export-RESOURCE_NAME_SUFFIX`, `forseti-client-RESOURCE_NAME_SUFFIX` and `forseti-server-RESOURCE_NAME_SUFFIX`
  GCS bucket to set `force_destroy` to `true`.
- The `forseti-client-gcp-RESOURCE_NAME_SUFFIX` and `forseti-server-gcp-RESOURCE_NAME_SUFFIX`
  service accounts will be updated in place to change the display name
- The `forseti-server-db-RESOURCE_NAME_SUFFIX` CloudSQL database will
  increase in resource size.  It will also gain the `net_write_timeout`
  flag.


#### Destroyed and Replaced

- The `forseti-client-allow-ssh-external-RESOURCE_NAME_SUFFIX` firewall
  rule and the `forseti-server-allow-ssh-external-RESOURCE_NAME_SUFFIX`
  firewall rule will both be replaced due to a naming change, but the new firewall
  rules will be equivalent
- The `forseti-client-vm-RESOURCE_NAME_SUFFIX` compute instance and the
  `forseti-server-vm-RESOURCE_NAME_SUFFIX` compute instance will be
  replaced due to changes in metadata startup scripts, boot disk sizes
  and boot disk types; these VMs should be stateless but ensure that
  any customizations are captured before applying this change
- The `configs/forseti_conf_client.yaml` object in the
  `forseti-client-RESOURCE_NAME_SUFFIX` storage bucket and the
  `configs/forseti_conf_server.yaml` object in the
  `forseti-server-RESOURCE_NAME_SUFFIX` storage bucket will be replaced
  due to a lack of Terraform import support

## Apply the Terraform Changes
Execute the following to apply the Terraform plan.
```sh
terraform apply
```
## Client VM Endpoint
It is possible that the *forseti_conf_client.yaml* did not get updated with the right
**server_ip** address.  This is a known issue and is being investigated.  Please perform
the following steps.

1. Update the **server_ip** in your `forseti-client-RESOURCE_NAME_SUFFIX/configs/forseti_config_client.yaml`
file if necessary.

2. Reset your client VM.

## Upgrade Complete

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

You have completed upgrading Forseti to 2.23 with the re-architected
terraform-google-forseti Terraform module!
