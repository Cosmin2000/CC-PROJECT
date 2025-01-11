resource "kubernetes_network_policy" "allow_monitoring_to_app_services" {
  metadata {
    name      = "allow-monitoring-to-app-services"
    namespace = "monitoring"
  }

  spec {
    pod_selector {}

    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = "app-services"
          }
        }
      }

      ports {
        protocol = "TCP"
        port     = 6000
      }

      ports {
        protocol = "TCP"
        port     = 4002
      }
    }

    policy_types = ["Ingress"]
  }
}
