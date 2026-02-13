# Postfix Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v3.10.7-4] - 2026-02-13
### Security
- [#65] Upgrade base-image to 3.23.3-3
  - [#65] Update doguctl to v0.15.0 to fix [CVE-2025-61732](https://www.tenable.com/cve/CVE-2025-61732) and [CVE-2025-68121](https://nvd.nist.gov/vuln/detail/cve-2025-68121).

## [v3.10.7-3] - 2026-02-05
### Security
- [#61] CVE fixed [cve-2026-24515](https://avd.aquasec.com/nvd/2026/cve-2026-24515/)
### Changed
- [#61] Update Base Image to 3.23.3-2
- [#61] Update Makefiles to 10.5.0

## [v3.10.7-2] - 2026-01-29
### Security
- [#59] CVE fixed: [cve-2025-15467](https://avd.aquasec.com/nvd/2025/cve-2025-15467/)

## [v3.10.7-1] - 2025-12-12
### Changed
- [#57] Update Postfix to 3.10.7
- [#57] Update Base Image to 3.23.0-1

## [v3.10.5-1] - 2025-11-13
### Changed
- [#55] Update Postfix to 3.10.5

## [v3.10.4-1] - 2025-09-03
### Changed
- [#52] Update Postfix to 3.10.4

## [v3.10.3-2] - 2025-08-06
### Changed
- [#48] Apply network restrictions only in Classic CES environments

## [v3.10.3-1] - 2025-08-05
### Changed
- [#50] Update Postfix to 3.10.3
- [#50] Update base-image to 3.22.0-4
- [#50] Update makefiles to 10.2.0

## [v3.10.2-2] - 2025-06-11
### Changed
- [#46] Update base-image to v3.22.0-2

## [v3.10.2-1] - 2025-06-05
### Changed
- [#44] Update Postfix to v3.10.2
- [#44] Update makefiles to 10.1.0
- [#44] Updated Base Image to v3.22.0-1

## [v3.9.3-4] - 2025-04-25
### Changed
- [#40] Set sensible resource requests and limits

## [v3.9.3-3] - 2025-04-25
### Fixed
- [#42] create aliases file if not exists to prevent error

## [v3.9.3-2] - 2025-03-13
### Changed
- Update Postfix to v3.9.3
- Updated Base Image to v3.21.0-1
- Upgrade dogu-build-lib to v3.1.0 
- Upgrade ces-build-lib to v4.1.0
- added pre-release steps in pipeline
### Security
- Fixed [CVE-2024-45337](https://avd.aquasec.com/nvd/2024/cve-2024-45337/)

## [v3.9.0-4] - 2025-02-12
### Changed
- [#32] Update Makefiles to 9.5.0
- [#36] exit with error if `logging/root` is invalid
  - this change is necessary for compatibility with CES Multinode

## [v3.9.0-3] - 2024-09-18
### Changed
- Relicense to AGPL-3.0-only

## [v3.9.0-2] - 2024-08-07
### Changed
- [#28] Upgrade base-image to v3.20.2-1

### Security
- close CVE-2024-41110

## [v3.9.0-1] - 2024-06-27
### Changed
- [#26] Upgraded alpine base image to 3.20.1-2

## [v3.8.4-1] - 2023-12-27
### Security
- [#24] Prevent [SMTP smuggling](https://www.postfix.org/smtp-smuggling.html) due to [CVE-2023-51764](https://nvd.nist.gov/vuln/detail/CVE-2023-51764)
### Added
- [#24] Configuration to prevent the aforementioned SMTP smuggling.  
  **BREAKING CHANGE:** This might break exceedingly rare clients that mis-implement SMTP.
  Configuration options to allow those clients specifically
  [can be found here](docs/operations/Configure_Dogu_en.md#client-exclusions-for-bare-newlines).
### Changed
- Upgraded postfix from `3.6.4` to `3.8.4`
- Upgraded alpine base image from `3.17.3-2` to `3.18.3-1`

## [v3.6.4-6] - 2023-12-04
### Fixed
- [#22] Fixed a bug where multiple masks for a destination ip would result in multi line input for cidr generation.

## [v3.6.4-5] - 2023-06-27
### Added
- [#20] Configuration options for resource requirements
- [#20] Defaults for CPU and memory requests

## [v3.6.4-4] - 2023-05-08
### Fixed
- Fix a bug where the routing table returns multiple masks for one ip and the startup script executes
  the `mask2cidr.sh` script with multiple parameters (#15).

### Changed
- Update postfix to 3.7.4
- Update makefiles to 7.4.0
- Update base image to 3.17.3-2

### Security
- Fixed all currently known CVEs, 11 of which were critical (#17).

## [v3.6.4-3] - 2022-05-24
### Added
- support for SASL authentication (#13)

## [v3.6.4-2] - 2022-04-06
### Change
- Upgrade zlib package to fix CVE-2018-25032; (#11)

## [v3.6.4-1] - 2022-02-10
### Fixed
- XML-Parser Expat (CVE-2022-23852) security issue

## [v3.5.9-2] - 2021-05-06
### Added
- Upgrade test of the Dogu in Jenkins pipeline (#7)
- Possibility to set log level for the dogu (#7)
- Possibility to set memory limit for the dogu (#7)
 
## [v3.5.9-1] - 2021-03-22
### Added
- release workflow
- basic docker healthcheck

### Changed
- upgrade base image to 3.12.4-1 which leads to an update of the postfix version to 3.5.9
