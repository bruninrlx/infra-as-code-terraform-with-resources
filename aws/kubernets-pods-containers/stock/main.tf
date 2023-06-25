resource "kubernetes_deployment" "stock" {
  metadata {
    name = "stock"
  }

  spec {
    selector {
      match_labels = {
        app = "stock"
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
          app = "stock"
        }
      }

      spec {
        container {
          name  = "stock"
          image = "localhost.localstack.cloud:4511/stock:latest"

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

resource "kubernetes_service" "stock" {
  metadata {
    name = "stock"
  }

  spec {
    selector = {
      app = "stock"
    }

    port {
      port        = 80
      target_port = "http"
    }
  }
}

resource "kubernetes_ingress_v1" "stock" {
  metadata {
    name = "stock"
    annotations = {
      "ingress.kubernetes.io/ssl-redirect" = "false"
    }
  }

  spec {
    rule {
      host = "stock.localhost.localstack.cloud"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "stock"
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
