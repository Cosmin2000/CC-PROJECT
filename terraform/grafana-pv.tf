resource "kubernetes_persistent_volume" "grafana_pv" {
  metadata {
    name = "grafana-pv"
  }

  spec {
    capacity = {
      storage = "1Gi"
    }

    access_modes = ["ReadWriteOnce"]

    storage_class_name = "standard"

    persistent_volume_source {
      host_path {
        path = "/root/grafana-pv"
      }
    }
  }
}
