resource "kubernetes_deployment" "mongoexpress" {
  metadata {
    name      = "mongoexpress"
    namespace = kubernetes_namespace_v1.multiple_namespaces["database"].metadata[0].name
    labels = {
      app = "mongoexpress"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mongoexpress"
      }
    }

    template {
      metadata {
        labels = {
          app = "mongoexpress"
        }
      }

      spec {
        container {
          name  = "mongoexpress"
          image = "mongo-express"

          port {
            container_port = 8081
          }

          env {
            name  = "ME_CONFIG_MONGODB_URL"
            value = "mongodb://mongo.database.svc.cluster.local:27017"
          }

          env {
            name  = "ME_CONFIG_BASICAUTH_USERNAME"
            value = "admin"
          }

          env {
            name  = "ME_CONFIG_BASICAUTH_PASSWORD"
            value = "admin"
          }
        }
      }
    }
  }
}
