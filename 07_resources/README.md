# Resource Limits

In this lab, you will learn about resource limits. The application implements a CPU and a Memory leak.

Change into the lab directory:

```bash
cd 07_resources
```

## Create the Pod

Inspect pod.yaml definition file and create the pod

```bash
cat k8s/pod.yaml
kubectl create -f k8s/pod.yaml
```

## Leaking CPU

Learn what happens when your application reaches its CPU limits.

```bash
# [TERMINAL-1] check what is happening with the Pod.
watch -n 1 kubectl top pods

# [TERMINAL-2] attach to the application
kubectl attach -it my-app

# [TERMINAL-2] engage the CPU leak
leak cpu
```

> [!IMPORTANT]
> Note that the Container does not get restarted. The amount of CPU is limited to 30 MilliCores.

## Leaking Memory

Learn what happens when your application reaches its Memory limits.

```bash
# [TERMINAL-1] restart the Pod
kubectl delete pod my-app --force --grace-period=0
kubectl apply -f k8s/pod.yaml

# [TERMINAL-1] check what is happening with the Pod.
watch -n 1 kubectl top pods

# [TERMINAL-2] attach to the application
kubectl attach -it my-app

# [TERMINAL-2] engage the Memory Leak
leak mem

# [TERMINAL-1] after the Container gets restarted (~ 10 seconds) you see this in the RESTARTS column of
kubectl get pods

# The reason for the last restart (=OOMKilled) you can find out via the following command
kubectl get pod my-app -o jsonpath='{.status.containerStatuses[0].lastState}' | jq
```

## Cleanup

Delete the created resources.

```bash
kubectl delete -f k8s/ --grace-period=0
```
