resource "kubernetes_persistent_volume_claim" "grafana_pvc" {
  metadata {
    name      = "grafana-pvc"
    namespace = kubernetes_namespace_v1.multiple_namespaces["monitoring"].metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }

    storage_class_name = "standard"

    volume_name = kubernetes_persistent_volume.grafana_pv.metadata[0].name
  }

}
