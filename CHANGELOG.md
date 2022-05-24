# Postfix Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
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