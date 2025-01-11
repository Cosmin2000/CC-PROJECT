resource "kubernetes_persistent_volume" "portainer_pv" {
  metadata {
    name      = "portainer-pv"
  }

  spec {
    capacity = {
      storage = "24Gi"
    }

    access_modes = ["ReadWriteOnce"]
    storage_class_name = "generic"
    persistent_volume_source {
      host_path {
        path = "/root/portainer"
      }
    }
  }
}
