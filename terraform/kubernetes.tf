resource "kubernetes_namespace" "app" {
  metadata {
    name = "devops-app"
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = "devops-app"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = "devops-app"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "devops-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "devops-app"
        }
      }
      spec {
        container {
          name  = "devops-app"
          image = "${aws_ecr_repository.repo.repository_url}:latest"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = "devops-app-service"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    selector = {
      app = "devops-app"
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 80
    }
  }
}
