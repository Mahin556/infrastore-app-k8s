resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = var.hashicorp_vault_helm_version

  namespace        = var.hashicorp_vault_namespace
  create_namespace = true

  set = [
    {
    name  = "server.dev.enabled"
    value = "true"
    }
  ]

  depends_on = [kind_cluster.default]
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  depends_on = [ helm_release.vault ]
}

data "kubernetes_client_config" "current" {}


resource "vault_kubernetes_auth_backend_config" "k8s" {
  backend            = vault_auth_backend.kubernetes.path
  kubernetes_host    = data.kubernetes_client_config.current.host
  kubernetes_ca_cert = base64decode(data.kubernetes_client_config.current.cluster_ca_certificate)
  token_reviewer_jwt = data.kubernetes_client_config.current.token
}

resource "vault_kv_secret_v2" "django_password" {
  mount = "secret"
  name  = "infrastore-app"

  data_json = jsonencode({
    DJANGO_SUPERUSER_PASSWORD = "secret123"
  })

  depends_on = [ vault_auth_backend.kubernetes ]
}