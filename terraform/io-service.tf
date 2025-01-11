resource "kubernetes_service" "io_service" {
  metadata {
    name      = "io-service"
    namespace = kubernetes_namespace_v1.multiple_namespaces["database"].metadata[0].name
  }

  spec {
    port {
      port        = 8000
      target_port = 8000
    }

    selector = {
      app = "io-service"
    }
  }
}
