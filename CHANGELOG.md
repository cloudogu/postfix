# Postfix Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
