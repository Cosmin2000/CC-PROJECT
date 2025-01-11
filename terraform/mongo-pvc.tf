resource "kubernetes_persistent_volume_claim" "mongo_pvc" {
  metadata {
    name      = "mongo-pvc"
    namespace = kubernetes_namespace_v1.multiple_namespaces["database"].metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "2Gi"
      }
    }
    storage_class_name = "standard"
    volume_name = kubernetes_persistent_volume.mongo_pv.metadata[0].name
  }
}
