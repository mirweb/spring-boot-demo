# Cross-Cutting Concepts

## Build and versioning

- Maven is the canonical project version source.
- Frontend metadata is generated from `pom.xml` for consistent version display.

## Documentation

- Technical documentation lives under `docs/`.
- Architectural decisions are captured as ADRs.

## Testing

- Backend tests run through Maven and Spring Boot test support.
- Frontend tests validate rendered UI behavior and API interactions.
