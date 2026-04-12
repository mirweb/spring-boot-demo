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

resource "helm_release" "traefik" {
  name             = "traefik"
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  namespace        = "traefik"
  create_namespace = true

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "ingressClass.enabled"
    value = "true"
  }

  set {
    name  = "ingressClass.isDefaultClass"
    value = "true"
  }

  set {
    name  = "ports.web.http.redirections.entryPoint.to"
    value = "websecure"
  }

  set {
    name  = "ports.web.http.redirections.entryPoint.scheme"
    value = "https"
  }

  set {
    name  = "api.dashboard"
    value = "true"
  }

  set {
    name  = "api.insecure"
    value = "true"
  }
}

resource "kubernetes_manifest" "traefik_dashboard_ingressroute" {
  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind       = "IngressRoute"
    metadata = {
      name      = "traefik-dashboard"
      namespace = "traefik"
    }
    spec = {
      entryPoints = ["websecure"]
      routes = [
        {
          match = "Host(`traefik.k8s.orb.local`)"
          kind  = "Rule"
          services = [
            {
              name = "api@internal"
              kind = "TraefikService"
            }
          ]
        }
      ]
      tls = {
        secretName = "wildcard-k8s-orb-local-tls"
      }
    }
  }

  depends_on = [helm_release.traefik]
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "loki" {
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false

  values = [<<-EOT
    deploymentMode: SingleBinary
    loki:
      auth_enabled: false
      commonConfig:
        replication_factor: 1
      storage:
        type: filesystem
      limits_config:
        retention_period: 2160h
      compactor:
        retention_enabled: true
        delete_request_store: filesystem
      schemaConfig:
        configs:
          - from: "2024-01-01"
            store: tsdb
            object_store: filesystem
            schema: v13
            index:
              prefix: loki_index_
              period: 24h
    singleBinary:
      replicas: 1
    backend:
      replicas: 0
    read:
      replicas: 0
    write:
      replicas: 0
    # Disable Memcached caches — not needed for local dev and require
    # memory resources the single-node OrbStack cluster cannot provide.
    chunksCache:
      enabled: false
    resultsCache:
      enabled: false
  EOT
  ]

  timeout    = 600
  depends_on = [kubernetes_namespace.monitoring]
}

resource "helm_release" "promtail" {
  name             = "promtail"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "promtail"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false

  set {
    name  = "config.clients[0].url"
    value = "http://loki.${kubernetes_namespace.monitoring.metadata[0].name}.svc.cluster.local:3100/loki/api/v1/push"
  }

  depends_on = [helm_release.loki]
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false

  values = [<<-EOT
    datasources:
      datasources.yaml:
        apiVersion: 1
        datasources:
          - name: Loki
            type: loki
            url: http://loki.${kubernetes_namespace.monitoring.metadata[0].name}.svc.cluster.local:3100
            access: proxy
            isDefault: true
    grafana.ini:
      server:
        root_url: https://grafana.k8s.orb.local
    ingress:
      enabled: false
  EOT
  ]

  depends_on = [helm_release.loki]
}

resource "kubernetes_manifest" "grafana_ingressroute" {
  manifest = {
    apiVersion = "traefik.io/v1alpha1"
    kind       = "IngressRoute"
    metadata = {
      name      = "grafana"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
    }
    spec = {
      entryPoints = ["websecure"]
      routes = [
        {
          match = "Host(`grafana.k8s.orb.local`)"
          kind  = "Rule"
          services = [
            {
              name = "grafana"
              port = 80
            }
          ]
        }
      ]
      tls = {
        secretName = "wildcard-k8s-orb-local-tls"
      }
    }
  }

  depends_on = [helm_release.grafana]
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
