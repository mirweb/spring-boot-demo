# OCI Free Tier k3s With OpenTofu

## Purpose

This runbook describes how to provision and manage the single-node OCI Free Tier k3s environment defined in `infra/oci-k3s/`.

If you want to start without GitLab-managed state, use [`oci-k3s-local-state.md`](./oci-k3s-local-state.md). That runbook also documents how to migrate the resulting local state into this GitLab-backed stack later.

## Prerequisites

- OpenTofu `1.11.5`
- An OCI API key with permission to manage networking and compute resources in the target compartment
- An SSH keypair for the `ubuntu` user
- A GitLab token that can access the project's managed OpenTofu state

## Repository layout

- `infra/oci-k3s/backend.tf`: GitLab HTTP backend declaration
- `infra/oci-k3s/main.tf`: OCI networking and compute resources
- `infra/oci-k3s/cloud-init.yaml.tftpl`: first-boot k3s installation
- `infra/oci-k3s/scripts/init-backend.sh`: exports GitLab backend environment variables and can execute `tofu init`

## Required local variables

Create `infra/oci-k3s/terraform.tfvars` from `terraform.tfvars.example` and set at least:

- `tenancy_ocid`
- `compartment_id`
- `user_ocid`
- `fingerprint`
- `private_key_path` or `private_key_pem`
- `ssh_public_key`

The stack defaults to:

- region `eu-frankfurt-1`
- shape `VM.Standard.E2.1.Micro`
- a dedicated VCN `10.42.0.0/16`
- a public subnet `10.42.0.0/24`
- Ubuntu 24.04 selected dynamically from OCI for the requested shape

## GitLab state setup

Set:

- `GITLAB_PROJECT_ID` to the numeric GitLab project ID
- `GITLAB_TOKEN` or `TF_PASSWORD` to a personal or project access token

Then initialize:

```bash
cd infra/oci-k3s
./scripts/init-backend.sh tofu init -reconfigure
```

The helper exports the `TF_HTTP_*` variables required for the GitLab-managed HTTP backend and defaults the state name to `oci-k3s`.

## Local workflow

```bash
cd infra/oci-k3s
cp terraform.tfvars.example terraform.tfvars
./scripts/init-backend.sh tofu init -reconfigure
tofu plan
tofu apply
```

Destroy when no longer needed:

```bash
tofu destroy
```

## CI variables

The GitLab CI plan/apply jobs expect these variables:

- `OCI_TENANCY_OCID`
- `OCI_COMPARTMENT_OCID`
- `OCI_USER_OCID`
- `OCI_FINGERPRINT`
- `OCI_PRIVATE_KEY_PEM`
- `OCI_SSH_PUBLIC_KEY`
- optional `OCI_REGION`
- required for apply state writes: `GITLAB_TERRAFORM_PASSWORD`
- optional for apply state writes: `GITLAB_TERRAFORM_USERNAME`

`opentofu-plan` runs only when the required OCI variables are present.

`opentofu-apply` is a manual default-branch job and additionally requires `GITLAB_TERRAFORM_PASSWORD` so the GitLab HTTP backend can lock and update state.

## Accessing the cluster

Get the node details:

```bash
cd infra/oci-k3s
tofu output public_ip
tofu output ssh_command
tofu output kubeconfig_fetch_command
```

Fetch the kubeconfig:

```bash
scp ubuntu@<public-ip>:/etc/rancher/k3s/k3s.yaml ./k3s.yaml
sed -i.bak "s/127.0.0.1/<public-ip>/g" ./k3s.yaml
kubectl --kubeconfig ./k3s.yaml get nodes
```

The default security list exposes SSH, the Kubernetes API, and HTTP/HTTPS publicly. Restrict the `*_allowed_cidrs` variables before long-lived use.

## Fish shell usage

The helper scripts are plain POSIX shell scripts, so you can call them from `fish` without changes:

```fish
cd infra/oci-k3s
set -x GITLAB_PROJECT_ID 12345678
set -x GITLAB_TOKEN glpat-xxxxxxxx
./scripts/init-backend.sh tofu init -reconfigure
tofu plan
tofu apply
```

Set OpenTofu input variables in `fish` with `set -x`, for example:

```fish
set -x TF_VAR_tenancy_ocid ocid1.tenancy.oc1....
set -x TF_VAR_compartment_id ocid1.compartment.oc1....
set -x TF_VAR_user_ocid ocid1.user.oc1....
set -x TF_VAR_fingerprint 12:34:56:78:90:ab:cd:ef
set -x TF_VAR_private_key_path ~/.oci/oci_api_key.pem
set -x TF_VAR_ssh_public_key (cat ~/.ssh/id_ed25519.pub)
```

If you use `terraform.tfvars`, you only need the GitLab backend variables in the shell session.

## Limitations and tradeoffs

- OCI Free Tier capacity is not guaranteed; shape availability can fail applies in Frankfurt.
- The Ubuntu image is chosen dynamically from OCI at apply time, which keeps the stack current but can change future plans.
- The cluster is single-node and public by default. It is suitable for experimentation, not for production-grade resilience.
