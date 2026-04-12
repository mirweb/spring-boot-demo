# OrbStack Local Kubernetes — GitLab Runner and Agent

## Purpose

This runbook describes how to install a GitLab Runner and the GitLab Kubernetes Agent on the local OrbStack Kubernetes cluster using the OpenTofu module under `infra/orbstack-local/`.

- **GitLab Runner** — executes CI jobs locally on your machine, tagged `self-hosted`.
- **GitLab Kubernetes Agent** (`agentk`) — connects the cluster to GitLab for kubeconfig-based deployments in CI.

## Prerequisites

- OrbStack running with Kubernetes enabled
- `kubectl config get-contexts` shows the `orbstack` context as available
- OpenTofu `1.11.5`
- A GitLab account with maintainer access to the project

## Getting the tokens

### Runner token

1. GitLab → Project → **Settings → CI/CD → Runners**
2. Click **New project runner**
3. Set tag: `self-hosted`
4. Copy the token (`glrt-...`)

### Agent token

1. GitLab → Project → **Operate → Kubernetes clusters**
2. Click **Connect a cluster**
3. Name: `orbstack`
4. Copy the token (`glagent-...`)

## Local setup

```bash
cd infra/orbstack-local
cp terraform.tfvars.example terraform.tfvars
# Fill in gitlab_runner_token and gitlab_agent_token
tofu init
tofu apply
```

## Verify

```bash
# Runner registered
kubectl -n gitlab-runner get pods

# Agent connected
kubectl -n gitlab-agent get pods

# GitLab UI: Project → Settings → CI/CD → Runners — runner should appear
# GitLab UI: Project → Operate → Kubernetes clusters — agent should show as Connected
```

## Using the runner in CI

Add the `self-hosted` tag to jobs that should run on your local cluster:

```yaml
test:
  tags:
    - self-hosted
  script:
    - ./mvnw test
```

## Wildcard TLS certificate for *.k8s.orb.local

The Ingress in `deploy/spring-boot-demo.yaml` expects a TLS secret named
`wildcard-k8s-orb-local-tls` in each app namespace. Create it once per namespace
using a mkcert wildcard certificate.

### One-time setup

1. Generate the wildcard certificate (if not already done):

   ```bash
   mkcert "*.k8s.orb.local"
   ```

   This produces `_wildcard.k8s.orb.local.pem` and `_wildcard.k8s.orb.local-key.pem`
   in the current directory. mkcert also installs its root CA so the cert is
   trusted system-wide.

2. Create the Kubernetes secret in the app namespace:

   ```bash
   kubectl create namespace spring-boot-demo
   kubectl create secret tls wildcard-k8s-orb-local-tls \
     --cert=_wildcard.k8s.orb.local.pem \
     --key=_wildcard.k8s.orb.local-key.pem \
     --namespace spring-boot-demo
   ```

   Repeat for each namespace that needs TLS. The secret name
   `wildcard-k8s-orb-local-tls` is referenced by all Ingress resources in this
   project — only the namespace must match.

After this, `https://spring-boot-demo.k8s.orb.local` is accessible with a
trusted certificate.

## Using the agent for deployments

The agent provides a kubeconfig context in CI jobs. Reference it with the project path and agent name:

```yaml
deploy:
  image: bitnami/kubectl
  script:
    - kubectl config use-context mirko111/spring-boot-demo:orbstack
    - kubectl apply -f k8s/
```

## Lokales manuelles Deployment via Manifest

Das Manifest `deploy/spring-boot-demo.yaml` enthält Platzhalter (`__IMAGE__`, `__VERSION__`), die vor dem Apply ersetzt werden müssen.

### Voraussetzungen

- OrbStack läuft, `kubectl config use-context orbstack` funktioniert
- TLS-Secret `wildcard-k8s-orb-local-tls` im Namespace `spring-boot-demo` ist angelegt (siehe Abschnitt oben)
- Zugriff auf die GitLab Container Registry (Login oder Deploy Token)

### Registry-Login einmalig einrichten

```bash
kubectl create secret docker-registry gitlab-registry \
  --docker-server=registry.gitlab.com \
  --docker-username=<dein-gitlab-username> \
  --docker-password=<dein-access-token> \
  --namespace spring-boot-demo \
  --dry-run=client -o yaml | kubectl apply -f -
```

### Manifest deployen

```bash
VERSION=0.6.0
IMAGE=registry.gitlab.com/mirko111/spring-boot-demo:${VERSION}

sed \
  -e "s|__IMAGE__|${IMAGE}|g" \
  -e "s|__VERSION__|${VERSION}|g" \
  deploy/spring-boot-demo.yaml | kubectl apply -f -
```

### Status prüfen

```bash
kubectl -n spring-boot-demo get pods,svc,ingress
kubectl -n spring-boot-demo rollout status deployment/spring-boot-demo
```

Die App ist danach erreichbar unter: `https://spring-boot-demo.k8s.orb.local`

### Deployment entfernen

```bash
kubectl delete namespace spring-boot-demo
```

> **Hinweis:** Damit wird auch das TLS-Secret gelöscht und muss beim nächsten Deployment neu angelegt werden.

## Traefik Dashboard

The Traefik dashboard is exposed via an `IngressRoute` at `https://traefik.k8s.orb.local/dashboard/`.

### One-time setup

Create the wildcard TLS secret in the `traefik` namespace (same certificate as for app namespaces):

```bash
kubectl create secret tls wildcard-k8s-orb-local-tls \
  --cert=_wildcard.k8s.orb.local.pem \
  --key=_wildcard.k8s.orb.local-key.pem \
  --namespace traefik
```

After `tofu apply`, the dashboard is available at:

```
https://traefik.k8s.orb.local/dashboard/
```

> **Note:** The trailing slash in `/dashboard/` is required — without it Traefik returns 404.

### Fallback: port-forward

If the TLS secret is not set up, the dashboard is also accessible via port-forward on the internal entrypoint:

```bash
kubectl -n traefik port-forward \
  $(kubectl -n traefik get pods -o name | head -1) \
  9000:8080
# http://localhost:9000/dashboard/
```

## Grafana + Loki + Prometheus (observability)

The `infra/orbstack-local` module deploys a full observability stack in the `monitoring` namespace for centralized log aggregation and metrics.

| Component | Role |
|-----------|------|
| **Loki** | Log aggregation backend (single-binary, filesystem storage) |
| **Promtail** | DaemonSet that ships logs from all pods to Loki |
| **Prometheus** | Metrics scraping and storage |
| **Grafana** | Visualization UI, pre-configured with Loki and Prometheus data sources |

### Access

After `tofu apply`, Grafana is available at:

```
https://grafana.k8s.orb.local
```

Default credentials: `admin` / `prom-operator` (see the `grafana` secret in the `monitoring` namespace for the generated password).

Retrieve the admin password:

```bash
kubectl -n monitoring get secret grafana \
  -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

### One-time TLS secret setup

Create the wildcard TLS secret in the `monitoring` namespace (same certificate as for other namespaces):

```bash
kubectl create secret tls wildcard-k8s-orb-local-tls \
  --cert=_wildcard.k8s.orb.local.pem \
  --key=_wildcard.k8s.orb.local-key.pem \
  --namespace monitoring
```

### Exploring logs

1. Open `https://grafana.k8s.orb.local`
2. Go to **Explore** → select the **Loki** data source
3. Use LogQL to filter logs, e.g. `{namespace="spring-boot-demo"}`

### Log retention

Loki is configured with a **90-day (2160 h)** retention period. The compactor runs automatically to enforce this limit.

### Prometheus

Prometheus is exposed at:

```
https://prometheus.k8s.orb.local
```

It scrapes metrics from the Spring Boot application every 15 seconds via the `/actuator/prometheus` endpoint. The scrape target is configured statically in `infra/orbstack-local/main.tf`:

```
spring-boot-demo.spring-boot-demo.svc.cluster.local:8080
```

To explore metrics in Grafana:

1. Open `https://grafana.k8s.orb.local`
2. Go to **Explore** → select the **Prometheus** data source
3. Use PromQL to query metrics, e.g. `http_server_requests_seconds_count`

### Verify

```bash
kubectl -n monitoring get pods
# Expected: loki-0, promtail-*, grafana-*, prometheus-server-*

kubectl -n monitoring logs -l app.kubernetes.io/name=promtail --tail=20
# Should show log scrape activity

# Check Prometheus scrape targets
kubectl -n monitoring port-forward svc/prometheus-server 9090:80
# Open http://localhost:9090/targets — spring-boot-demo should be UP
```

## Tear down

```bash
cd infra/orbstack-local
tofu destroy
```
