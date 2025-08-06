# Release Notes

Below you will find the release notes for the Postfix-Dogu.

Technical details on a release can be found in the corresponding [Changelog](https://docs.cloudogu.com/en/docs/dogus/postfix/CHANGELOG/).

## [Unreleased]

## [v3.10.3-2] - 2025-08-06
### Changed
- [#48] Apply network restrictions only in Classic CES environments

## [v3.10.3-1] - 2025-08-05
### Changed
- [#50] Update Postfix to 3.10.3
### Security
- Patched [CVE-2025-6965](https://avd.aquasec.com/nvd/2025/cve-2025-6965/)

## [v3.10.2-2] - 2025-06-11
### Changed
- We have only made technical changes. You can find more details in the changelogs.

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

## [v3.9.0-3]
- Relicense own code to AGPL-3.0-only
