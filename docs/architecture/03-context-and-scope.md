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
- an OpenTofu stack that provisions a single-node OCI Free Tier k3s environment

## External interfaces

- Browser users access the Angular UI over HTTP.
- The Angular UI calls backend endpoints such as `GET /api/hello`.
- Developers use Maven, npm, Docker, and OpenTofu for local workflows.
- GitLab-managed OpenTofu state stores infrastructure state and locking metadata.

## Boundary

This repository owns the application code, infrastructure code, build logic, documentation, and local operational setup. OCI-based hosting and GitLab-managed infrastructure state are now in scope for the k3s deployment workflow.
