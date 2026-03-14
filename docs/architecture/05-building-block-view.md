# Building Block View

## Level 1

- `src/main/java/.../SpringBootDemoApplication.java`: Spring Boot entrypoint and HTTP endpoint.
- `src/main/java/.../SpaForwardingController.java`: forwards SPA routes to `index.html`.
- `frontend/src/app/`: Angular application shell and interaction with the backend API.
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
