# There may be Dragons

Although you taught Kubernetes about the proper period of time to do a graceful shutdown data loss can still happen.

In this lab you will learn about a possible reason for data loss.

Change into the lab directory:

```bash
cd 06_graceful_shutdown_dragons
```

## Create the Pods

Inspect pod-A.yaml and pod-B.yaml definition files and create the pods.

```bash
cat k8s/pod-A.yaml
cat k8s/pod-B.yaml
kubectl create -f k8s/
kubectl get pods
```

> [!NOTE]
> Note that the Applications and the yaml Manifests are exactly the same.

## Watch the log files of the Pods

```bash
# [TERMINAL-1] check if the pods are Running
kubectl get pods

# [TERMINAL-1] open another shell and start tailing logs for app-a
kubectl logs -f app-a

# [TERMINAL-2] delete the pod-A
kubectl delete -f k8s/pod-A.yaml

# [TERMINAL-1] open another shell and start tailing logs for app-b
kubectl logs -f app-b

# [TERMINAL-2] delete the pod-B
kubectl delete -f k8s/pod-B.yaml
```

## Verification of Graceful Shutdown

Take a look at the logs. Did the graceful shutdown happen on both Pods? If not, why?

<details>
  <summary>Hint</summary>

You can check the `Dockerfile`s here:

- [app-a](../00_app/Dockerfile-A)
- [app-b](../00_app/Dockerfile-B)

Start the pods again, and check the PID 1:

```bash
kubectl create -f k8s/

# Pod-A:
kubectl exec -it app-a -- ps aux

# Pod-B:
kubectl exec -it app-b -- ps aux
```

</details>
