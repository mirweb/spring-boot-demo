# Context And Scope

## Diagram

The context diagram source is maintained in [context-and-scope.puml](./context-and-scope.puml).

```plantuml
::include{file=context-and-scope.puml}
```

## System scope

The system consists of:

- a Spring Boot web application exposing HTTP endpoints
- an Angular single-page application served from the same backend
- a Maven build that orchestrates backend packaging and frontend bundling

## External interfaces

- Browser users access the Angular UI over HTTP.
- The Angular UI calls backend endpoints such as `GET /api/hello`.
- Developers use Maven, npm, and Docker for local workflows.

## Boundary

This repository owns the application code, build logic, documentation, and local operational setup. External hosting, CI, and production platform concerns are out of scope until explicitly added.
