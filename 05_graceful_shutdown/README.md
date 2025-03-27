# Graceful Shutdown

In this training, we will create a pod and learn how to ensure a graceful shutdown of the application.

The application implements a shutdown hook and needs 10 seconds for a proper shutdown.

Change into the lab directory:

```bash
cd 05_graceful_shutdown
```

## Possible data loss

### Create the Pod

Inspect pod.yaml definition file and create the pod

```bash
cat k8s/pod.yaml
kubectl create -f k8s/pod.yaml
```

### Verify that graceful shutdown does not happen

```bash
# [TERMINAL-1] follow the logs of your application
kubectl logs -f app

# [TERMINAL-2] delete the pod
kubectl delete pod app
```

> [!TIP]
> Note that the graceful shutdown has not finished successfully.

## Avoiding possible data loss

Update `k8s/pod.yaml` file:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  terminationGracePeriodSeconds: 12 # --> Change this line
  containers:
    - name: app
      image: quay.io/kubermatic-labs/training-application:1.0.0-go
      imagePullPolicy: Always
```

```bash
# [TERMINAL-1] recreate the pod
kubectl create -f k8s/pod.yaml

# [TERMINAL-1] follow the logs of your application
kubectl logs -f app

# [TERMINAL-2] delete the pod
kubectl delete pod app
```

> [!TIP]
> Note that, this time the application now has enough time to do a graceful shutdown

## Danger Zone

```bash
# [TERMINAL-1] recreate the pod
kubectl create -f k8s/pod.yaml

# [TERMINAL-1] follow the logs of your application
kubectl logs -f app

# [TERMINAL-1] stop the Pod again ungracefully via the flag `--grace-period`
kubectl delete pod app --grace-period=0
```

> Note that the application now does not have enough time to do a graceful shutdown
