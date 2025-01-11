resource "kubernetes_namespace" "portainer" {
  metadata {
    name = "portainer"
  }
}

resource "kubernetes_service_account" "portainer_sa" {
  metadata {
    name      = "portainer-sa-clusteradmin"
    namespace = kubernetes_namespace.portainer.metadata[0].name
    labels = {
      "app.kubernetes.io/name"     = "portainer"
      "app.kubernetes.io/instance" = "portainer"
      "app.kubernetes.io/version"  = "ce-latest-ee-2.16.2"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "portainer_pvc" {
  metadata {
    name      = "portainer"
    namespace = kubernetes_namespace.portainer.metadata[0].name
    #annotations = {
    #  "volume.alpha.kubernetes.io/storage-class" = "generic"
    #}
    labels = {
      "io.portainer.kubernetes.application.stack" = "portainer"
      "app.kubernetes.io/name"                    = "portainer"
      "app.kubernetes.io/instance"                = "portainer"
      "app.kubernetes.io/version"                 = "ce-latest-ee-2.16.2"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "generic"
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}


resource "kubernetes_cluster_role_binding" "portainer" {
  metadata {
    name = "portainer"
    labels = {
      "app.kubernetes.io/name"     = "portainer"
      "app.kubernetes.io/instance" = "portainer"
      "app.kubernetes.io/version"  = "ce-latest-ee-2.16.2"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.portainer_sa.metadata[0].name
    namespace = kubernetes_service_account.portainer_sa.metadata[0].namespace
  }
}

resource "kubernetes_service" "portainer" {
  metadata {
    name      = "portainer"
    namespace = kubernetes_namespace.portainer.metadata[0].name
    labels = {
      "io.portainer.kubernetes.application.stack" = "portainer"
      "app.kubernetes.io/name"                    = "portainer"
      "app.kubernetes.io/instance"                = "portainer"
      "app.kubernetes.io/version"                 = "ce-latest-ee-2.16.2"
    }
  }

  spec {
    type = "NodePort"

    port {
      port        = 9000
      target_port = 9000
      protocol    = "TCP"
      name        = "http"
      node_port   = 30777
    }

    port {
      port        = 9443
      target_port = 9443
      protocol    = "TCP"
      name        = "https"
      node_port   = 30779
    }

    port {
      port        = 30776
      target_port = 30776
      protocol    = "TCP"
      name        = "edge"
      node_port   = 30776
    }

    selector = {
      "app.kubernetes.io/name"     = "portainer"
      "app.kubernetes.io/instance" = "portainer"
    }
  }
}

resource "kubernetes_deployment" "portainer" {
  metadata {
    name      = "portainer"
    namespace = kubernetes_namespace.portainer.metadata[0].name
    labels = {
      "io.portainer.kubernetes.application.stack" = "portainer"
      "app.kubernetes.io/name"                    = "portainer"
      "app.kubernetes.io/instance"                = "portainer"
      "app.kubernetes.io/version"                 = "ce-latest-ee-2.16.2"
    }
  }

  spec {
    replicas = 1
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        "app.kubernetes.io/name"     = "portainer"
        "app.kubernetes.io/instance" = "portainer"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name"     = "portainer"
          "app.kubernetes.io/instance" = "portainer"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.portainer_sa.metadata[0].name

        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.portainer_pvc.metadata[0].name
          }
        }

        container {
          name  = "portainer"
          image = "portainer/portainer-ce:2.16.2"
          args  = ["--tunnel-port=30776"]

          volume_mount {
            name      = "data"
            mount_path = "/data"
          }

          port {
            name          = "http"
            container_port = 9000
          }
          port {
            name          = "https"
            container_port = 9443
          }
          port {
            name          = "tcp-edge"
            container_port = 8000
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 9443
              scheme = "HTTPS"
            }
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 9443
              scheme = "HTTPS"
            }
          }

          resources {}
        }
      }
    }
  }
}
