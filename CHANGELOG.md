# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Added

- **Docs**: Added `AGENTS.md`, `CLAUDE.md` and `TESTING.md` with generic setup, commit and testing guidelines.

### Fixed

- **CI**: The `CHANGELOG` check now runs on every PR to `main`. It was filtered on a `my_package/` path that doesn't exist, so it never ran.
- **Tests**: Removed `test_version`, which hard-coded the version and would fail on the first version bump.
- **Pre-commit**: Removed leftover `unsloth_compiled_cache` excludes and fixed the `.ipynb` exclude, which never matched because the multi-line pattern ended in a newline.

### Security

- Bumped the `uv-pre-commit` hook to uv 0.13.4. Earlier versions ship the compromised emSign ECC Root CA - G3 root, which certifi 2026.10.19 and uv 0.13.4 remove.
