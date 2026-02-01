terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.10.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "3.0.1"
    }

    helm = {
      source = "hashicorp/helm"
      version = "3.1.1"
    }

    null = {
      source = "hashicorp/null"
      version = "3.2.4"
    }
  }

  required_version = ">= 1.12.0"
}