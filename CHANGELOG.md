# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Extending the adopted spec, each change should have a link to its corresponding pull request appended.

## [Unreleased]

### Added

- Checks for errors in the client and server startup scripts. [#79]

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

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v1.3.0...HEAD
[v1.0.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v0.1.0...v1.0.0
[v1.1.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v1.0.0...v1.1.0
[v1.1.1]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v1.1.0...v1.1.1
[v1.2.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v1.1.1...v1.2.0
[v1.3.0]: https://github.com/terraform-google-modules/terraform-google-forseti/compare/v1.2.0...v1.3.0

[#79]: https://github.com/terraform-google-modules/terraform-google-forseti/pull/79
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
