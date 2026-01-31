```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

#Create namespace for ingress
kubectl create namespace ingress-nginx

#Install ingress-nginx via Helm
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.publishService.enabled=true \
  --set controller.replicaCount=1 \
  --set controller.service.type=LoadBalancer

kubectl get pods -n ingress-nginx

kubectl get svc -n ingress-nginx

kubectl logs -n ingress-nginx <ingress-nginx-controller-pod>
```