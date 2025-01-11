resource "kubernetes_service" "grafana_service" {
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace_v1.multiple_namespaces["monitoring"].metadata[0].name
   
  }

  spec {
    type = "NodePort"
    port {
      port        = 3000
      target_port = 3000
      node_port  = 30444
    }

    selector = {
      app = "grafana"
    }
  }
}
