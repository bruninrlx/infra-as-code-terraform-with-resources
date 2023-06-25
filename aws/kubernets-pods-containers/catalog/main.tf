resource "kubernetes_deployment" "catalog" {
  metadata {
    name = "catalog"
  }

  spec {
    selector {
      match_labels = {
        app = "catalog"
      }
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = 1
        max_unavailable = 1
      }
    }

    template {
      metadata {
        labels = {
          app = "catalog"
        }
      }

      spec {
        container {
          name  = "catalog"
          image = "localhost.localstack.cloud:4511/catalog:latest"

          env {
            name  = "PORT"
            value = "80"
          }

          port {
            container_port = 80
            name           = "http"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "catalog" {
  metadata {
    name = "catalog"
  }

  spec {
    selector = {
      app = "catalog"
    }

    port {
      port        = 80
      target_port = "http"
    }
  }
}

resource "kubernetes_ingress_v1" "catalog" {
  metadata {
    name = "catalog"
    annotations = {
      "ingress.kubernetes.io/ssl-redirect" = "false"
    }
  }

  spec {
    rule {
      host = "catalog.localhost.localstack.cloud"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "catalog"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
