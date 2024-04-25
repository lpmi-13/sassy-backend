#! /bin/sh

# tear down the existing resources
for resource in deploy svc sts pvc pv; do
  kubectl delete $resource -n sassy --all;
done

# we'll need the namespace to exist
kubectl apply -f manifests/namespace.yaml

# now we set up the persisent volumes and claims
kubectl apply -f manifests/database-volumes.yaml

# and finally the deployments and services in front of them
kubectl apply -f manifests/database-statefulset.yaml
kubectl apply -f manifests/database-service.yaml

kubectl apply -f manifests/backend-deployment.yaml
kubectl apply -f manifests/backend-service.yaml
