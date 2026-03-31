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

### Backend with production profile

```bash
SPRING_PROFILES_ACTIVE=prod ./mvnw spring-boot:run
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

### Docker image (Jib)

Jib bietet zwei Build-Ziele für verschiedene Anwendungsfälle:

#### Schneller lokaler Test — einzelne Architektur

`jib:dockerBuild` schreibt direkt in den lokalen Docker-Daemon.
Die `<platforms>`-Konfiguration aus der `pom.xml` wird dabei ignoriert — es wird immer nur die Host-Architektur gebaut.

```bash
./mvnw -DskipTests package jib:dockerBuild \
  -Djib.to.image=spring-boot-demo:local
```

Image starten und prüfen:

```bash
docker run --rm -p 8080:8080 spring-boot-demo:local
```

#### Multi-Arch-Test mit lokaler Registry

Um das Multi-Arch-Build (`linux/amd64` + `linux/arm64`) lokal zu testen, wird eine Registry benötigt.
`jib:build` pushed das Manifest-Index-Image direkt dorthin.

> **macOS-Hinweis:** Port 5000 ist auf macOS durch den AirPlay Receiver belegt. Die Registry deshalb auf Port **5050** betreiben — andernfalls timed Jib mit einem `Read timed out`-Fehler aus.
> AirPlay Receiver lässt sich alternativ unter *Systemeinstellungen → Allgemein → AirDrop & Handoff* deaktivieren.

1. Lokale Registry starten (einmalig):

   ```bash
   docker run -d --name registry -p 5050:5000 registry:2
   ```

2. Multi-Arch-Image bauen und in die lokale Registry pushen:

   ```bash
   ./mvnw -DskipTests package jib:build \
     -Djib.to.image=localhost:5050/spring-boot-demo:local \
     -Djib.allowInsecureRegistries=true
   ```

3. Manifeste prüfen (beide Architekturen müssen erscheinen):

   ```bash
   docker buildx imagetools inspect localhost:5050/spring-boot-demo:local
   ```

4. Image für die Host-Architektur lokal ausführen:

   ```bash
   docker run --rm -p 8080:8080 localhost:5050/spring-boot-demo:local
   ```

5. Registry aufräumen (optional):

   ```bash
   docker rm -f registry
   ```

## Notes

- The integrated Maven build bundles the Angular application into the backend artifact.
- The frontend exposes `/` as the main page and `/feature` as the secondary routed page inside the Angular shell.
- Version metadata shown in the frontend footer is generated from `pom.xml`.
- OpenAPI is available at `/v3/api-docs` and Swagger UI at `/swagger-ui.html` while the backend is running.
- The `prod` profile disables `/v3/api-docs` and `/swagger-ui.html`.
- OCI and OpenTofu workflows are documented separately in [`oci-k3s.md`](./oci-k3s.md).
