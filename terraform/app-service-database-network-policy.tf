resource "kubernetes_network_policy" "allow_app_services_to_database" {
  metadata {
    name      = "allow-app-services-to-database"
    namespace = "appservices"
  }

  spec {
    pod_selector {}

    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = "database"
          }
        }
      }

      ports {
        protocol = "TCP"
        port     = 27017
      }

      ports {
        protocol = "TCP"
        port     = 8000
      }
    }

    policy_types = ["Ingress"]
  }
}
