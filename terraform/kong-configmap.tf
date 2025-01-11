resource "kubernetes_config_map" "kong_configmap" {
  metadata {
    name      = "kong-configmap"
    namespace = kubernetes_namespace_v1.multiple_namespaces["monitoring"].metadata[0].name
  }

  data = {
    "kong.yml" = file("${path.module}/../Kong/kong.yml")
  }
}
