```bash
#Install HashiCorp Vault (Dev Mode) and Add Django Password
#Add Vault Helm repo
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo list

#Create Vault namespace
kubectl create namespace vault

#Install Vault in dev mode
helm install -n vault vault hashicorp/vault --set "server.dev.enabled=true"

helm get manifest vault -n vault
helm status vault -n vault
helm ls -n vault

kubectl get pods -n vault
# NAME                                    READY   STATUS    RESTARTS   AGE
# vault-0                                 1/1     Running   0          5m37s
# vault-agent-injector-5b7dd85f5c-snbld   1/1     Running   0          5m37s

#Enable Kubernetes authentication in Vault
kubectl exec -it vault-0 -n vault -- vault auth enable kubernetes

#Configure Kubernetes auth with the cluster's API server
kubectl exec -it vault-0 -n vault -- sh -c 'vault write auth/kubernetes/config kubernetes_host=https://$KUBERNETES_PORT_443_TCP_ADDR:443'


#Store Django superuser password
kubectl exec -it vault-0 -n vault -- vault kv put secret/infrastore-app DJANGO_SUPERUSER_PASSWORD=secret123
```