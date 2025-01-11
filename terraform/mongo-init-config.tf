resource "kubernetes_config_map" "mongo_init_config" {
  metadata {
    name      = "mongo-init-config"
    namespace = kubernetes_namespace_v1.multiple_namespaces["database"].metadata[0].name
  }

  data = {
    "mongo-init.js" = file("${path.module}/../db/mongo-init.js")
  }
}
