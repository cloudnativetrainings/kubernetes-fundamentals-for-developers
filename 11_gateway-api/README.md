
# Gateway API

## The Cluster Admin's Job

```bash
# install CRDs
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/standard-install.yaml
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.1/experimental-install.yaml

# install cilium as Gateway Class
helm repo add cilium https://helm.cilium.io/
helm repo update

helm upgrade --install cilium cilium/cilium -n kube-system \
  --atomic \
  --set kubeProxyReplacement=true \
  --set gatewayAPI.enabled=true

# verify
kubectl get gatewayclass
```

## The Platform Operator's Job

```bash
# install
kubectl apply -f k8s/gateway.yaml

# verify
kubectl get gateway
```

## The Devs' Job

```bash
# apply app
kubectl apply -f k8s/pod.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/httproute.yaml

# verify
kubectl get httproute my-app
curl http://172.18.0.6/my-app
```
