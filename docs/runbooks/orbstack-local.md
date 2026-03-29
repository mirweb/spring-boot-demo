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

## Using the agent for deployments

The agent provides a kubeconfig context in CI jobs. Reference it with the project path and agent name:

```yaml
deploy:
  image: bitnami/kubectl
  script:
    - kubectl config use-context mirko111/spring-boot-demo:orbstack
    - kubectl apply -f k8s/
```

## Tear down

```bash
cd infra/orbstack-local
tofu destroy
```
