# spring-boot-demo

Simple Spring Boot demo application with one HTTP endpoint:

- `GET /api/hello`
- `GET /api/hello?name=Alice`

## Prerequisites

- Java 21
- Docker (for building/running container images)

## Run locally

```bash
./mvnw spring-boot:run
```

The app starts on `http://localhost:8080`.

Quick check:

```bash
curl "http://localhost:8080/api/hello"
curl "http://localhost:8080/api/hello?name=Alice"
```

## Run tests

```bash
./mvnw test
```

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


## Package the app

Build the executable Spring Boot jar:

```bash
./mvnw package
```

The jar is created under `target/` (for example `target/spring-boot-demo-0.0.1-SNAPSHOT.jar`).

Run the packaged jar:

```bash
java -jar target/spring-boot-demo-0.0.1-SNAPSHOT.jar
```

