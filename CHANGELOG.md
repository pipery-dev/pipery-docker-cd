# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Changed
- All step scripts now use `#!/usr/bin/env psh` as the shebang — psh intercepts and logs every command automatically instead of wrapping each command individually
- `setup-psh.sh` detects runner architecture dynamically (supports amd64 and arm64)

- Initial scaffold.
