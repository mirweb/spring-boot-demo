# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added
- Add `GET /api/info` endpoint that returns application name and version from Spring Boot `BuildProperties` ([#10](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/10)).
- Enable `build-info` goal in `spring-boot-maven-plugin` to populate `BuildProperties` at build time ([#10](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/10)).
- Frontend footer now fetches version info dynamically from `/api/info`; falls back to local `APP_METADATA` on error ([#10](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/10)).

## [0.6.3] - 2026-04-01

### Added
- Install Traefik as the default ingress controller on the OrbStack local cluster via the `infra/orbstack-local` OpenTofu module (Helm, `LoadBalancer`, HTTP→HTTPS redirect).

### Changed
- Switch `deploy/spring-boot-demo.yaml` ingress from `nginx` to `traefik` IngressClass; remove `nginx.ingress.kubernetes.io/ssl-redirect` annotation (redirect handled by Traefik entry point).
- Validate CI jobs are now manual on normal commits and run automatically on tag push only.

## [0.6.2] - 2026-04-01

### Added
- Add local manual deployment section to `docs/runbooks/orbstack-local.md` explaining how to deploy a specific version via `deploy/spring-boot-demo.yaml` using `sed` substitution and `kubectl apply`.
- Add `.claude/skills/release.md` custom skill (`/release <version>`) to automate version bumping, CHANGELOG finalization, commit, and tagging.

### Fixed
- Remove `Secret` resource from `deploy/spring-boot-demo.yaml` — it was overwriting the registry credentials set by `before_script` with a placeholder empty JSON (`e30K`), causing image pull failures on Kubernetes.

## [0.6.0] - 2026-03-31
### Added
- Add `deploy/spring-boot-demo.yaml` Kubernetes manifest for deploying the application to the OrbStack local cluster via the GitLab Kubernetes Agent.
- Add manual `deploy-orbstack` CI job (stage `deploy`) that applies the manifest via the `orbstack` agent after a tagged release image is published.
- Add HTTPS Ingress for `https://spring-boot-demo.k8s.orb.local` via mkcert wildcard TLS (`*.k8s.orb.local`).

### Changed
- Build multi-arch Docker images (`linux/amd64`, `linux/arm64`) via Jib `<platforms>` configuration.
- Replace `RUNNER_TAG` CI variable with `spec:inputs` dropdown for selecting the runner tag in the GitLab UI.
- Make Node.js download in CI arch-independent (`amd64` + `arm64`).

## [0.5.1] - 2026-03-29
### Added
- Add OpenTofu module `infra/orbstack-local` to install GitLab Runner and GitLab Kubernetes Agent on the local OrbStack cluster via Helm ([#9](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/9)).
- Add `.gitlab/agents/orbstack/config.yaml` for GitLab Kubernetes Agent CI access ([#9](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/9)).
- Add runbook `docs/runbooks/orbstack-local.md` describing local runner and agent setup ([#9](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/9)).

### Fixed
- Set ARM64 helper image for GitLab Runner on OrbStack (Apple Silicon) to fix `no matching manifest for linux/arm64/v8` image pull error ([#9](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/9)).
- Add `kubernetes.io/arch=arm64` node selector to GitLab Runner config to force ARM64 pod scheduling on OrbStack ([#9](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/9)).
- Add PersistentVolumeClaims for Maven and npm cache in `infra/orbstack-local` for future self-hosted runner use ([#9](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/9)).

### Changed
- Route all CI jobs to the `self-hosted` runner tag; remove OCI OpenTofu infra stage from the pipeline ([#9](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/9)).

## [0.5.0] - 2026-03-29
### Added
- Add a project-local `opentofu` tool entry to `.mise.toml` so infrastructure tooling is available through the pinned local toolchain.
- Add an OpenTofu-based OCI Free Tier single-node k3s provisioning workflow under `infra/oci-k3s`, including GitLab-managed remote state bootstrap and a cloud-init based k3s install path ([#7](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/7)).
- Add a second OCI k3s root under `infra/oci-k3s-local` that uses plain local OpenTofu state, plus a dedicated runbook for migrating that local state into the GitLab-backed stack later ([#7](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/7)).

### Changed
- Bump Spring Boot from `4.0.3` to `4.0.5` ([#8](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/8)).
- Bump Angular from `21.2.1` to `21.2.6` / `21.2.5` (build tooling) via `ng update` ([#8](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/8)).
- Switch default OCI compute shape from `VM.Standard.E2.1.Micro` to `VM.Standard.A1.Flex` (4 OCPUs, 24 GB RAM) to fully utilise the OCI Always Free ARM quota ([#7](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/7)).
- Extend GitLab CI and repository documentation to cover OpenTofu validation, OCI plan/apply automation, GitLab state usage, and operational tradeoffs for the OCI Free Tier k3s workflow ([#7](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/7)).
- Document the OCI OpenTofu workflows with direct `tofu` commands for local usage and migration guidance ([#7](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/7)).

## [0.4.0] - 2026-03-14
### Added
- Add a project-local `glab` tool entry to `.mise.toml` so GitLab CLI usage is available through the pinned local toolchain.
- Add a dedicated Angular feature page route alongside the default main page ([#6](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/6)).

### Changed
- Restructure the Angular frontend into a shared shell with a blue banner, a two-entry navigation menu, and a routed body area while keeping the footer compact at the bottom ([#6](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/6)).
- Disable SpringDoc OpenAPI and Swagger UI endpoints automatically when the `prod` profile is active.
- Require issue-linked changelog entries and GitLab-style issue references in commit message footers for future issue-based work in `AGENTS.md`.

## [0.3.1] - 2026-03-08
### Added
- Add a tag-only GitLab CI release job that publishes an OCI image to the project GitLab Container Registry.

### Changed
- Configure Maven Jib for registry publishing from CI without requiring a Docker daemon.
- Document the tagged image publication flow in the README, release runbook, and deployment documentation.
- Run the Maven package phase before the tag image publish step so the GitLab release job has compiled application output for Jib.

## [0.3.0] - 2026-03-08
### Added
- Add a project-local `.mise.toml` to pin the Java and Node.js tool versions used by the build.
- Add a GitLab CI pipeline that validates the application on pushes and merge requests.
- Add OpenAPI and Swagger UI support for the backend API.
- Add a Markdown-based `docs/` directory with architecture, ADR, and runbook content.
- Add a PlantUML context-and-scope diagram to the architecture documentation.

### Changed
- Require Conventional Commits for future commit messages in `AGENTS.md`.
- Require `.gitlab-ci.yml` and CI documentation to stay aligned with workflow changes in `AGENTS.md`.
- Require `docs/` updates in `AGENTS.md` when relevant technical changes are made.
- Require OpenAPI documentation to stay aligned with API changes in `AGENTS.md`.
- Switch GitLab CI to a Java 21 base image and install Node.js 24 explicitly to fix pipeline startup.
- Publish Maven and frontend test results as GitLab job reports in CI.

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
