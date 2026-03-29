# Introduction And Goals

## Purpose

`spring-boot-demo` is a small full-stack application that combines a Spring Boot backend with an Angular frontend in one repository and one packaged deployment artifact.

## Primary goals

- Provide a simple HTTP API and browser UI in a single project.
- Keep local development straightforward with standard Java, Maven, Node.js, and npm tooling.
- Add a reproducible infrastructure workflow for provisioning a small OCI-hosted k3s environment.
- Package the frontend together with the backend so the application can run as one deployable unit.
- Keep the codebase understandable enough for experimentation and incremental extension.

## Stakeholders

- Developers working on backend and frontend code.
- Operators or developers provisioning the OCI-based k3s environment.
- Reviewers and maintainers who need a clear architectural overview.
- Operators or developers packaging and running the application locally or in CI.
