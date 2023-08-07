variable "namespace" {
  default = "python"
  type    = string
}

//////////////////////// Provider
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.21.1"
    }
  }
}

provider "kubernetes" {
}

provider "aws" {
}

//////////////////////// Namespace
resource "kubernetes_namespace" "default" {
  metadata {
    name = var.namespace
  }
}

//////////////////////// Deployment

resource "kubernetes_deployment" "python_deploy" {
  depends_on = [
    kubernetes_namespace.default
  ]
  metadata {
    name      = "python"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        app = "python"
      }
    }
    replicas = 1
    template {
      metadata {
        labels = {
          app = "python"
        }
      }
      spec {
        container {
          name  = "python"
          image = "kevinorellana/python:v1"
          port {
            container_port = 5000
          }
          image_pull_policy = "Always"
        }
      }
    }
  }
}

//////////////////////// Service
resource "kubernetes_manifest" "python_service" {
  depends_on = [
    kubernetes_namespace.default,
  ]
  manifest = yamldecode(templatefile(
    "${path.module}/manifests/python-service.tpl.yaml",
    {
      "namespace" = var.namespace
    }
  ))
}

//////////////////////// Ingress
locals {
  ingress_host = kubernetes_manifest.python_ingress.spec[0].rule[0].host
}

output "ingress_host" {
  value = "https://local.ingress_host"
}


resource "kubernetes_manifest" "python_ingress" {
  depends_on = [
    kubernetes_namespace.default,
  ]
  manifest = yamldecode(templatefile(
    "${path.module}/manifests/python-ingress.tpl.yaml",
    {
      "namespace" = var.namespace
    }
  ))
}