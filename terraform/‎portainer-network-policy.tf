resource "kubernetes_network_policy" "portainer_isolation" {
  metadata {
    name      = "portainer-isolation"
    namespace = "portainer"
  }

  spec {
    pod_selector {
      match_labels = {
        "app.kubernetes.io/name" = "portainer"
      }
    }

    ingress {
      from {
        pod_selector {
          match_labels = {
            "app.kubernetes.io/name" = "portainer-agent"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}
