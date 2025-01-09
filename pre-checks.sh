#!/bin/bash

# List of container names or IDs to check
containers=("cloud-provider-kind" "k8s-fund-for-dev-control-plane" "k8s-fund-for-dev-worker" "k8s-fund-for-dev-worker2")

# Function to display colored output
print_status() {
    if [ "$2" == "OK" ]; then
        printf "%-30s \e[32m%s\e[0m\n" "$1" "$2"  # Green for OK
    else
        printf "%-30s \e[31m%s\e[0m\n" "$1" "$2"  # Red for NOK
    fi
}

# Check the status of each container
echo "Containers"
echo "=========="
for container in "${containers[@]}"; do
    if [ "$(docker ps -q -f name="$container")" ]; then
        print_status "$container" "OK"
    else
        print_status "$container" "NOK"
    fi
done

echo ""

echo "Kubernetes Cluster"
echo "=================="
kubectl cluster-info | grep -v dump

echo "INGRESS IP"
echo "=========="
if [ ! -z $INGRESS_IP ]; then
    print_status "Address: $INGRESS_IP" "OK"
else
    print_status "Address: Not set!" "NOK"
fi
