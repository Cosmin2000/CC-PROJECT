resource "kubernetes_deployment" "mongodb" {
  metadata {
    name      = "mongo"
    namespace = kubernetes_namespace_v1.multiple_namespaces["database"].metadata[0].name
    labels = {
      app = "mongo"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mongo"
      }
    }

    template {
      metadata {
        labels = {
          app = "mongo"
        }
      }

      spec {
        container {
          name  = "mongo"
          image = "mongo:4.4.18"

          port {
            container_port = 27017
          }

          volume_mount {
            name       = "mongo-data"
            mount_path = "/data/db"
          }

          volume_mount {
            name       = "mongo-init-script"
            mount_path = "/docker-entrypoint-initdb.d/mongo-init.js"
            sub_path   = "mongo-init.js"
          }
        }

        volume {
          name = "mongo-data"

          persistent_volume_claim {
            claim_name = "mongo-pvc"
          }
        }

        volume {
          name = "mongo-init-script"

          config_map {
            name = "mongo-init-config"
          }
        }
      }
    }
  }
}
