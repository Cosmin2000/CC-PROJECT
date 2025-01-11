resource "kubernetes_service" "mongodb_service" {
  metadata {
    name      = "mongo"
    namespace = kubernetes_namespace_v1.multiple_namespaces["database"].metadata[0].name
    
  }

  spec {
    port {
      port        = 27017
      target_port = 27017
    }

    selector = {
      app = "mongo"
    }
  }
}
