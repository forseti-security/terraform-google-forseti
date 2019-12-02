# Upgrading to v5.0

The v5.0 release of the *forseti* module is a backwards incompatible
release.

## Migration Instructions

Version 5.0.0 of this module introduces a breaking change.  The various components of Forseti are in more granular submodules.  If trying to apply a plan against a state created by a 4.x version of this module, will result in the destruction of existing Forseti resources.

Following these instructions will import existing Forseti infrastructure resources to a state compatible with version 5.x of this module.

### Migrating from the Python Installer
A Cloud Shell walkthrough is provided to assist with migrating Forseti previously deployed with the Python installer.  Completing this guide will also result in a Forseti deployment upgraded to the most recent version.

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/open?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fforseti-security%2Fterraform-google-forseti.git&cloudshell_git_branch=module-release500&cloudshell_working_dir=examples/migrate_forseti&cloudshell_image=gcr.io%2Fgraphite-cloud-shell-images%2Fterraform%3Alatest&cloudshell_tutorial=.%2Ftutorial.md)

### Upgrading Forseti Deployed/Upgraded with Terraform
A Cloud Shell walkthrough is provided to assist with upgrading Forseti previously deployed with Terraform.  Completing this guide will also result in a Forseti deployment upgraded to the most recent version.

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/open?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fforseti-security%2Fterraform-google-forseti.git&cloudshell_git_branch=module-release-500&cloudshell_working_dir=examples/upgrade_forseti_with_v5.0&cloudshell_image=gcr.io%2Fgraphite-cloud-shell-images%2Fterraform%3Alatest&cloudshell_tutorial=.%2Ftutorial.md)
