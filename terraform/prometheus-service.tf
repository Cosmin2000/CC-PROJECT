resource "kubernetes_service" "prometheus_service" {
  metadata {
    name      = "prometheus"
    namespace = kubernetes_namespace_v1.multiple_namespaces["monitoring"].metadata[0].name
  }

  spec {
    port {
      port        = 9090
      target_port = 9090
    }

    selector = {
      app = "prometheus"
    }
  }
}
