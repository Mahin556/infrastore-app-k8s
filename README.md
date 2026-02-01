```bash
kubectl create secret docker-registry regcred \
  --docker-username=user \
  --docker-password=pass \
  --docker-server=docker.io

helm upgrade --install infra ./chart

helm install app . --set storageClass.enabled=false

helm upgrade --install infra-app . \
  --namespace app-ns
kubectl get pods -n app-ns
kubectl logs <pod-name> -n app-ns
kubectl describe pod <pod-name> -n app-ns
kubectl get ingress -n app-ns

ping infrastore.local
ipconfig /flushdns
C:\Windows\System32\drivers\etc\hosts

kubectl exec -it deploy/demo-infrastore-deployment -- python manage.py shell
  from django.contrib.auth.models import User
  User.objects.all()

kubectl exec -it deploy/demo-infrastore-deployment -- python manage.py createsuperuser
username: admin
password: secret23

echo '127.0.0.1 infrastore.local' >> /etc/hosts

$ curl -X POST http://infrastore.local/api/token/   -H "Content-Type: application/json"   -d '{"username":"admin","password":"secret123"}'
{"token":"19542a15d5b52f46562613c302fa1a975064fc75"}

echo "hello from infrastore app" > demo.txt

curl -X POST http://infrastore.local/api/upload/ \
  -H "Authorization: Token 19542a15d5b52f46562613c302fa1a975064fc75" \
  -F "file=@demo.txt"

curl -X GET http://infrastore.local/api/files/ \
  -H "Authorization: Token 19542a15d5b52f46562613c302fa1a975064fc75"

kubectl exec -it demo-infrastore-deployment-7d84d65c75-6kw95 -- ls //app/media/uploads
kubectl exec -it demo-infrastore-deployment-7d84d65c75-6kw95 -- cat //app/media/uploads/demo.txt

curl -X DELETE http://infrastore.local/api/files/1/ \
  -H "Authorization: Token 19542a15d5b52f46562613c302fa1a975064fc75"

DJANGO_PASSWORD=secret123

helm upgrade --install testapp infrastore \
  --namespace appns --create-namespace \
  --set-string secret.DJANGO_SUPERUSER_PASSWORD="$DJANGO_PASSWORD"
```


### References:
* https://kind.sigs.k8s.io/docs/user/quick-start/
* https://registry.terraform.io/providers/tehcyx/kind/latest/docs
* https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
* https://registry.terraform.io/providers/hashicorp/helm/latest/docs
* https://registry.terraform.io/providers/hashicorp/null/latest/docs
* https://nickjanetakis.com/blog/configuring-a-kind-cluster-with-nginx-ingress-using-terraform-and-helm