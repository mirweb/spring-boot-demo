resource "helm_release" "gitlab_runner" {
  name             = "gitlab-runner"
  repository       = "https://charts.gitlab.io"
  chart            = "gitlab-runner"
  namespace        = "gitlab-runner"
  create_namespace = true

  set {
    name  = "gitlabUrl"
    value = var.gitlab_url
  }

  set_sensitive {
    name  = "runnerToken"
    value = var.gitlab_runner_token
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "runners.tags"
    value = var.gitlab_runner_tag
  }

  set {
    name  = "runners.locked"
    value = "false"
  }
}

resource "helm_release" "gitlab_agent" {
  name             = "gitlab-agent"
  repository       = "https://charts.gitlab.io"
  chart            = "gitlab-agent"
  namespace        = "gitlab-agent"
  create_namespace = true

  set_sensitive {
    name  = "config.token"
    value = var.gitlab_agent_token
  }

  set {
    name  = "config.kasAddress"
    value = "wss://kas.gitlab.com"
  }
}
