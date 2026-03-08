# Constraints

## Technical constraints

- Backend runtime is Java 21 with Spring Boot.
- Frontend runtime and build are based on Node.js 24 and Angular.
- Maven is the top-level build entrypoint for integrated packaging.
- Frontend assets are served by the Spring Boot application.

## Organizational constraints

- Repository documentation should remain Markdown-only.
- Changelog updates are required before commits.
- Commit messages follow Conventional Commits.

## Quality constraints

- The project should stay easy to build locally.
- Architecture and workflow changes should be reflected in `docs/`.
