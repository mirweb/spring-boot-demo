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
- Version metadata shown in the frontend footer is generated from `pom.xml`.
