resource "kubernetes_deployment" "checkout" {
  metadata {
    name = "checkout"
  }

  spec {
    selector {
      match_labels = {
        app = "checkout"
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
          app = "checkout"
        }
      }

      spec {
        container {
          name  = "checkout"
          image = "localhost.localstack.cloud:4511/checkout:latest"

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

resource "kubernetes_service" "checkout" {
  metadata {
    name = "checkout"
  }

  spec {
    selector = {
      app = "checkout"
    }

    port {
      port        = 80
      target_port = "http"
    }
  }
}

resource "kubernetes_ingress_v1" "checkout" {
  metadata {
    name = "checkout"
    annotations = {
      "ingress.kubernetes.io/ssl-redirect" = "false"
    }
  }

  spec {
    rule {
      host = "checkout.localhost.localstack.cloud"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "checkout"
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
