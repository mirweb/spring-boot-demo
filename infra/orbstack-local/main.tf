resource "kubernetes_namespace" "gitlab_runner" {
  metadata {
    name = "gitlab-runner"
  }
}

resource "kubernetes_persistent_volume_claim" "maven_cache" {
  metadata {
    name      = "maven-cache"
    namespace = kubernetes_namespace.gitlab_runner.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
  wait_until_bound = false
}

resource "kubernetes_persistent_volume_claim" "npm_cache" {
  metadata {
    name      = "npm-cache"
    namespace = kubernetes_namespace.gitlab_runner.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "2Gi"
      }
    }
  }
  wait_until_bound = false
}

resource "helm_release" "gitlab_runner" {
  name             = "gitlab-runner"
  repository       = "https://charts.gitlab.io"
  chart            = "gitlab-runner"
  namespace  = kubernetes_namespace.gitlab_runner.metadata[0].name

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

  set {
    name  = "runners.config"
    value = <<-EOT
      [[runners]]
        [runners.kubernetes]
          helper_image = "registry.gitlab.com/gitlab-org/gitlab-runner/gitlab-runner-helper:arm64-v18.10.0"
          pull_policy = ["if-not-present"]
          [runners.kubernetes.node_selector]
            "kubernetes.io/arch" = "arm64"
          [[runners.kubernetes.volumes.pvc]]
            name = "maven-cache"
            mount_path = "/root/.m2"
          [[runners.kubernetes.volumes.pvc]]
            name = "npm-cache"
            mount_path = "/root/.npm"
    EOT
  }

  depends_on = [
    kubernetes_persistent_volume_claim.maven_cache,
    kubernetes_persistent_volume_claim.npm_cache,
  ]
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
