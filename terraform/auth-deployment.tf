resource "kubernetes_deployment" "auth_service" {
  metadata {
    name      = "auth-service"
    namespace = kubernetes_namespace_v1.multiple_namespaces["appservices"].metadata[0].name
    labels = {
      app = "auth-service"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "auth-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "auth-service"
        }
      }

      spec {
        container {
          name  = "auth-service"
          image = "cgrigore0410/auth-sv:latest"

          port {
            container_port = 4002
          }
        }
      }
    }
  }
}
