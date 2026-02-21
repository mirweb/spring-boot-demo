# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]
### Added
- Add `README.md` with local usage instructions for running, testing, and packaging.
- Document Docker-based run and test options in `README.md`.
- Clarify standard Docker image support gaps in `README.md` (`Dockerfile` and `.dockerignore`).
- Add a minimal `compose.yaml` with an app service and exposed port.

### Changed
- Use `spring-boot-starter-web` for standard web dependencies.
- Use `spring-boot-starter-test` for `@WebMvcTest` support.
