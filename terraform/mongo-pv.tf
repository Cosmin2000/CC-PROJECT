resource "kubernetes_persistent_volume" "mongo_pv" {
  metadata {
    name      = "mongo-pv"
  }

  spec {
    capacity = {
      storage = "2Gi"
    }

    access_modes = ["ReadWriteOnce"]
    storage_class_name = "standard"
    persistent_volume_source {
      host_path {
        path = "/root/mongo-data"
      }
    }
  }
}
