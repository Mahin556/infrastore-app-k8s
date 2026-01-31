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

kubectl get all -n ingress-nginx

kubectl logs -n ingress-nginx <ingress-nginx-controller-pod>
```
```bash
$ kubectl get all -n ingress-nginx
NAME                                           READY   STATUS    RESTARTS   AGE
pod/ingress-nginx-controller-85f8c6fc9-7ccp9   1/1     Running   0          62s

NAME                                         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
service/ingress-nginx-controller             LoadBalancer   10.105.48.140   localhost     80:30836/TCP,443:32371/TCP   63s
service/ingress-nginx-controller-admission   ClusterIP      10.103.223.17   <none>        443/TCP                      63s

NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ingress-nginx-controller   1/1     1            1           63s

NAME                                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/ingress-nginx-controller-85f8c6fc9   1         1         1       62s
```