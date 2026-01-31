```bash
#Add Jenkins repo
helm repo add jenkins https://charts.jenkins.io

helm repo update

#Create namespace for Jenkins
kubectl create namespace jenkins

#Install Jenkins with ingress enabled
MSYS_NO_PATHCONV=1 helm upgrade --install jenkins jenkins/jenkins \
  --namespace jenkins --create-namespace \
  --set controller.serviceType=ClusterIP \
  --set controller.ingress.enabled=true \
  --set controller.ingress.hostName=jenkins.local \
  --set controller.ingress.annotations."nginx\.ingress\.kubernetes\.io/rewrite-target"=/ \
  --set controller.ingress.path=/ \
  --set controller.admin.username=admin \
  --set controller.admin.password=admin123 \
  --set persistence.enabled=false \
  --set controller.ingress.ingressClassName=nginx


kubectl get pods -n jenkins

kubectl get svc -n jenkins

kubectl get ingress -n jenkins

kubectl get ingress -n jenkins jenkins -oyaml

#Give Jenkins Access to the Cluster
kubectl create serviceaccount jenkins-sa -n jenkins

kubectl create clusterrolebinding jenkins-sa-binding \
  --clusterrole=cluster-admin \
  --serviceaccount=jenkins:jenkins-sa
```
```bash
$ kubectl get pod jenkins-0 -n jenkins -oyaml | grep -i serviceaccount
  automountServiceAccountToken: true
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
  serviceAccount: jenkins
  serviceAccountName: jenkins
      - serviceAccountToken:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
```
```bash
#Install plugins
1. HashiCorp Vault
2. Pipeline: Stage View

```