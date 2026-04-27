# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [1.0.1] - 2026-04-27

### Added
- GitHub Marketplace branding icon updated to match action technology (Feather icon set)
- Added `simple_icon` field to `pipery-action.toml` for technology icon reference (Simple Icons slug)

### Changed
- All step scripts now use `#!/usr/bin/env psh` as the shebang — psh intercepts and logs every command automatically instead of wrapping each command individually
- `setup-psh.sh` detects runner architecture dynamically (supports amd64 and arm64)

- Initial scaffold.
