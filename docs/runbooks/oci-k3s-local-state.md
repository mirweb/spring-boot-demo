# OCI Free Tier k3s With Local OpenTofu State

## Purpose

This runbook describes a local-state variant of the OCI k3s stack under `infra/oci-k3s-local/`.

Use it when you want the same OCI infrastructure workflow without GitLab-managed state during initial experiments or before CI integration is ready.

## Difference from the GitLab-backed stack

- `infra/oci-k3s-local/` has no backend block, so OpenTofu writes state to the local working directory.
- `infra/oci-k3s/` uses the GitLab HTTP backend and is the preferred long-term path for shared state and CI.

The actual OCI resources, variables, and outputs are intentionally the same in both roots.

## OCI preparation

Before the first `tofu init` and `tofu apply`, prepare the OCI side so you can fill `terraform.tfvars`.

### 1. Create or choose a target compartment

Use a dedicated compartment for this stack if possible.

You need:

- the tenancy OCID
- the target compartment OCID

Typical lookup in the OCI Console:

- tenancy OCID: profile menu, then the tenancy details page
- compartment OCID: `Identity & Security` -> `Compartments` -> target compartment

### 2. Create or choose a user for API access

The OpenTofu OCI provider needs a normal OCI user plus an API signing key.

You need:

- the user OCID
- an uploaded API public key
- the fingerprint of that uploaded key

Typical lookup in the OCI Console:

- user OCID: profile menu -> `User settings`
- API keys: `User settings` -> `Token and keys` -> `API keys`

### 3. Ensure IAM permissions exist

The user or its group must be allowed to create and manage:

- compute instances
- VCN, subnet, route table, internet gateway, and security list resources

For a minimal compartment-scoped setup, the relevant policies usually look like:

```text
Allow group <group-name> to manage instance-family in compartment <compartment-name>
Allow group <group-name> to manage virtual-network-family in compartment <compartment-name>
```

If your tenancy uses stricter policies, adapt them before the first apply.

### 4. Generate and upload the OCI API signing key

If you do not already have an API signing key for the user, create one and upload the public key in the OCI Console.

Example local key generation:

```bash
mkdir -p ~/.oci
openssl genrsa -out ~/.oci/oci_api_key.pem 2048
openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem
chmod 600 ~/.oci/oci_api_key.pem
```

Then upload `~/.oci/oci_api_key_public.pem` in OCI under the user's API keys.

After upload, collect:

- `fingerprint`: shown by OCI after the key is added
- `private_key_path`: for example `~/.oci/oci_api_key.pem`

If you prefer not to reference a file path, you can instead store the private key content in `private_key_pem`.

### 5. Generate the SSH key for the server login

This key is separate from the OCI API signing key. It is the SSH key that will be installed on the Ubuntu VM for the `ubuntu` user.

Example:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_oci_k3s -C "oci-k3s"
```

Then use:

- `~/.ssh/id_ed25519_oci_k3s` as your private SSH key
- the content of `~/.ssh/id_ed25519_oci_k3s.pub` as `ssh_public_key`

## Filling terraform.tfvars

Create the file from the example:

```bash
cd infra/oci-k3s-local
cp terraform.tfvars.example terraform.tfvars
```

The required values come from these sources:

- `tenancy_ocid`: OCI tenancy details page
- `compartment_id`: target compartment details page
- `user_ocid`: OCI user settings page
- `fingerprint`: the uploaded OCI API signing key fingerprint
- `private_key_path`: local path to the OCI API private key
- `ssh_public_key`: content of your SSH public key file for VM access

Example:

```hcl
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaaexample"
compartment_id   = "ocid1.compartment.oc1..bbbbbbbbexample"
user_ocid        = "ocid1.user.oc1..ccccccccexample"
fingerprint      = "12:34:56:78:90:ab:cd:ef:12:34:56:78:90:ab:cd:ef"
private_key_path = "~/.oci/oci_api_key.pem"
ssh_public_key   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIexample oci-k3s"
```

Optional values you may want to set early:

- `region`: default is `eu-frankfurt-1`
- `shape`: default is `VM.Standard.E2.1.Micro`
- `ssh_allowed_cidrs`: restrict SSH access to your own IP range
- `kubernetes_api_allowed_cidrs`: restrict API server access
- `http_allowed_cidrs`: restrict HTTP and HTTPS exposure

## Quick value checklist

Before the first apply, verify:

- the OCI API key uploaded in the Console matches the private key referenced by `private_key_path`
- the `fingerprint` belongs to that uploaded key
- `ssh_public_key` is an SSH public key and not the OCI API key
- the selected compartment really has the required IAM permissions
- the chosen shape is available in `eu-frankfurt-1`

## Local-state workflow

```bash
cd infra/oci-k3s-local
cp terraform.tfvars.example terraform.tfvars
tofu init
tofu plan
tofu apply
```

Destroy when no longer needed:

```bash
tofu destroy
```

The local state files stay in the local root, typically:

- `infra/oci-k3s-local/terraform.tfstate`
- `infra/oci-k3s-local/.terraform/`

Do not commit these files.

## Accessing the cluster

```bash
cd infra/oci-k3s-local
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

## Fish shell usage

```fish
cd infra/oci-k3s-local
cp terraform.tfvars.example terraform.tfvars
tofu init
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

## Migrating local state to GitLab-managed state

When you are ready to move from local state to shared GitLab-managed state, keep the same input values and migrate the state snapshot explicitly.

1. Create a backup from the local-state root.

```bash
cd infra/oci-k3s-local
tofu state pull > migration.tfstate
cp terraform.tfvars ../oci-k3s/terraform.tfvars
```

2. Configure GitLab backend access for the GitLab-backed root.

```bash
export GITLAB_PROJECT_ID=<gitlab-project-id>
export GITLAB_TOKEN=<gitlab-personal-or-project-access-token>
cd ../oci-k3s
./scripts/init-backend.sh tofu init -reconfigure
```

3. Push the local snapshot into the empty GitLab-managed state.

```bash
tofu state push ../oci-k3s-local/migration.tfstate
```

4. Verify the migrated state and planned changes.

```bash
tofu state list
tofu plan
```

## Migration notes

- Run the migration before making further changes in either root.
- Keep a backup of `migration.tfstate` until `tofu plan` in `infra/oci-k3s/` shows no unexpected changes.
- Do not apply both roots against the same OCI environment after migration. From that point on, treat `infra/oci-k3s/` as the source of truth.
- If the remote state already contains resources, stop and inspect it before using `tofu state push`.
