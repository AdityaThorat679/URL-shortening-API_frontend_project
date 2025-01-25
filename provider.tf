terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.35.1"
    }
     local = {
      source = "hashicorp/local"
      version = "2.5.2"
    }
  }
}
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}
