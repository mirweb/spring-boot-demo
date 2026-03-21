# Risks And Technical Debt

## Current risks

- Frontend and backend live in one deployable unit, which may become limiting if scaling needs diverge.
- Build orchestration spans Maven and npm, which can increase troubleshooting overhead.
- Documentation can drift if architectural and workflow changes are not updated together with code.
- OCI Free Tier capacity and image availability can vary by region and shape, which can break otherwise valid OpenTofu plans.
- The OpenTofu stack currently provisions a single public node, so it is not a high-availability or hardened production Kubernetes design.

## Current technical debt

- The architecture documentation is intentionally lightweight and will need refinement as the system grows.
- API documentation is currently minimal and mostly represented by code and tests.
- Release process documentation is basic and may need expansion once CI or deployment automation grows.
- The infrastructure workflow depends on external OCI provider behavior and has not yet been exercised automatically in this repository.
