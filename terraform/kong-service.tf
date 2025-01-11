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

    port {
      name       = "proxy-ssl"
      port       = 443
      target_port = 8443
      node_port  = 30443
    }

    port {
      name       = "admin"
      port       = 8001
      target_port = 8001
      node_port  = 30001
    }

    port {
      name       = "admin-ssl"
      port       = 8444
      target_port = 8444
      node_port  = 30444
    }

    selector = {
      app = "kong"
    }
  }
}
