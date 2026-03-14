# Local Development

## Prerequisites

- Java 21
- Node.js 24
- Maven wrapper from the repository

## Common workflows

### Backend only

```bash
./mvnw spring-boot:run
```

### Frontend dev server

```bash
cd frontend
npm start
```

### Tests

```bash
./mvnw test
```

## Notes

- The integrated Maven build bundles the Angular application into the backend artifact.
- The frontend exposes `/` as the main page and `/feature` as the secondary routed page inside the Angular shell.
- Version metadata shown in the frontend footer is generated from `pom.xml`.
- OpenAPI is available at `/v3/api-docs` and Swagger UI at `/swagger-ui.html` while the backend is running.
