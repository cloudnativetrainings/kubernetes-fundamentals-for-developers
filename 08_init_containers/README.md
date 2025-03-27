# Init Containers

Init containers can contain utilities or setup scripts not present in an app image.

Change into the lab directory:

```bash
cd 08_init_containers
```

## Deploy apps

First, check the pod definitions:

```bash
cat k8s/pod-A.yaml
cat k8s/pod-B.yaml
```

```bash
# [TERMINAL-1] create the pod A
kubectl create -f k8s/pod-A.yaml

# [TERMINAL-1] check the status, you will see that it's in `Init` state:
kubectl get pods

# output:
#NAME    READY   STATUS     RESTARTS   AGE
#pod-a   0/1     Init:0/1   0          4s

# [TERMINAL-1] check the logs for the init container:
kubectl logs pod-a -c wait-for-pod-b -f

# [TERMINAL-2] now, create the `pod-b` and it's service
kubectl create -f k8s/pod-B.yaml
kubectl create -f k8s/service-B.yaml
```

> You will see the ready message on the other terminal!

## Cleanup

Remove the pods and the service:

```bash
kubectl delete -f k8s/
```
