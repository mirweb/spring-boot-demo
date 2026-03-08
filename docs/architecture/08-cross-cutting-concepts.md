# Cross-Cutting Concepts

## Build and versioning

- Maven is the canonical project version source.
- Frontend metadata is generated from `pom.xml` for consistent version display.

## Documentation

- Technical documentation lives under `docs/`.
- Architectural decisions are captured as ADRs.
- API documentation is exposed via OpenAPI and Swagger UI.

## Testing

- Backend tests run through Maven and Spring Boot test support.
- Frontend tests validate rendered UI behavior and API interactions.
- GitLab CI runs repository validation on pushes and merge requests through `.gitlab-ci.yml`.
- GitLab CI publishes backend and frontend JUnit test reports for job-level inspection.
