# Release Notes

Im Folgenden finden Sie die Release Notes für das Postfix-Dogu.

Technische Details zu einem Release finden Sie im zugehörigen [Changelog](https://docs.cloudogu.com/de/docs/dogus/postfix/CHANGELOG/).

## [Unreleased] - 2025-02-24
- Sicherheitsfix: [CVE-2024-45337](https://avd.aquasec.com/nvd/2024/cve-2024-45337/) behoben.
- `mail_version` zeigt nun die vollständige Versionsnummer.
- `permit_sasl_authenticated` berücksichtigt wieder XCLIENT LOGIN-Informationen.
- `syslog_name` speichert jetzt Multi-Instanz-Informationen.
- Dateideskriptor-Leck nach fehlschlagender Dovecot-Verbindung behoben.
- `postsuper` funktioniert nun auch, wenn `maillog_file` gesetzt ist und Postfix nicht läuft.

## [v3.9.0-3]
- Die Cloudogu-eigenen Quellen werden von der MIT-Lizenz auf die AGPL-3.0-only relizensiert.