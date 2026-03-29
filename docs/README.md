# Documentation

This directory contains the project's technical documentation in Markdown.

## Structure

- `architecture/`: lightweight arc42-inspired architecture documentation.
- `adr/`: Architecture Decision Records (ADRs), one Markdown file per decision.
- `api/`: API documentation conventions and entrypoints.
- `runbooks/`: operational and team workflows.
- `runbooks/oci-k3s.md`: OCI Free Tier k3s provisioning workflow with OpenTofu and GitLab-managed state.
- `runbooks/oci-k3s-local-state.md`: alternative OCI Free Tier k3s workflow with local OpenTofu state and migration guidance to GitLab-managed state.

## Working agreement

- Keep documentation close to the code and update it with relevant changes.
- Prefer short, concrete Markdown documents over broad placeholders.
- Use ADRs for decisions that change architecture, tooling, boundaries, or delivery workflow.
