resource "kubernetes_service" "auth_service" {
  metadata {
    name      = "auth-service"
    namespace = kubernetes_namespace_v1.multiple_namespaces["appservices"].metadata[0].name
    
  }

  spec {
    port {
      port        = 4002
      target_port = 4002
    }

    selector = {
      app = "auth-service"
    }
  }
}
