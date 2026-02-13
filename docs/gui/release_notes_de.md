# Release Notes

Im Folgenden finden Sie die Release Notes für das Postfix-Dogu.

Technische Details zu einem Release finden Sie im zugehörigen [Changelog](https://docs.cloudogu.com/de/docs/dogus/postfix/CHANGELOG/).

## [Unreleased]
### Security
- [#65] Sicherheitslücke geschlossen [CVE-2025-61732](https://avd.aquasec.com/nvd/2026/CVE-2025-61732) und [CVE-2025-68121](https://avd.aquasec.com/nvd/2026/CVE-2025-68121).

## [v3.10.7-3] - 2026-02-05
### Security
- [#61] Sicherheitslücke geschlossen [cve-2026-24515](https://avd.aquasec.com/nvd/2026/cve-2026-24515/)

## [v3.10.7-2] - 2026-01-29
### Security
- [#59] Sicherheitslücke geschlossen [cve-2025-15467](https://avd.aquasec.com/nvd/2025/cve-2025-15467/)

## [v3.10.7-1] - 2025-12-12
### Changed
- [#57] Update Postfix auf 3.10.7

## [v3.10.5-1] - 2025-11-13
### Changed
- [#55] Update Postfix auf 3.10.5

## [v3.10.4-1] - 2025-09-03
### Changed
- [#52] Update Postfix auf 3.10.4

## [v3.10.3-2] - 2025-08-06
### Changed
- [#48] Netzwerkbeschränkungen nur in klassischen CES-Umgebungen anwenden

## [v3.10.3-1] - 2025-08-05
### Changed
- [#50] Update Postfix auf 3.10.3
### Security
- Patched [CVE-2025-6965](https://avd.aquasec.com/nvd/2025/cve-2025-6965/)

## [v3.10.2-2] - 2025-06-11
### Changed
- Wir haben nur technische Änderungen vorgenommen. Näheres finden Sie in den Changelogs.

## [v3.10.2-1] - 2025-06-05
### Changed
- [#44] Update Postfix auf v3.10.2
- [#44] Update makefiles auf v10.1.0
- [#44] Updated Base Image auf v3.22.0-1

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
- Die Cloudogu-eigenen Quellen werden von der MIT-Lizenz auf die AGPL-3.0-only relizensiert.
