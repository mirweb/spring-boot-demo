# ADR 0001: Use Spring Boot With Angular In One Repository And One Packaged Application

## Status

Accepted

## Context

The project needs a simple way to deliver a backend API and a browser UI together without introducing unnecessary deployment complexity.

## Decision

Use:

- Spring Boot for the backend and static asset serving
- Angular for the frontend
- one repository for both parts
- Maven as the root packaging entrypoint
- one packaged application artifact that contains the built frontend assets

## Consequences

### Positive

- Backend and frontend changes can evolve together.
- One deployable unit keeps runtime setup simple.
- Versioning and documentation can stay centralized.

### Negative

- Backend and frontend build concerns are coupled.
- Independent deployment of frontend and backend is not the default path.
- Tooling spans Java and Node.js ecosystems.
