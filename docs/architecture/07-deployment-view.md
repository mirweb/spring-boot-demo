# Deployment View

## Packaging

- Maven builds the Spring Boot application.
- Maven runs the Angular build in `frontend/`.
- The generated frontend assets are copied into the backend artifact.
- GitLab CI validates the integrated build and test flow before changes are merged.
- OpenTofu under `infra/oci-k3s` provisions OCI network and compute resources for a small k3s environment.
- GitLab-managed HTTP backend state is used for OpenTofu local and CI workflows.
- Git tags trigger a release job that publishes an OCI image to the project's GitLab Container Registry.

## Runtime topology

- One Spring Boot process serves both API responses and static frontend assets.
- Docker, Spring Boot buildpacks, and GitLab CI can package the application into a container image.
- One OCI Free Tier compute instance hosts a single-node k3s server installed through cloud-init.

## Environment assumptions

- Java 21 is available for backend build and runtime.
- Node.js 24 is available for frontend tooling and integrated builds.
- OCI credentials and SSH access are available for infrastructure provisioning.
