# Kustomize Configuration

## Inspect the Layout

> INGRESS_IP environment variable is supposed to be set during the setup. You can always set it this way:
>
> ```bash
> export INGRESS_IP=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[].ip}')
> ```

```bash
cd /workspaces/kubernetes-fundamentals-for-devs/03_kustomize
tree .
```

You will see that, there are 2 directories: base and overlay. Under overlay, there is dev and prod, which are configured to deploy on different namespaces on the cluster.

## Inspect base kustomization.yaml

```bash
cat base/kustomization.yaml
```

- Add label app=demo to all the resources created.
- Include manifests for deployment, service, and ingress

## Inspect dev overlay kustomization.yaml

```bash
cat overlays/dev/kustomization.yaml
```

- Get all resources from base
- Add environment=dev label to all resources created
- Add namespace=dev to all resources created
- Patch ingress to change the URL path
- Generate a ConfigMap for the index.html
- Patch deployment to use a different NGINX image

## Inspect prod overlay kustomization.yaml

```bash
cat overlays/prod/kustomization.yaml
```

- Get all resource from and and configmap.yaml from the current directory
- Add environment=prod label to all resources created
- Annotate all resources created with managed-by=kustomize
- Add namespace=prod to all resources created
- Patch deployment to have 3 replicas
- Patch ingress to change the URL path
- Patch deployment to use different Pod resources

# Deploy using Kustomize

## Create Namespaces

In this demo, we assume the `dev` and `prod` workloads are deployed on the respective namespaces:

```bash
kubectl create namespace dev
kubectl create namespace prod
```

## Deploy dev

First, inspect the generated manifest:

```bash
kustomize build overlays/dev
```

You can have 2 options to deploy:

1. Kustomize CLI:
```bash
kustomize build overlays/dev | kubectl apply -f -
```

2. Kubectl:
```bash
kubectl apply -k overlays/dev
```

Checkout the pods and verify that the application is running:

```bash
# Wait until the pod is ready:
kubectl get pods -n dev
```

Access the page via curl or your browser: 
```bash
curl http://${INGRESS_IP}/dev
```

If you want to reach it via browser, you first need to port-forward ingress-nginx-controller service:

```bash
kubectl port-forward svc/ingress-nginx-controller -n ingress-nginx 80
```

Then, reach via below URLs:

```bash
echo "https://${CODESPACE_NAME}-80.app.github.dev/dev"
```

## Deploy prod

First, inspect the generated manifest:

```bash
kustomize build overlays/prod
```

Deploy:

```bash
kubectl apply -k overlays/prod
```

Checkout the pods and verify that the application is running. There must be 3 pods running.

```bash
# Wait until the pod is ready:
kubectl get pods -n prod
```

```bash
curl http://${INGRESS_IP}/prod
```

If you want to reach it via browser, you first need to port-forward ingress-nginx-controller service:

```bash
kubectl port-forward svc/ingress-nginx-controller -n ingress-nginx 80
```

Then, reach via below URLs:

```bash
echo "https://${CODESPACE_NAME}-80.app.github.dev/prod"
```

# Cleanup

```bash
# delete the deployments:
kubectl delete -k overlays/dev
kubectl delete -k overlays/prod

# delete the namespaces:
kubectl delete namespace dev
kubectl delete namespace prod
```
