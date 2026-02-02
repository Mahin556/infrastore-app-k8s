provider "helm" {
  kubernetes = {
    config_path = pathexpand(var.kind_cluster_config_path)
  }
}

provider "vault" {
  address = "http://vault.vault.svc.cluster.local:8200"
  token   = "root"   # dev mode root token
}

provider "kind" {
}

provider "kubernetes" {
  config_path = pathexpand(var.kind_cluster_config_path)
}