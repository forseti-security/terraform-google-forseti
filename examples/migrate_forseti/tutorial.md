# Migrate Forseti from the Python Installer

## Introduction

<walkthrough-tutorial-duration duration="30"></walkthrough-tutorial-duration>


This guide explains how to migrate a Forseti deployment from the
deprecated Python Installer to the new Terraform module.

Completing this guide will also result in a Forseti deployment upgraded to the most recent version.

If you have any
questions about this process, please contact us by
e-mail at discuss@forsetisecurity.org or on
[Slack](https://forsetisecurity.slack.com/join/shared_invite/enQtNDIyMzg4Nzg1NjcxLTM1NTUzZmM2ODVmNzE5MWEwYzAwNjUxMjVkZjhmYWZiOGZjMjY3ZjllNDlkYjk1OGU4MTVhZGM4NzgyZjZhNTE).

## Prerequisites

Before you begin the migration process, you will need:

- A Forseti deployment of at least v2.18.0.  You must follow the
  [upgrade guide](https://forsetisecurity.org/docs/latest/setup/upgrade.html) to be at least v2.18.0.
- A version of the
  [Terraform command-line interface](https://www.terraform.io/downloads.html)
  in the 0.12 series.
- The domain and ID of the Google Cloud Platform (GCP) organization in
  which Forseti is deployed.
- The ID of the GCP project in which Forseti is deployed.
- The suffix appended to the names of the Forseti resources; this is
  likely a string of seven characters like a1b2c3d.
- A service account for the organization with the
  [roles required by the Terraform module](https://registry.terraform.io/modules/terraform-google-modules/forseti/google/5.0.0#iam-roles).
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

If you deployed Forseti in a shared VPC then you will also need:

- The ID of the GCP project in which the shared VPC is hosted.
- The ID of the shared VPC network in which Forseti is deployed.
- The ID of the subnetwork from the shared VPC network in which Forseti is deployed.


## Configure gcloud
In the Cloud Shell, configure `gcloud` to use the GCP in which Forseti is deployed.
```bash
gcloud config set project PROJECT_ID
```

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

## Configure Forseti
To install Forseti, you will need to update a few settings in the <walkthrough-editor-open-file filePath="terraform-google-forseti/examples/migrate_forseti/main.tf">main.tf</walkthrough-editor-open-file>.

Update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/migrate_forseti/main.tf"
  regex="DOMAIN">domain</walkthrough-editor-select-regex>
to match your domain.

Update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/migrate_forseti/main.tf"
  regex="PROJECT_ID">project_id</walkthrough-editor-select-regex>
to match your chosen project_id.

Update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/migrate_forseti/main.tf"
  regex="RESOURCE_NAME_SUFFIX">resource_name_suffix</walkthrough-editor-select-regex>
to match the string appended to the GCP resources used by Forseti.  For example, this string can be found appended to the name of either the Forseti Server or Forseti Client VM's.

Update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/migrate_forseti/main.tf"
  regex="ORG_ID">org_id</walkthrough-editor-select-regex>
to match your organization id.

### Choose Network
Update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/migrate_forseti/main.tf"
  regex="default">network</walkthrough-editor-select-regex>
you wish to deploy Forseti in.

Update the <walkthrough-editor-select-line
  filePath="terraform-google-forseti/examples/migrate_forseti/main.tf"
  startLine=51
  endLine=51
  startCharacterOffset=21
  endCharacterOffset=28>subnetwork</walkthrough-editor-select-line>.


### Shared VPC
If using a shared VPC, you'll need to update the related input variables.

Update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/migrate_forseti/main.tf"
  regex="SHARED_VPC_PROJECT_ID">network_project</walkthrough-editor-select-regex>
to match the project in which your shared VPC exists.

### Update Region
By default, Forseti deploys into us-central1.  If you deployed Forseti in a different region, you will need to
update the cloudsql_region, server_region, and client_region input variables.

Update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/migrate_forseti/main.tf"
  regex="us-central1">cloudsql_region</walkthrough-editor-select-regex>
to match the region where CloudSQL is deployed.

Update the <walkthrough-editor-select-line
  filePath="terraform-google-forseti/examples/migrate_forseti/main.tf"
  startLine=63
  endLine=63
  startCharacterOffset=21
  endCharacterOffset=33>server_region</walkthrough-editor-select-line>
to match the region where the Forseti Server VM is deployed.

Update the <walkthrough-editor-select-line
  filePath="terraform-google-forseti/examples/migrate_forseti/main.tf"
  startLine=64
  endLine=64
  startCharacterOffset=21
  endCharacterOffset=33>client_region</walkthrough-editor-select-line>
to match the region where the Forseti Client VM is deployed.

## Add Input Variables for Custom Configurations
Starting with Forseti Security 2.23, Terraform will manage your server
 configuration file for you.  Configuration options will now be input
 variables that are defined in the Terraform module.  This will ensure
 upgrading Forseti will be as easy as possible going forward.

Please identify any Forseti server configuration variables that have
been customized and add them to your <walkthrough-editor-open-file filePath="terraform-google-forseti/examples/migrate_forseti/main.tf">main.tf</walkthrough-editor-open-file>.

For example, if you modified the e-mail connector recipient in the **forseti_conf_server.yaml** file in the Forseti Server GCS bucket:
```yaml
email_connector:
      name: sendgrid
      auth:
        api_key: ...
      sender: ...
      recipient: myemail@example.com
      data_format: csv
```
You will want to add the
`forseti_email_recipient = myemail@example.com`
to your <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/migrate_forseti/main.tf"
  regex="Add any Forseti Server Configuration Variables Here">main.tf</walkthrough-editor-select-regex>

## Obtain and Run the Import Script
This [import script](https://github.com/forseti-security/terraform-google-forseti/blob/master/helpers/import.sh) will import the Forseti GCP resources into a local state file.

```sh
curl --location --remote-name https://raw.githubusercontent.com/forseti-security/terraform-google-forseti/master/helpers/import.sh
chmod +x import.sh
./import.sh -h
```
## Importing Existing Resources

Initialize the Terraform state:

```sh
terraform init
```

Import the existing resources to the Terraform state, replacing the
uppercase values with the aforementioned values:

```sh
./import.sh -m MODULE_LOCAL_NAME -o ORG_ID -p PROJECT_ID -s RESOURCE_NAME_SUFFIX -z GCE_ZONE [-n NETWORK_PROJECT_ID]
```

## Terraform Plan
It is strongly recommend to execute `terraform plan` before `terraform apply`.  This
will provide you an opportunity to review changes Terraform is planning to make
to your deployment.

```sh
terraform plan
```

### Review Terraform Changes
Observe the expected Terraform changes.  As stated in the introduction, if you have any
questions about this process, please contact us bye-mail at discuss@forsetisecurity.org
or on [Slack](https://forsetisecurity.slack.com/join/shared_invite/enQtNDIyMzg4Nzg1NjcxLTM1NTUzZmM2ODVmNzE5MWEwYzAwNjUxMjVkZjhmYWZiOGZjMjY3ZjllNDlkYjk1OGU4MTVhZGM4NzgyZjZhNTE).

Because there is not an exact mapping between the deprecated Python
Installer and the Terraform module, some changes will occur when
Terraform assumes management of the Forseti deployment.

You should carefully review this section as well as the output from
`terraform plan` to ensure that all changes are expected and acceptable.

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
- The `forseti-client-RESOURCE_NAME_SUFFIX` and `forseti-server-RESOURCE_NAME_SUFFIX`
  GCS bucket to remove bucket labels
- The `forseti-cai-export-RESOURCE_NAME_SUFFIX` GCS bucket to remove bucket
  labels and update lifecycle conditions
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

At this point, the existing Forseti deployment has been migrated to a
Terraform state.

## Save state to GCS
Congratulations, you have now installed Forseti!

**IMPORTANT:** As a final step, you will want to save your configuration so it can be used to upgrade Forseti in the future.

### Create Terraform state bucket
Create a Google Cloud Storage bucket to [store your Terraform state](https://www.terraform.io/docs/state/).

```bash
gsutil mb gs://PROJECT_ID-tfstate
```

### Update state configuration
Open <walkthrough-editor-open-file filePath="terraform-google-forseti/examples/migrate_forseti/backend.tf">backend.tf</walkthrough-editor-open-file> and uncomment the contents.

On line 3, update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/migrate_forseti/backend.tf"
  regex="my-project">project ID</walkthrough-editor-select-regex>
project ID to match your project ID.

Finally, re-initialize Terraform to upload your state to Cloud Storage:

```bash
terraform init
```

At the prompt, type `yes`.

## Save configuration to git
As a best practice, you should save your Terraform configuration to source control. This can be done using Cloud Source Repositories.

### Create a repo
```bash
gcloud source repos create terraform-forseti
```

### Initalize git
```bash
git init
```

### Add and commit your files

```bash
git add -A
```

```bash
git commit -m "Initial commit"
```

You may be prompted to configure your identity for Git. If you are, follow the provided commands to do so and run commit again.

### Push your configuration
```bash
git remote add origin https://source.developers.google.com/p/{{project_id}}/r/terraform-forseti
```

```bash
git push origin master
```

## Installation Complete

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

You have completed migrating Forseti from the Python installer to Terraform and saving your configuration!
