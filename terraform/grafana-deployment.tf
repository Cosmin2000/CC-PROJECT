resource "kubernetes_deployment" "grafana" {
  metadata {
    name      = "grafana"
    namespace =  kubernetes_namespace_v1.multiple_namespaces["monitoring"].metadata[0].name
    labels = {
      app = "grafana"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "grafana"
      }
    }

    template {
      metadata {
        labels = {
          app = "grafana"
        }
      }

      spec {

        init_container {
          name  = "init-permissions"
          image = "busybox"
          command = [
            "sh", "-c", "chmod -R 777 /grafana-pv"
          ]

          volume_mount {
            name      = "grafana-data"
            mount_path = "/grafana-pv"
          }
        }

        container {
          name  = "grafana"
          image = "grafana/grafana"

          port {
            container_port = 3000
          }

          volume_mount {
            name       = "grafana-data"
            mount_path = "/var/lib/grafana"
          }
        }

        volume {
          name = "grafana-data"

          persistent_volume_claim {
            claim_name = "grafana-pvc"
          }
        }
      }
    }
  }
}
