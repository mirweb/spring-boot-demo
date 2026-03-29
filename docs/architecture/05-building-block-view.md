# Building Block View

## Level 1

- `src/main/java/.../SpringBootDemoApplication.java`: Spring Boot entrypoint and HTTP endpoint.
- `src/main/java/.../SpaForwardingController.java`: forwards SPA routes to `index.html`.
- `frontend/src/app/`: Angular application shell and interaction with the backend API.
- `infra/oci-k3s/`: OpenTofu configuration, GitLab backend bootstrap script, and cloud-init template for the OCI k3s node.
- `pom.xml`: integrated backend and frontend build orchestration.

## Level 2

### Backend

- REST controller logic for greeting responses.
- MVC forwarding for SPA route handling.

### Frontend

- Angular root component for the shared banner, navigation, routed body, and footer shell.
- Angular home page component for the default greeting workflow on `/`.
- Angular feature page component for the dedicated `/feature` route.
- generated app metadata for displaying application name and version.

### Build

- npm install and Angular build executed from Maven.
- static frontend assets copied into Spring Boot resources.

### Infrastructure

- OCI network resources for a public single-node k3s host.
- OCI compute instance bootstrapped with cloud-init and the k3s install script.
- GitLab HTTP backend configuration for shared OpenTofu state.
