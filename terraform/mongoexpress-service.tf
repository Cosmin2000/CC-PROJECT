resource "kubernetes_service" "mongoexpress_service" {
  metadata {
    name      = "mongoexpress"
    namespace = kubernetes_namespace_v1.multiple_namespaces["database"].metadata[0].name
    
  }

  spec {
    port {
      port        = 8081
      target_port = 8081
    }

    selector = {
      app = "mongoexpress"
    }
  }
}
