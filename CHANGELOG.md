# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Extending the adopted spec, each change should have a link to its corresponding pull request appended.

## [Unreleased] - TBD

### Added
- Configure firewall rules in support of private Client and Server [#391]
- Add Service Account Key to CAI assets in Server config [#393]
- Add policy_library_repository_branch to GCE module [#394]
- Add sql instance user and password [#399]
- Conditional firewall rules [#400]
- Conditional service networking [#401]
- Create stale.yml for Stale Bot [#402]
- Enable uniform bucket-level access [#405]
- Add Cloud SQL DB User and Password as outputs [#407]
- Added install-simple tests [#408]
- Use network project for private IP address in CloudSQL submodule [#412]
- Allow user to configure Scanner Rules path to GCS or local dir [#414]
- Update version in README [#426]
- Removed simple_example [#444]
- Create CONTRIBUTORS file [#454]

### Fixed
- Fix space in Location Rules template [#392]
- Fix string interpolation warnings [#395]
- Remove the % character from the Cloud SQL password [#417]
- Base64 encode CloudSQL username and password for the helm chart secrets [#419]
- Style fixes [#430]
- Add spanner.googleapis.com [#435]
- Update the Bigquery api to the new name [#437]
- Fix validate error [#449]
- Increased open files limit to fix OSError: [Errno 24] Too many open files [#450]
- Sync policy library with gsutil rsync [#463]

## [v5.1.1] - 2020-01-14

### Fixed
- Update the Bigquery api to the new name


## [5.1.0] - 2019-11-15

### Added
- Support for Forseti v2.24.0 [#386]
- Parameterized Kubernetes version [#385]
- GCS bucket location to tutorials and examples [#382]
- Improved existing resource import in v5.0.0 [#354]
- Starting Forseti service automatically at boot (#286) [#275]
- Ignoring the size of the CloudSQL disk on re-apply [#371]
- Root outputs.tf to include forseti-cai-storage-bucket [#374]
- The On GKE end-to-end example to have the same machine type and disk type as the defaults for GCE. Moved these variables out of main.tf into the variables.tf file. [#369]
- setup.sh to reuse existing deployer service account [#357]
- GCS as a policy-library store for on-GKE [#356]
- Support for the case where the user is syncing from GCS and not SSH key is present [#362]
- CIS Annotations CIS 2.1 [#348] [#349] [#350] [#351]
- GKE module support for custom Cloud SQL database names [#314]

### Fixed
- Changing the branch names to branches without special characters [#383]
- Test fixtures to use master branch of Forseti [#378]
- Correct server bucket variable being passed to helm_release resource. [#320]

### Removed
- Issue templates [#365]

## [5.0.0] - 2019-10-17
Version 5.0.0 is a backwards-incompatible release. Please see the [upgrade instructions](./docs/upgrading_to_v5.0.md) for details.

### Added
- Support for Forseti v2.23.0 [#329]
- Updated README and Cloud Shell Tutorial [#330]
- Added additional submodules for Forseti infrastructure components [#284]
- Update Cloud Shell tutorial [#309]
- Add variable to enable mailjet_rest library [#302]
- Updating helper scripts to include GKE related roles [#306]
- Setting the GKE version to a specific version [#307]
- Fix serviceusage test [#308]
- Adding cscc vars to on_gke examples [#304]
- Optionally Enable Cloud Profiler [#297]
- Add Service Usage API [#276]
- Cleaning up unused input variables. [#300]
- Add ability to set net_write_timeout for CloudSQL [#299]
- Update server config template to reflect CSCC notifier changes [#292]

## [v4.3.0] - 2019-10-03

### Added

- Upgraded default forseti server vm and cloud sql instance size [#268]
- Add READMEs to submodules [#270]
- Set the crontab minute to be random [#280]
- Fix to helper script [#282]
- Only clone head of desired Forseti branch [#283]

## [v4.2.1] - 2019-09-23

### Added

- Support for Forseti v2.22.0 [#266]
- Verbose logging for the Forseti Server startup script [#257]
- CloudSQL instance created in the same zone as GCE instances [#253]
- Support for importing existing deployments created by the deprecated Python Installer. [#197]
  - A variable to override the random resource name suffix
  - A variable to toggle management of rules
  - An import helper script

## [v4.1.0] - 2019-09-06

### Added

- Support for Forseti v2.20.0 [#246]
- Added support for Policy Library sync. [#239]

## [v4.0.1] - 2019-08-23

### Added

- Support for Forseti v2.19.1 [#233]
- Added boot disk type and boot disk size variables, with increased default disk size. [#232]

### Fixed

- Fixed race condition in server VM roles. [#231]

## [v4.0.0] - 2019-08-07
Version 4.0.0 is a backwards-incompatible release. Please see the [upgrade instructions](./docs/upgrading_to_v4.0.md) for details.

## Added

- Support for Forseti v2.19.0. [#225]
- Add on_gke submodule [#182]
- Add `excluded_resources` variable to forseti_conf_server.yaml. [#213]

### Changed

- Remove roles/bigquery.dataViewer role from server. [#210]
- Flip `inventory_email_summary_enabled` default to `false` and require
  `sendgrid_api_key` to be non-empty when `true`. [#211]

## [v3.0.0] - 2019-07-19

### Changed

- Supported version of Terraform is 0.12. [#201]

## [v2.3.0] - 2019-07-11

### Added

- Support for Forseti v2.18.0. [#200]
- Support for Forseti Real-Time Enforcer VM private IP address. [#180]

### Changed

- Updated ke_rules.yaml file to scan for new vulnerabilities. [#200]

## [v2.2.0] - 2019-06-20

### Added

- Support for Forseti v2.17.0 [#184]
- Add Kubernetes resources to CAI asset inventory

### Changed

- Do not add email configuration if `sendgrid_api_key` is unset [#174]

## [v2.1.0] - 2019-05-30

### Added

- Support for Forseti v2.16.0. [#170]

## [v2.0.0] - 2019-05-16

### Changed

- Removed public IP address outputs. [#163]

### Added

- Enable CSCC API when violations are enabled. [#158]
- Add 50052 port in Firewall rule for Config Validator. [#155]
- Check for both empty values org_id and folder_id. [#152]

### Changed

- Updated server firewall rule to restrict by service accounts. [#157]

## [v1.6.0] - 2019-05-14

### Added

- Support for Forseti v2.15.0. [#145]

## [v1.5.1] - 2019-05-09

### Added

- The required roles are documented in the README. [#134]

### Fixed

- The `forseti-server-vm-public-ip` output and the
  `forseti-client-vm-public-ip` output are restored. [#146]

## [v1.5.0] - 2019-05-07

### Added

- `var.client_private` and `var.server_private` toggle the existence of
  public IP addresses for the client and server VMs. [#76]

### Fixed

- Add `groupssettings.googleapis.com` API. [#137]

## [v1.4.2] - 2019-04-23

### Fixed

- `var.config_validator_violations_should_notify` would not disable
  notifications when set to `false`. [#126]
- Add CSCC findings IAM role. [#131]
- `var.composite_root_resources` and `var.services` default to empty
  lists. [#132]

## [v1.4.1] - 2019-04-05

### Changed

- Removed Forseti resources from real time enforcer example. [#119]
- Update Forseti to v2.14.1. [#123]

### Fixed

- Real time enforcer containers will restart when encountering errors. [#120]

## [v1.4.0] - 2019-04-04

### Added

- Checks for errors in the client and server startup scripts. [#79]
- Database migration script is invoked in forseti server startup script. [#77]
- `helpers/setup.sh` activates required services in project. [#66]
- Added real_time_enforcer submodule. [#75] [#90]
- Added real_time_enforcer_roles submodule. [#80]
- Added real_time_enforcer_organization_sink. [#86]
- Added real time enforcer roles to `helpers/setup.sh` and `helpers/cleanup.sh` [#91]
- Added groups_settings scanner. [#100]
- Added licensing information to real time enforcer policies. [#107] [#111]
- Added config validator. [#116]

### Changed

- `helpers/setup.sh` and `helpers/cleanup.sh` now use flags for setting arguments. [#66]
- Optionally send real time enforcer logs to stackdriver. [#85]
- Updated real time enforcer policy from upstream. [#89]
- Move real time enforcer pubsub sink definition into sink modules. [#88]
- Update ke_scanner_rules.yaml [#102]
- Update cscc violations to use GA API. [#103]
- Update real time enforcer versioning policy. [#112]
- Update forseti_version to v2.14.0
- Refreshed Terraform variables and outputs documentation. [#115]

### Fixed

- Fix misnamed variable in `helpers/setup.sh`. [#108]
- Fix getopts option string in `helpers/setup.sh` and `helpers/cleanup.sh`. [#114]

## [v1.3.0] - 2019-03-14
1.3.0 is a backwards compatible feature release. This module release supports Forseti v2.13.0.

### ADDED
- Added server service account to the `roles/bigquery.metadataViewer` role. [#71]

### CHANGED
- Changed `forseti_version` default to v2.13.0. [#73]

## [v1.2.0] - 2019-02-28
1.2.0 is a backwards compatible feature and bugfix release. This module release supports Forseti v2.12.0.

### ADDED
- Added new `shared-vpc` example, fix firewall rules for client SSH access. [#32]
- Firewall rule source ranges are now user-controllable. [#32], [#67]

### CHANGED
- Update forseti_version to v2.12.0. [#61]

### FIXED
- `terraform destroy` now removes non-empty CAI export buckets [#56]
- Add missing `kms_rules.yaml` rules file. [#64]

## [v1.1.1] - 2019-02-15
1.1.1 is a backward compatible feature release. This module release supports Forseti v2.11.1.

### CHANGED
- Update forseti_version to v2.11.1. [#59]

## [v1.1.0] - 2019-02-15
1.1.0 is a backward compatible feature release. This module release supports Forseti v2.11.0.

### ADDED
- Add "roles/orgpolicy.policyViewer" to server service account roles. [#44]
- Add variables to configure forseti_conf_server.yaml. [#50]
- Add host integration tests for Forseti server and client. [#48]
- Install forseti pip requirements on client instance [#55]

### CHANGED
- Never prompt for user input from Apt in Forseti startup scripts. [#45]
- Rebuild Forseti server when forseti_conf_server.yaml changes. [#46]
- Fix cron default frequency to be every 2 hours. [#47]
- Update forseti_version to v2.11.0. [#58]

## [v1.0.0] - 2019-01-29
1.0.0 is a backwards incompatible release and is a full rewrite of the module.
### CHANGED
- Terraform now installs and manages all Forseti resources instead of using the Deployment Manager. [#33]

## [v0.1.0] - 2018-09-13
### ADDED
- This is the initial release of the Forseti module.

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v5.1.1...HEAD
[v0.1.0]: https://github.com/terraform-google-modules/terraform-google-forseti/releases/tag/v0.1.0
[v1.0.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v0.1.0...v1.0.0
[v1.1.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v1.0.0...v1.1.0
[v1.1.1]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v1.1.0...v1.1.1
[v1.2.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v1.1.1...v1.2.0
[v1.3.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v1.2.0...v1.3.0
[v1.4.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v1.3.0...v1.4.0
[v1.4.1]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v1.4.0...v1.4.1
[v1.4.2]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v1.4.1...v1.4.2
[v1.5.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v1.4.2...v1.5.0
[v1.5.1]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v1.5.0...v1.5.1
[v1.6.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v1.5.1...v1.6.0
[v2.0.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v1.6.0...v2.0.0
[v2.1.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v2.0.0...v2.1.0
[v2.2.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v2.1.0...v2.2.0
[v2.3.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v2.2.0...v2.3.0
[v3.0.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v2.3.0...v3.0.0
[v4.0.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v3.0.0...v4.0.0
[v4.0.1]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v4.0.0...v4.0.1
[v4.1.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v4.0.1...v4.1.0
[v4.2.1]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v4.1.0...v4.2.1
[v4.3.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v4.2.1...v4.3.0
[v5.0.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v4.3.0...v5.0.0
[v5.1.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v5.0.0...v5.1.0
[v5.1.1]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v5.1.0...v5.1.1

[#463]: https://github.com/forseti-security/terraform-google-forseti/pull/463
[#454]: https://github.com/forseti-security/terraform-google-forseti/pull/454
[#450]: https://github.com/forseti-security/terraform-google-forseti/pull/450
[#449]: https://github.com/forseti-security/terraform-google-forseti/pull/449
[#444]: https://github.com/forseti-security/terraform-google-forseti/pull/444
[#437]: https://github.com/forseti-security/terraform-google-forseti/pull/437
[#435]: https://github.com/forseti-security/terraform-google-forseti/pull/435
[#430]: https://github.com/forseti-security/terraform-google-forseti/pull/430
[#426]: https://github.com/forseti-security/terraform-google-forseti/pull/426
[#419]: https://github.com/forseti-security/terraform-google-forseti/pull/419
[#417]: https://github.com/forseti-security/terraform-google-forseti/pull/417
[#414]: https://github.com/forseti-security/terraform-google-forseti/pull/414
[#412]: https://github.com/forseti-security/terraform-google-forseti/pull/412
[#408]: https://github.com/forseti-security/terraform-google-forseti/pull/408
[#407]: https://github.com/forseti-security/terraform-google-forseti/pull/407
[#405]: https://github.com/forseti-security/terraform-google-forseti/pull/405
[#402]: https://github.com/forseti-security/terraform-google-forseti/pull/402
[#401]: https://github.com/forseti-security/terraform-google-forseti/pull/401
[#400]: https://github.com/forseti-security/terraform-google-forseti/pull/400
[#399]: https://github.com/forseti-security/terraform-google-forseti/pull/399
[#395]: https://github.com/forseti-security/terraform-google-forseti/pull/395
[#394]: https://github.com/forseti-security/terraform-google-forseti/pull/394
[#393]: https://github.com/forseti-security/terraform-google-forseti/pull/393
[#392]: https://github.com/forseti-security/terraform-google-forseti/pull/392
[#391]: https://github.com/forseti-security/terraform-google-forseti/pull/391
[#386]: https://github.com/forseti-security/terraform-google-forseti/pull/386
[#385]: https://github.com/forseti-security/terraform-google-forseti/pull/385
[#383]: https://github.com/forseti-security/terraform-google-forseti/pull/383
[#382]: https://github.com/forseti-security/terraform-google-forseti/pull/382
[#378]: https://github.com/forseti-security/terraform-google-forseti/pull/378
[#371]: https://github.com/forseti-security/terraform-google-forseti/pull/371
[#374]: https://github.com/forseti-security/terraform-google-forseti/pull/374
[#369]: https://github.com/forseti-security/terraform-google-forseti/pull/369
[#365]: https://github.com/forseti-security/terraform-google-forseti/pull/365
[#362]: https://github.com/forseti-security/terraform-google-forseti/pull/362
[#357]: https://github.com/forseti-security/terraform-google-forseti/pull/357
[#356]: https://github.com/forseti-security/terraform-google-forseti/pull/356
[#354]: https://github.com/forseti-security/terraform-google-forseti/pull/354
[#351]: https://github.com/forseti-security/terraform-google-forseti/pull/351
[#350]: https://github.com/forseti-security/terraform-google-forseti/pull/350
[#349]: https://github.com/forseti-security/terraform-google-forseti/pull/349
[#348]: https://github.com/forseti-security/terraform-google-forseti/pull/348
[#330]: https://github.com/forseti-security/terraform-google-forseti/pull/330
[#329]: https://github.com/forseti-security/terraform-google-forseti/pull/329
[#320]: https://github.com/forseti-security/terraform-google-forseti/pull/320
[#314]: https://github.com/forseti-security/terraform-google-forseti/pull/314
[#309]: https://github.com/forseti-security/terraform-google-forseti/pull/309
[#308]: https://github.com/forseti-security/terraform-google-forseti/pull/308
[#307]: https://github.com/forseti-security/terraform-google-forseti/pull/307
[#306]: https://github.com/forseti-security/terraform-google-forseti/pull/306
[#304]: https://github.com/forseti-security/terraform-google-forseti/pull/304
[#302]: https://github.com/forseti-security/terraform-google-forseti/pull/302
[#300]: https://github.com/forseti-security/terraform-google-forseti/pull/300
[#299]: https://github.com/forseti-security/terraform-google-forseti/pull/299
[#297]: https://github.com/forseti-security/terraform-google-forseti/pull/297
[#292]: https://github.com/forseti-security/terraform-google-forseti/pull/292
[#290]: https://github.com/forseti-security/terraform-google-forseti/pull/290
[#284]: https://github.com/forseti-security/terraform-google-forseti/pull/284
[#283]: https://github.com/forseti-security/terraform-google-forseti/pull/283
[#282]: https://github.com/forseti-security/terraform-google-forseti/pull/282
[#280]: https://github.com/forseti-security/terraform-google-forseti/pull/280
[#276]: https://github.com/forseti-security/terraform-google-forseti/pull/276
[#275]: https://github.com/forseti-security/terraform-google-forseti/pull/275
[#270]: https://github.com/forseti-security/terraform-google-forseti/pull/270
[#268]: https://github.com/forseti-security/terraform-google-forseti/pull/268
[#266]: https://github.com/forseti-security/terraform-google-forseti/pull/266
[#257]: https://github.com/forseti-security/terraform-google-forseti/pull/257
[#253]: https://github.com/forseti-security/terraform-google-forseti/pull/253
[#246]: https://github.com/forseti-security/terraform-google-forseti/pull/246
[#239]: https://github.com/forseti-security/terraform-google-forseti/pull/239
[#233]: https://github.com/forseti-security/terraform-google-forseti/pull/233
[#232]: https://github.com/forseti-security/terraform-google-forseti/pull/232
[#231]: https://github.com/forseti-security/terraform-google-forseti/pull/231
[#225]: https://github.com/forseti-security/terraform-google-forseti/pull/225
[#213]: https://github.com/forseti-security/terraform-google-forseti/pull/213
[#197]: https://github.com/forseti-security/terraform-google-forseti/pull/197
[#182]: https://github.com/forseti-security/terraform-google-forseti/pull/182
[#211]: https://github.com/forseti-security/terraform-google-forseti/pull/211
[#223]: https://github.com/forseti-security/terraform-google-forseti/pull/223
[#210]: https://github.com/forseti-security/terraform-google-forseti/pull/210
[#201]: https://github.com/forseti-security/terraform-google-forseti/pull/201
[#180]: https://github.com/forseti-security/terraform-google-forseti/pull/180
[#174]: https://github.com/forseti-security/terraform-google-forseti/pull/174
[#173]: https://github.com/forseti-security/terraform-google-forseti/pull/173
[#170]: https://github.com/forseti-security/terraform-google-forseti/pull/170
[#163]: https://github.com/forseti-security/terraform-google-forseti/pull/163
[#157]: https://github.com/forseti-security/terraform-google-forseti/pull/157
[#158]: https://github.com/forseti-security/terraform-google-forseti/pull/158
[#155]: https://github.com/forseti-security/terraform-google-forseti/pull/155
[#152]: https://github.com/forseti-security/terraform-google-forseti/pull/152
[#146]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/146
[#145]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/145
[#137]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/137
[#134]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/134
[#132]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/132
[#131]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/131
[#126]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/126
[#123]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/123
[#120]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/120
[#119]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/119
[#116]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/116
[#115]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/115
[#114]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/114
[#112]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/112
[#111]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/111
[#108]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/108
[#107]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/107
[#103]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/103
[#102]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/102
[#100]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/100
[#88]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/88
[#86]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/86
[#85]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/85
[#80]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/80
[#75]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/75
[#66]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/66
[#79]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/79
[#76]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/76
[#77]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/77
[#73]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/73
[#71]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/71
[#67]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/67
[#61]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/61
[#64]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/64
[#32]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/32
[#56]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/56
[#33]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/33
[#44]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/44
[#45]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/45
[#46]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/46
[#47]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/47
[#48]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/48
[#50]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/50
[#55]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/55
[#58]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/58
[#59]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/59
