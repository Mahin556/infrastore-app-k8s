```bash
cat >> kind-config.yaml <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
EOF

# Create a local Kubernetes cluster inside Docker
# Kind = "Kubernetes in Docker"
kind create cluster --name demo --config kind-config.yaml


# Show cluster API endpoint info
# Confirms kubectl is connected
kubectl cluster-info

# Delete cluster when done
# Removes Docker containers + cluster
kind delete cluster --name demo
```

```bash
$ kind create cluster --name demo --config kind-config.yaml
Creating cluster "demo" ...
 • Ensuring node image (kindest/node:v1.35.0) 🖼  ...
 ✓ Ensuring node image (kindest/node:v1.35.0) 🖼
 • Preparing nodes 📦 📦   ...
 ✓ Preparing nodes 📦 📦 
 • Writing configuration 📜  ...
 ✓ Writing configuration 📜
 • Starting control-plane 🕹️  ...
 ✓ Starting control-plane 🕹️
 • Installing CNI 🔌  ...
 ✓ Installing CNI 🔌
 • Installing StorageClass 💾  ...
 ✓ Installing StorageClass 💾
 • Joining worker nodes 🚜  ...
 ✓ Joining worker nodes 🚜
Set kubectl context to "kind-demo"
You can now use your cluster with:

kubectl cluster-info --context kind-demo

Have a nice day! 👋

$ kubectl cluster-info
Kubernetes control plane is running at https://127.0.0.1:61095
CoreDNS is running at https://127.0.0.1:61095/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```