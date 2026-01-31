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
```bash
$ kubectl get all -n vault
NAME                                        READY   STATUS    RESTARTS   AGE
pod/vault-0                                 1/1     Running   0          75s
pod/vault-agent-injector-5b7dd85f5c-rdw7d   1/1     Running   0          76s

NAME                               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
service/vault                      ClusterIP   10.99.142.101   <none>        8200/TCP,8201/TCP   76s
service/vault-agent-injector-svc   ClusterIP   10.102.237.44   <none>        443/TCP             76s
service/vault-internal             ClusterIP   None            <none>        8200/TCP,8201/TCP   76s

NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/vault-agent-injector   1/1     1            1           76s

NAME                                              DESIRED   CURRENT   READY   AGE
replicaset.apps/vault-agent-injector-5b7dd85f5c   1         1         1       76s

NAME                     READY   AGE
statefulset.apps/vault   1/1     76s
```
```bash
kubectl get svc -n vault #Get vault service name http://vault.vault.svc.cluster.local:8200

kubectl logs vault-0 -n vault #Get root token

$ kubectl logs vault-0 -n vault | grep -i "Root Token:"
Root Token: root
```