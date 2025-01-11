resource "kubernetes_service" "kong" {
  metadata {
    name      = "kong"
    namespace = kubernetes_namespace_v1.multiple_namespaces["monitoring"].metadata[0].name
    
  }

  spec {
    type = "NodePort"

    port {
      name       = "proxy"
      port       = 80
      target_port = 8000
      node_port  = 30080
    }

    selector = {
      app = "kong"
    }
  }
}
