# Frontend

Angular application for the integrated UI layer of `spring-boot-demo`.

Use Node.js 24 LTS. The repository includes `.nvmrc` for that version line.

## Local development

Start the Angular dev server from this directory:

```bash
npm start
```

Start Spring Boot separately from the repository root:

```bash
./mvnw spring-boot:run
```

The Angular UI currently calls the backend endpoint `GET /api/hello`.
The Angular dev server proxies `/api/*` to `http://localhost:8080`.

## Build

Build the frontend only:

```bash
npm run build
```

The production assets are emitted to `dist/frontend/browser`.

## Test

Run Angular unit tests:

```bash
npm test -- --run
```

## Integrated packaging

The root Maven build runs `npm ci`, builds Angular with a Node 24 runtime, and then copies the generated frontend assets into the Spring Boot jar.
