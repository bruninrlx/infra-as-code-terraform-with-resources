resource "kubernetes_deployment" "freight" {
  metadata {
    name = "freight"
  }

  spec {
    selector {
      match_labels = {
        app = "freight"
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
          app = "freight"
        }
      }

      spec {
        container {
          name  = "freight"
          image = "localhost.localstack.cloud:4511/freight:latest"

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

resource "kubernetes_service" "freight" {
  metadata {
    name = "freight"
  }

  spec {
    selector = {
      app = "freight"
    }

    port {
      port        = 80
      target_port = "http"
    }
  }
}

resource "kubernetes_ingress_v1" "freight" {
  metadata {
    name = "freight"
    annotations = {
      "ingress.kubernetes.io/ssl-redirect" = "false"
    }
  }

  spec {
    rule {
      host = "freight.localhost.localstack.cloud"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "freight"
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
