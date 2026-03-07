# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]
### Added
- Add a project-local `.mise.toml` to pin the Java and Node.js tool versions used by the build.

### Changed
- Require Conventional Commits for future commit messages in `AGENTS.md`.

## [0.2.1] - 2026-03-07
### Added
- Add a generated Angular app metadata module sourced from the Maven project version and name.

### Changed
- Sync the Angular frontend version metadata from `pom.xml` before frontend start, build, watch, and test commands.
- Show the application name and version in a small footer in the Angular app.
- Make the Angular footer metadata test independent from any hard-coded version string.

## [0.2.0] - 2026-03-07
### Added
- Add an Angular application under `frontend/` as the start of an integrated frontend stack.

### Changed
- Build and bundle the Angular app through Maven so Spring Boot serves the generated static assets.
- Add Spring MVC forwarding for the Angular SPA entrypoint.
- Document integrated Angular frontend development and packaging in `README.md`.
- Add simple log output for the `hello` endpoint method and request parameter.

## [0.1.0] - 2026-03-07
### Added
- Add `README.md` with local usage instructions for running, testing, and packaging.
- Document Docker-based run and test options in `README.md`.
- Clarify standard Docker image support gaps in `README.md` (`Dockerfile` and `.dockerignore`).
- Add a minimal `compose.yaml` with an app service and exposed port.

### Changed
- Change `GET /api/hello` response from plain text to JSON with a `message` field.
- Upgrade Spring Boot parent from `4.0.2` to `4.0.3` (latest stable 4.x patch release).
- Use `spring-boot-starter-web` for standard web dependencies.
- Use `spring-boot-starter-test` for `@WebMvcTest` support.
