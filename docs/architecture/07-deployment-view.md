# Deployment View

## Packaging

- Maven builds the Spring Boot application.
- Maven runs the Angular build in `frontend/`.
- The generated frontend assets are copied into the backend artifact.
- GitLab CI validates the integrated build and test flow before changes are merged.
- Git tags trigger a release job that publishes an OCI image to the project's GitLab Container Registry.

## Runtime topology

- One Spring Boot process serves both API responses and static frontend assets.
- Docker, Spring Boot buildpacks, and GitLab CI can package the application into a container image.

## Environment assumptions

- Java 21 is available for backend build and runtime.
- Node.js 24 is available for frontend tooling and integrated builds.
