resource "kubernetes_network_policy" "allow_database_to_monitoring" {
  metadata {
    name      = "allow-database-to-monitoring"
    namespace = kubernetes_namespace_v1.multiple_namespaces["database"].metadata[0].name
  }

  spec {
    pod_selector {}

    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = "monitoring"
          }
        }
      }

      ports {
        protocol = "TCP"
        port     = 8081
      }
    }

    policy_types = ["Ingress"]
  }
}
