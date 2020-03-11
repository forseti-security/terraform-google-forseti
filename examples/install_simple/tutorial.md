# Deploy Forseti

## Introduction
<walkthrough-tutorial-duration duration="10"></walkthrough-tutorial-duration>

This walkthrough explains how to deploy [Forseti](https://forsetisecurity.org/about/) in a GCP project using Terraform.

## Authentication
In order to run this module you will need to be authenticated as a user that has access to the project and can create/authorize service accounts at both the organization and project levels. You can login as this user with Chrome or by using gcloud:

 ```bash
 gcloud auth login
```

## Select Project
<walkthrough-project-billing-setup billing="true"></walkthrough-project-billing-setup>

First, create a new Project or select an existing Project where Forseti will be deployed.

This can be a dedicated Forseti project or an existing DevSecOps project.


## Prerequisites
In order to execute this module a temporary Service Account will be created with the roles required. A few GCP APIs also need to be enabled. These steps have been automated with a setup script. The [IAM Roles](/README.md#iam-roles) given to the Service Account and the [APIs](/README.md#apis) that will be enabled are listed on the README.

The **roles/compute.networkAdmin** will also be applied to the Service Account in order to deploy a Cloud NAT.

Set the project ID for future gcloud commands:

```bash
gcloud config set project {{project_id}}
```

Run the setup script by providing the Organization ID:

```bash
. ../../helpers/setup.sh -g -p {{project_id}} -o ORG_ID
```

## Forseti Terraform module configuration
There are a few required settings that need to be updated in the Forseti Terraform configuration <walkthrough-editor-open-file filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars">terraform.tfvars</walkthrough-editor-open-file> file.

### Set project
On line 1, update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars"
  regex="my-project-id">project ID</walkthrough-editor-select-regex>
to match your chosen project (`{{project_id}}`).

### Set organization ID
On line 2, update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars"
  regex="11111111">organization ID</walkthrough-editor-select-regex>
to match your organization ID.

### Set domain
On line 3, update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars"
  regex="mydomain.com">domain</walkthrough-editor-select-regex>
to match your company Cloud Identity domain.

### Set region
On line 4, update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars"
  regex="us-east4">region</walkthrough-editor-select-regex>
you wish to deploy Forseti in.

### Set network (Optional)
If you want to deploy Forseti onto a specific Network, you can configure the following settings. Otherwise you can leave the defaults.

__Note:__ By default Forseti will run on GCE VMs with private IPs.  A Cloud NAT will be deployed providing external access.

On line 6, update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars"
  regex="default">network</walkthrough-editor-select-regex>
you wish to deploy Forseti in.

On line 7, update the <walkthrough-editor-select-line
  filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars"
  startLine=6
  endLine=6
  startCharacterOffset=19
  endCharacterOffset=26>subnetwork</walkthrough-editor-select-line>.

If you are deploying on a Shared VPC, you need to set the <walkthrough-editor-select-line
  filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars"
  startLine=7
  endLine=7
  startCharacterOffset=19
  endCharacterOffset=19>network project</walkthrough-editor-select-line>
on line 8. Otherwise, you can leave this empty.

## Enable Optional Features
Forseti provides many optional settings for users to customize for their environment and security requirements. The features below are recommended, but are not required.

### Configure G Suite
On line 10, set the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars"
  regex="admin@mydomain.com">G Suite super admin email</walkthrough-editor-select-regex>.
Ask your G Suite Admin if you don’t know the super admin email.

This is part of the [G Suite data collection](https://forsetisecurity.org/docs/latest/configure/inventory/gsuite.html). The following functionalities will not work without G Suite integration:

- G Suite Groups and Users in Inventory
- G Suite Groups Scanners
- G Suite Group expansion in Explain

### Configure email notifications
Forseti can be configured to [send email notifications](https://forsetisecurity.org/docs/latest/configure/notifier/index.html#email-notifications) when violations are found.

To enable this, add a <walkthrough-editor-select-line
  filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars"
  startLine=10
  endLine=10
  startCharacterOffset=27
  endCharacterOffset=27>SendGrid API key</walkthrough-editor-select-line>
on line 12 and update the <walkthrough-editor-select-line
  filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars"
  startLine=11
  endLine=11
  startCharacterOffset=27
  endCharacterOffset=27>sender</walkthrough-editor-select-line>
and <walkthrough-editor-select-line
  filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars"
  startLine=12
  endLine=12
  startCharacterOffset=27
  endCharacterOffset=27>recipient</walkthrough-editor-select-line>
settings.

## Deploy Forseti
Now that you have updated your configuration settings, Forseti is ready to be deployed.

### Initialize Terraform
Initialize Terraform to download the Forseti module:

```bash
terraform init
```

### Apply Terraform
Deploy Forseti by running the Terraform apply command:

```bash
terraform apply
```

This can take a few minutes to provision all the necessary resources.

### Get Help
If you encounter any errors, check the configuration and permissions; then run `terraform apply` again. If you need any help, please [Contact Us](https://forsetisecurity.org/docs/latest/use/get-help.html).

## Save Terraform State
Congratulations, you have now deployed Forseti!

You will want to save the Terraform configuration so it can be used to upgrade Forseti in the future. This can be saved to a Google Cloud Storage (GCS) bucket.

### Create Terraform state bucket
Create a Google Cloud Storage bucket to [store your Terraform state](https://www.terraform.io/docs/state/).

```bash
gsutil mb -p {{project_id}} gs://{{project_id}}-tfstate
```

### Upload state configuration
Open <walkthrough-editor-open-file filePath="terraform-google-forseti/examples/install_simple/backend.tf">backend.tf</walkthrough-editor-open-file> and uncomment the contents.

Update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/install_simple/backend.tf"
  regex="my-project">project ID</walkthrough-editor-select-regex>
in the bucket variable to match your project ID (`{{project_id}}`).

Run the Terraform init command to upload the state to the GCS bucket:

```bash
terraform init
```

At the prompt, type `yes`.

## Save Terraform Configuration
As a best practice, you should save the Terraform configuration to source control. This can be done using Cloud Source Repositories. If you choose to perform this step, the Cloud Source Repositories API will need to be enabled.

### Create a repo
```bash
gcloud source repos create terraform-forseti
```

### Initialize git
```bash
git init
```

### Configure the Git user email and name
```
git config --global user.email "{YOUR_EMAIL_ADDRESS}"
```

```
git config --global user.name "{YOUR_NAME}"
```

### Add and commit your files

```bash
git add -A
```

```bash
git commit -m "Initial commit"
```

### Push your configuration
```bash
git remote add origin https://source.developers.google.com/p/{{project_id}}/r/terraform-forseti
```

```bash
git push origin master
```

## Cleanup Service Account
The last step is to cleanup the Service Account that was created for this walkthrough. This will deprovision and delete the service account, and then delete the credentials file. You will need to supply the Organization ID.

Run the cleanup script:

```bash
../../helpers/cleanup.sh -p {{project_id}} -o ORG_ID
```

## Conclusion
You have completed deploying Forseti and saving your configuration!

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

### Periodic Scan
Forseti is setup to run a periodic scan every 2 hours. This scan performs the various steps:
- Collect an inventory of the GCP resources and G Suite Groups
- Scan the inventory with the default set of [rules](https://github.com/forseti-security/terraform-google-forseti/tree/master/modules/rules/templates/rules)
- Save the violation findings to a GCS bucket and send email notifications (if this was enabled)

### Configure Forseti
There are [many options available](https://github.com/forseti-security/terraform-google-forseti#inputs) to configure Forseti to meet your security needs. This Walkthrough only exposes the required inputs along with a few commonly used options. You can start adding these additional inputs into this example's
    <walkthrough-editor-open-file
    filePath="terraform-google-forseti/examples/install_simple/main.tf">
      main.tf
    </walkthrough-editor-open-file> file. To apply these new changes, you can simply re-run the Terraform apply command:

```bash
terraform apply
```

### Additional Resources
- [Enable G Suite data collection](https://forsetisecurity.org/docs/latest/configure/inventory/gsuite.html)
- [Learn about Config Validator to enhance the Forseti scanning](https://github.com/forseti-security/policy-library/blob/master/docs/user_guide.md)
- [Learn to use the Forseti CLI](https://forsetisecurity.org/docs/latest/use/cli/index.html)

### Contact the Forseti Team
If you have any questions or issues, please [contact us](https://forsetisecurity.org/docs/latest/use/get-help.html).
