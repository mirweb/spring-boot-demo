# Solution Strategy

## Core approach

- Use Spring Boot as the single web server and deployment container.
- Keep the Angular app in `frontend/` and bundle its static output into the backend artifact.
- Use Maven as the root build orchestrator so packaging remains a single command.
- Keep documentation lightweight and versioned with the source code.

## Why this approach

- One deployable unit reduces operational friction for this project size.
- A monorepo keeps backend, frontend, build, and docs changes aligned.
- Markdown docs and ADRs are easy to review in Git.
