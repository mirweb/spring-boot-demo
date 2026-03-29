# Solution Strategy

## Core approach

- Use Spring Boot as the single web server and deployment container.
- Keep the Angular app in `frontend/` and bundle its static output into the backend artifact.
- Use Maven as the root build orchestrator so packaging remains a single command.
- Use OpenTofu under `infra/oci-k3s` for reproducible OCI infrastructure provisioning with a GitLab HTTP backend for shared state.
- Keep documentation lightweight and versioned with the source code.

## Why this approach

- One deployable unit reduces operational friction for this project size.
- A monorepo keeps backend, frontend, build, and docs changes aligned.
- GitLab-managed OpenTofu state keeps local and CI infrastructure runs aligned without adding a separate state service.
- Markdown docs and ADRs are easy to review in Git.
