resource "kubernetes_deployment" "io_service" {
  metadata {
    name      = "io-service"
    namespace = kubernetes_namespace_v1.multiple_namespaces["database"].metadata[0].name
    labels = {
      app = "io-service"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "io-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "io-service"
        }
      }

      spec {
        container {
          name  = "io-service"
          image = "registry.gitlab.com/proiect-idp-weather-app-c1/ioservice:latest"

          port {
            container_port = 8000
          }
        }
      }
    }
  }
}
