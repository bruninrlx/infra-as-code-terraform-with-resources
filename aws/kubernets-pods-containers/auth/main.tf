resource "kubernetes_deployment" "auth" {
  metadata {
    name = "auth"
  }

  spec {
    selector {
      match_labels = {
        app = "auth"
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
          app = "auth"
        }
      }

      spec {
        container {
          name  = "auth"
          image = "localhost.localstack.cloud:4511/auth:latest"

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

resource "kubernetes_service" "auth" {
  metadata {
    name = "auth"
  }

  spec {
    selector = {
      app = "auth"
    }

    port {
      port        = 80
      target_port = "http"
    }
  }
}

resource "kubernetes_ingress_v1" "auth" {
  metadata {
    name = "auth"
    annotations = {
      "ingress.kubernetes.io/ssl-redirect" = "false"
    }
  }

  spec {
    rule {
      host = "auth.localhost.localstack.cloud"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "auth"
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
