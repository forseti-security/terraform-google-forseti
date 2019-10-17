# Deploy Forseti

## Introduction

<walkthrough-tutorial-duration duration="10"></walkthrough-tutorial-duration>

This tutorial explains how to set up [Forseti](https://forsetisecurity.org/about/) in a GCP project using Cloud Shell.

## Choose Project

<walkthrough-project-billing-setup billing="true"></walkthrough-project-billing-setup>

First, select a project to install Forseti in.

This can either be a dedicated Forseti project or an existing DevSecOps project.

 You must be logged in with a Google Account that has permission to access the Project. If you need to login as a different user, use gcloud to switch users:

 ```bash
 gcloud auth login
```

## Activate APIs

You will need to activate a few APIs on this project to allow the Terraform module to install Forseti.

__Note:__ If this step is blocked by an error "Unable to enable required APIs", navigate to [APIs and Services](https://pantheon.corp.google.com/apis/dashboard?project={{project_id}}) on the GCP console and manually enable the specified APIs.

Alternatively you can use the following gcloud commands:

```bash
gcloud config set project {{project_id}}
```

```bash
gcloud services enable cloudresourcemanager.googleapis.com compute.googleapis.com serviceusage.googleapis.com
```

<walkthrough-enable-apis apis=
  "cloudresourcemanager.googleapis.com,
  compute.googleapis.com,
  serviceusage.googleapis.com"></walkthrough-enable-apis>

## Configure Forseti
There are a few required settings that you will need to update in the Forseti Terraform configuration <walkthrough-editor-open-file filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars">terraform.tfvars</walkthrough-editor-open-file> file.

__Note:__ Clicking the links below will open the Terraform configuration files and select the text that needs to be updated.

### Set project
On line 1, update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars"
  regex="my-project-id">project ID</walkthrough-editor-select-regex>
to match your chosen project (`{{project_id}}`).

### Set organization ID
On line 2, update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars"
  regex="11111111">organization ID</walkthrough-editor-select-regex>
to match your organization ID, which can be found in the URL bar.

### Set domain
On line 3, update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars"
  regex="mydomain.com">domain</walkthrough-editor-select-regex>
to match your company Cloud Identity domain, which can be found in the URL bar.

### Set region
On line 4, update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars"
  regex="us-east4">region</walkthrough-editor-select-regex>
you wish to deploy Forseti in.

### Set network (Optional)
If you want to deploy Forseti onto a specific Network, you can configure the following settings. Otherwise, you can leave the defaults.

__Note:__ By default Forseti will run on VMs with external IPs.**

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
There are additional settings which you can configure in the settings file to enable advanced Forseti functionality.

If you don't need these features, you can skip these steps.

### Configure G Suite
On line 10, set the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/install_simple/terraform.tfvars"
  regex="admin@mydomain.com">G Suite super admin email</walkthrough-editor-select-regex>.
Ask your G Suite Admin if you don’t know the super admin email.

This is part of the [G Suite data collection](https://forsetisecurity.org/docs/latest/configure/inventory/gsuite.html). The following functionalities will not work without G Suite integration:

- G Suite Groups and Users in Inventory
- G Suite Groups Scanner and Groups Settings Scanner
- Group expansion in Explain

### Configure email notifications
Forseti can be configured to [send email notifications](https://forsetisecurity.org/docs/latest/configure/notifier/index.html#email-notifications).

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
Now that you have updated your configuration settings, you are ready to install Forseti.

This will be done using Terraform, which comes pre-installed with this Cloud Shell Walkthrough.

### Initialize Terraform
To download the Forseti module, you will need to initialize Terraform:
```bash
terraform init
```

### Apply Terraform
You are now ready to deploy Forseti with Terraform by running the apply command:

```bash
terraform apply
```

This can take a few minutes as all the necessary resources are provisioned.

### Get Help
If you encounter errors during installation, you can check your configuration and permissions, then run `terraform apply` again. If you need any help, please [Contact Us](https://forsetisecurity.org/docs/latest/use/get-help.html).

## Save Terraform State
Congratulations, you have now installed Forseti!

As a final step, you will want to save your configuration so it can be used to upgrade Forseti in the future. This can be saved to a Google Cloud Storage (GCS) bucket.

### Create Terraform state bucket
Create a Google Cloud Storage bucket to [store your Terraform state](https://www.terraform.io/docs/state/).

```bash
gsutil mb gs://{{project_id}}-tfstate
```

### Update state configuration
Open <walkthrough-editor-open-file filePath="terraform-google-forseti/examples/install_simple/backend.tf">backend.tf</walkthrough-editor-open-file> and uncomment the contents.

On line 3, update the <walkthrough-editor-select-regex
  filePath="terraform-google-forseti/examples/install_simple/backend.tf"
  regex="my-project">project ID</walkthrough-editor-select-regex>
project ID to match your project ID (`{{project_id}}`).

Run the Terraform init command to upload the state to the GCS bucket:

```bash
terraform init
```

At the prompt, type `yes`.

## Save configuration to git
As a best practice, you should save your Terraform configuration to source control. This can be done using Cloud Source Repositories.

__Note:__ The Terraform state can contain sensitive information that should not be committed to source control. These state files will be ignored by the <walkthrough-editor-open-file
filePath="terraform-google-forseti/examples/install_simple/.gitignore">.gitignore</walkthrough-editor-open-file> file.

### Create a repo
```bash
gcloud source repos create terraform-forseti
```

### Initialize git
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

You have completed installing Forseti and saving your configuration!

### Periodic Scan
Forseti is setup to run a periodic scan every 2 hours. This scan performs the various steps:
- Collect an inventory of the GCP resources and G Suite Groups
- Scan the inventory with the default set of [rules](https://github.com/forseti-security/terraform-google-forseti/tree/master/modules/rules/templates/rules)
- Save the violation findings to a GCS bucket

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
