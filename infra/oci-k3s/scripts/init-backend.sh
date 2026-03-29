#!/usr/bin/env sh

set -eu

if [ -z "${GITLAB_PROJECT_ID:-}" ]; then
  echo "GITLAB_PROJECT_ID must be set." >&2
  exit 1
fi

state_name="${GITLAB_TERRAFORM_STATE_NAME:-oci-k3s}"
api_v4_url="${CI_API_V4_URL:-https://gitlab.com/api/v4}"
state_address="${api_v4_url}/projects/${GITLAB_PROJECT_ID}/terraform/state/${state_name}"

username="${GITLAB_TERRAFORM_USERNAME:-${TF_USERNAME:-${GITLAB_USERNAME:-gitlab-ci-token}}}"
password="${GITLAB_TERRAFORM_PASSWORD:-${TF_PASSWORD:-${GITLAB_TOKEN:-${CI_JOB_TOKEN:-}}}}"

if [ -z "${password}" ]; then
  echo "A GitLab token is required through GITLAB_TERRAFORM_PASSWORD, TF_PASSWORD, GITLAB_TOKEN, or CI_JOB_TOKEN." >&2
  exit 1
fi

export TF_HTTP_ADDRESS="${state_address}"
export TF_HTTP_LOCK_ADDRESS="${state_address}/lock"
export TF_HTTP_UNLOCK_ADDRESS="${state_address}/lock"
export TF_HTTP_LOCK_METHOD="POST"
export TF_HTTP_UNLOCK_METHOD="DELETE"
export TF_HTTP_USERNAME="${username}"
export TF_HTTP_PASSWORD="${password}"
export TF_HTTP_RETRY_WAIT_MIN="${TF_HTTP_RETRY_WAIT_MIN:-5}"

echo "Configured GitLab HTTP backend at ${state_address}" >&2

if [ "$#" -gt 0 ]; then
  exec "$@"
fi
