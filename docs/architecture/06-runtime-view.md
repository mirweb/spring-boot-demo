# Runtime View

## Greeting request

1. A user opens the application in the browser.
2. Spring Boot serves the Angular application assets.
3. The Angular app issues a request to `GET /api/hello`, optionally with `name`.
4. The backend logs the request parameter and returns a JSON response.
5. The Angular UI renders the greeting text.

## SPA navigation

1. A browser requests `/` or `/app/**`.
2. Spring MVC forwards the request to `/index.html`.
3. The Angular router takes over client-side navigation.

## Infrastructure provisioning

1. A developer or GitLab CI job initializes the OpenTofu HTTP backend against GitLab-managed state.
2. OpenTofu queries OCI for availability domains and the newest Ubuntu 24.04 image available for the selected shape.
3. OpenTofu creates the VCN, subnet, route table, security list, internet gateway, and compute instance.
4. OCI cloud-init installs k3s on first boot through the official install script.
5. The operator copies `/etc/rancher/k3s/k3s.yaml` from the host and rewrites the server endpoint to the node's public IP before using `kubectl`.
