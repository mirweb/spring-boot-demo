# ADR 0002: Use OpenTofu And GitLab-Managed State For OCI k3s Provisioning

## Status

Accepted

## Context

Issue [#7](https://gitlab.com/mirko111/spring-boot-demo/-/work_items/7) requires infrastructure automation that can provision a single-node k3s cluster in Oracle Cloud Infrastructure Free Tier from both a developer workstation and GitLab CI.

The workflow needs shared remote state, state locking, reproducible infrastructure definitions, and a practical way to bootstrap k3s on first boot without introducing a separate configuration-management stack.

## Decision

Use:

- OpenTofu as the infrastructure language and execution tool
- GitLab-managed HTTP backend state for local and CI runs
- OCI network and compute resources provisioned from a dedicated `infra/oci-k3s/` stack
- cloud-init plus the official k3s install script for first-boot server installation
- Ubuntu 24.04 images selected dynamically from OCI for the chosen compute shape in the Frankfurt region by default

## Consequences

### Positive

- Local and CI automation share the same infrastructure definitions and state backend.
- OpenTofu aligns with the project-local toolchain and avoids introducing a separate hosted state service.
- The implementation stays small enough for a single-node experimentation environment.

### Negative

- OCI image availability and Free Tier capacity remain external moving parts that can fail plans or applies.
- The GitLab HTTP backend requires explicit token management for state access and write operations.
- A cloud-init installed single-node k3s host is suitable for experimentation, not for highly available production use.
