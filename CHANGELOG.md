# dotrepo CHANGELOG

This document tracks all changes to application between versions.
Versioning follows the [semver](https://semver.org) guidelines. In short
versions follow the following format `major.minor.patch`. Bug fixes
increment the patch value, new features that aren't user interface breaking
increment raise the minor value, and feature additions that alter the
user interface result in a major increment. The major may also be incremented
in cases where there were a lot of new feature additions.

Changes are categorised into a number of categories namely:

- Added
- Fixed
- Removed
- Deprecated

`Added` tracks all new additions. `Fixed` tracks all bug fixes. `Removed`
tracks all removals that were previosly scheduled for removal. `Deprecated`
tracks all pending removals.

[Unreleased]

### Added

- option for printing version information
- export --all command to allow exporting of files in repository

### Fixed

- Non user friendly error message on export of non-existent dotfile
- Non user friendly error message on export to path that already exists

## [2021-11-12] - v1.0.0

### Added

- import command: imports files into repository
- export command: exports files from repository to user directory
- ls command: lists all files in repository
- path command: prints repository path
