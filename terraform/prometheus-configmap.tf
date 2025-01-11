resource "kubernetes_config_map" "prometheus-configmap" {
  metadata {
    name      = "prometheus-configmap"
    namespace = kubernetes_namespace_v1.multiple_namespaces["monitoring"].metadata[0].name
  }

  data = {
    "prometheus.yml" = file("${path.module}/../Prometheus/prometheus.yml")
  }
}
