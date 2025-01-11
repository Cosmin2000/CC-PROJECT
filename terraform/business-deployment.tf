resource "kubernetes_deployment" "business_service" {
  metadata {
    name      = "business-service"
    namespace = kubernetes_namespace_v1.multiple_namespaces["appservices"].metadata[0].name
    labels = {
      app = "business-service"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "business-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "business-service"
        }
      }

      spec {
        container {
          name  = "business-service"
          image = "cgrigore0410/business-svc:latest"

          port {
            container_port = 6000
          }
        }
      }
    }
  }
}
