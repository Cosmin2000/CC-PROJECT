resource "kubernetes_deployment" "kong" {
  metadata {
    name      = "kong"
    namespace = kubernetes_namespace_v1.multiple_namespaces["monitoring"].metadata[0].name
    labels = {
      app = "kong"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "kong"
      }
    }

    template {
      metadata {
        labels = {
          app = "kong"
        }
      }

      spec {
        container {
          name  = "kong"
          image = "kong:latest"

          port {
            container_port = 8000
          }

          port {
            container_port = 8443
          }

          port {
            container_port = 8001
          }

          port {
            container_port = 8444
          }

          volume_mount {
            name       = "kong-config"
            mount_path = "/usr/local/kong/declarative/kong.yml"
            sub_path   = "kong.yml"
          }

          env {
            name  = "KONG_DATABASE"
            value = "off"
          }

          env {
            name  = "KONG_DECLARATIVE_CONFIG"
            value = "/usr/local/kong/declarative/kong.yml"
          }

          env {
            name  = "KONG_PROXY_ACCESS_LOG"
            value = "/dev/stdout"
          }

          env {
            name  = "KONG_ADMIN_ACCESS_LOG"
            value = "/dev/stdout"
          }

          env {
            name  = "KONG_PROXY_ERROR_LOG"
            value = "/dev/stderr"
          }

          env {
            name  = "KONG_ADMIN_ERROR_LOG"
            value = "/dev/stderr"
          }

          env {
            name  = "KONG_ADMIN_LISTEN"
            value = "0.0.0.0:8001, 0.0.0.0:8444 ssl"
          }
        }

        volume {
          name = "kong-config"

          config_map {
            name = "kong-configmap"
          }
        }
      }
    }
  }
}
