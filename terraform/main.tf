terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "~> 0.5.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.35"
    }
  }
}

provider "kind" {}

resource "kind_cluster" "default" {
  name           = "kind"
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      extra_port_mappings {
        container_port = 30080
        host_port      = 30080
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30443
        host_port      = 30443
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30001
        host_port      = 30001
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30444
        host_port      = 30444
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30777
        host_port      = 30777
        protocol       = "TCP"
      }
    }

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }
  }
}



provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "kind-kind"
}

resource "kubernetes_namespace_v1" "multiple_namespaces" {
  for_each = toset(["appservices", "database", "monitoring"])

  metadata {
    name = each.value
  }
}


resource "null_resource" "export_kubeconfig" {
  provisioner "local-exec" {
    command = "kind export kubeconfig --name kind"
  }

  depends_on = [kind_cluster.default]
}