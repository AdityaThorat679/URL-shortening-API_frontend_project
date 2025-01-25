resource "kubernetes_namespace" "example" {
  metadata {
    name = "terraform"
  }
}
resource "kubernetes_deployment" "example" {
  metadata {
    name = "url"
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      app = "url"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "url"
      }
    }

    template {
      metadata {
        labels = {
          app = "url"
        }
      }

      spec {
        container {
          image = "adityathorat679/url_short:latest"
          name  = "url"

          resources {
            limits = {
              cpu    = "0.25"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "nginx" {
  metadata {
    name      = "url"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.example.spec[0].template[0].metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}


resource "kubernetes_ingress_v1" "example" {
  metadata {
    name      = "url-ingress"
    namespace = kubernetes_namespace.example.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = "nginx"  

    rule {
      host = "url-shortener.local"  
      http {
        path {
          path = "/" 
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.nginx.metadata[0].name
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

# resource "null_resource" "update_hosts" {
#   provisioner "local-exec" {
#     command = << EOT
#       MINIKUBE_IP=$(minikube ip)
#       HOST_ENTRY="$MINIKUBE_IP url-hosting.com"
#       if ! grep -q "$HOST_ENTRY" /etc/hosts; then
#         echo "$HOST_ENTRY" | sudo tee -a /etc/hosts
#       else
#         echo "Host entry already exists"
#       fi
#     EOT
#   }
# }


resource "null_resource" "run_local_script" {
  provisioner "local-exec" {
    command = "bash scrip.sh"
  }
}