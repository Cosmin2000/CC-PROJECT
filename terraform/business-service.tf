resource "kubernetes_service" "business_service" {
  metadata {
    name      = "business-service"
    namespace = kubernetes_namespace_v1.multiple_namespaces["appservices"].metadata[0].name
   
  }

  spec {
    port {
      port        = 6000
      target_port = 6000
    }

    selector = {
      app = "business-service"
    }
  }
}
