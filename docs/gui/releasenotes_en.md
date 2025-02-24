# Release Notes

Below you will find the release notes for the Postfix-Dogu.

Technical details on a release can be found in the corresponding [Changelog](https://docs.cloudogu.com/en/docs/dogus/postfix/CHANGELOG/).

## [Unreleased] - 2025-02-24
- Security fix: Resolved [CVE-2024-45337](https://avd.aquasec.com/nvd/2024/cve-2024-45337/).
- `mail_version` now displays the full version number.
- `permit_sasl_authenticated` now correctly processes XCLIENT LOGIN information.
- `syslog_name` retains multi-instance information.
- Fixed file descriptor leak after failed Dovecot authentication attempt.
- `postsuper` now works when `maillog_file` is set and Postfix is not running.


## [v3.9.0-3]
- Relicense own code to AGPL-3.0-only