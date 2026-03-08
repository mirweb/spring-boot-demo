# Deployment View

## Packaging

- Maven builds the Spring Boot application.
- Maven runs the Angular build in `frontend/`.
- The generated frontend assets are copied into the backend artifact.

## Runtime topology

- One Spring Boot process serves both API responses and static frontend assets.
- Docker and Spring Boot buildpacks can package the application into a container image.

## Environment assumptions

- Java 21 is available for backend build and runtime.
- Node.js 24 is available for frontend tooling and integrated builds.
