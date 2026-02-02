terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.10.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.24.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "3.1.1"
    }

    null = {
      source = "hashicorp/null"
      version = "3.2.4"
    }

    vault = {
      source = "hashicorp/vault"
      version = "5.6.0"
    }
  }

  required_version = ">= 1.12.0"
}