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
```yaml
#https://github.com/jenkinsci/kubernetes-plugin/blob/master/src/main/kubernetes/service-account.yml
# In GKE need to get RBAC permissions first with
# kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin [--user=<user-name>|--group=<group-name>]

---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins

---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: jenkins
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["create","delete","get","list","patch","update","watch"]
- apiGroups: [""]
  resources: ["pods/exec"]
  verbs: ["create","delete","get","list","patch","update","watch"]
- apiGroups: [""]
  resources: ["pods/log"]
  verbs: ["get","list","watch"]
- apiGroups: [""]
  resources: ["events"]
  verbs: ["watch"]
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: jenkins
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: jenkins
subjects:
- kind: ServiceAccount
  name: jenkins
```