variable "gitlab_url" {
  description = "GitLab instance URL."
  type        = string
  default     = "https://gitlab.com"
}

variable "gitlab_runner_token" {
  description = "GitLab Runner authentication token (glrt-...). Create under Project → Settings → CI/CD → Runners."
  type        = string
  sensitive   = true
}

variable "gitlab_runner_tag" {
  description = "Tag assigned to the runner. Use this tag in .gitlab-ci.yml to target this runner."
  type        = string
  default     = "self-hosted"
}

variable "gitlab_agent_token" {
  description = "GitLab Kubernetes Agent token (glagent-...). Create under Project → Operate → Kubernetes clusters."
  type        = string
  sensitive   = true
}

variable "gitlab_agent_name" {
  description = "Name of the GitLab Kubernetes Agent as registered in GitLab."
  type        = string
  default     = "orbstack"
}
