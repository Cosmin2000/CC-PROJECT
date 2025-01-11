resource "kubernetes_service" "grafana_service" {
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace_v1.multiple_namespaces["monitoring"].metadata[0].name
   
  }

  spec {
    port {
      port        = 3000
      target_port = 3000
    }

    selector = {
      app = "grafana"
    }
  }
}
