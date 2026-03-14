# spring-boot-demo

Spring Boot demo application with an integrated Angular frontend in `frontend/`.

Technical documentation lives under [`docs/`](docs/README.md).

- `GET /api/hello`
- `GET /api/hello?name=Alice`

## Prerequisites

- Java 21
- Node.js 24 LTS for direct Angular development in `frontend/`
- Docker (for building/running container images)

## Run locally

```bash
./mvnw spring-boot:run
```

The app starts on `http://localhost:8080` and serves the built Angular app from the same Spring Boot process.

Quick check:

```bash
curl "http://localhost:8080/api/hello"
curl "http://localhost:8080/api/hello?name=Alice"
curl "http://localhost:8080/v3/api-docs"
```

Example responses:

```json
{"message":"Hello World!"}
{"message":"Hello Alice!"}
```

Swagger UI is available at `http://localhost:8080/swagger-ui.html`, and the OpenAPI specification is exposed at `http://localhost:8080/v3/api-docs`.
When the application runs with the `prod` profile, both endpoints are disabled.

## Frontend development

The Angular application lives in `frontend/`.

Run the Angular dev server:

```bash
cd frontend
npm start
```

Run the Spring Boot backend in parallel:

```bash
./mvnw spring-boot:run
```

Run with production-oriented settings:

```bash
SPRING_PROFILES_ACTIVE=prod ./mvnw spring-boot:run
```

For integrated packaging, Maven runs `npm ci`, builds Angular with a Node 24 runtime, and bundles the generated static assets into the Spring Boot jar.

## Run tests

```bash
./mvnw test
```

## Continuous integration

GitLab CI validates the repository on pushes and merge requests using `.gitlab-ci.yml`.

The pipeline currently runs:

- Java 21 setup
- Node.js 24 setup
- `./mvnw --batch-mode test` with Maven Surefire reports published to GitLab
- frontend unit tests with a JUnit report published to GitLab
- a tag-only release job that publishes an OCI image to the GitLab Container Registry as `$CI_REGISTRY_IMAGE:$CI_COMMIT_TAG`

## Docker run options

Build and run an OCI image via Spring Boot buildpacks:

```bash
./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=spring-boot-demo:local
docker run --rm -p 8080:8080 spring-boot-demo:local
```

Or run with Docker Compose:

```bash
./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=spring-boot-demo:local
docker compose up -d
```

Tagged GitLab pipelines also publish an OCI image to the project container registry through Maven Jib, using the Git tag as the image tag.


## Package the app

Build the executable Spring Boot jar:

```bash
./mvnw package
```

The jar is created under `target/` (for example `target/spring-boot-demo-0.1.0.jar`).

Run the packaged jar:

```bash
java -jar target/spring-boot-demo-0.1.0.jar
```
