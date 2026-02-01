```bash
# Add Helm repo where ingress controller chart lives
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# Update Helm repo index
helm repo update
helm repo list

# Install NGINX Ingress Controller
# This is the traffic router for the cluster
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.hostPort.enabled=true \
  --set controller.service.type=NodePort \
  --set-string controller.nodeSelector.ingress-ready="true" \
  --set controller.tolerations[0].key=node-role.kubernetes.io/control-plane \
  --set controller.tolerations[0].operator=Exists \
  --set controller.tolerations[0].effect=NoSchedule \
  --set controller.publishService.enabled=false \
  --set controller.extraArgs.publish-status-address=localhost

# --set controller.hostPort.enabled=true makes the NGINX Ingress pod bind directly to node ports 80 & 443.
# This bypasses normal Service routing (no need to go through ClusterIP → NodePort → Pod).
# Traffic flow becomes simpler:
# Client → Node IP:80/443 → Ingress Pod directly
# Used during Helm install/upgrade to override the chart default (which is false).
# Useful for local clusters (Kind, Minikube) where LoadBalancer doesn’t exist.
# Often combined with
# --set controller.kind=DaemonSet
# so one ingress pod runs on every node, ensuring those ports are available on each node.

# Wait until ingress controller pod becomes Ready
# Ensures routing layer is up before testing
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# Deploy a sample app + service + ingress rule
# This creates an example echo server
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/usage.yaml
#or
cat >> ingress-example.yaml << EOF
kind: Pod
apiVersion: v1
metadata:
  name: foo-app
  labels:
    app: foo
spec:
  containers:
  - command:
    - /agnhost
    - serve-hostname
    - --http=true
    - --port=8080
    image: registry.k8s.io/e2e-test-images/agnhost:2.39
    name: foo-app
---
kind: Service
apiVersion: v1
metadata:
  name: foo-service
spec:
  selector:
    app: foo
  ports:
  # Default port used by the image
  - port: 8080
---
kind: Pod
apiVersion: v1
metadata:
  name: bar-app
  labels:
    app: bar
spec:
  containers:
  - command:
    - /agnhost
    - serve-hostname
    - --http=true
    - --port=8080
    image: registry.k8s.io/e2e-test-images/agnhost:2.39
    name: bar-app
---
kind: Service
apiVersion: v1
metadata:
  name: bar-service
spec:
  selector:
    app: bar
  ports:
  # Default port used by the image
  - port: 8080
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
spec:
  rules:
  - http:
      paths:
      - pathType: Prefix
        path: /foo
        backend:
          service:
            name: foo-service
            port:
              number: 8080
      - pathType: Prefix
        path: /bar
        backend:
          service:
            name: bar-service
            port:
              number: 8080
---
EOF

kubectl apply -f ingress-example.yaml

# Test ingress routing
# Request goes: Browser → localhost → Ingress → Service → Pod
curl http://localhost/foo
# If working, you'll see a timestamp response from the pod
```