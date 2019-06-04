# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Extending the adopted spec, each change should have a link to its corresponding pull request appended.

## [Unreleased]

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

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v2.0.0...HEAD
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
