#! /bin/sh

# tear down the existing resources
for resource in deploy svc sts pvc pv configmap; do
  kubectl delete $resource -n sassy --all;
done

export POSTGRES_USER_REPLACE=prod-user
export POSTGRES_PASSWORD_REPLACE=supersecretproductionpassword

export BACKEND_IMAGE_NAME=localhost:5001/sassy-backend
export BACKEND_DB_SEED_IMAGE_NAME=localhost:5001/sassy-backend-db-seed

# for postgres access
export SUPERUSER_USERNAME_REPLACE=superadmin
export SUPERUSER_PASSWORD_REPLACE=thisisalocalpassword

export EXPOSED_TYPE=ClusterIP

export DB_HOST_REPLACE=postgres
export DB_USER_REPLACE=$POSTGRES_USER_REPLACE
export DB_PASSWORD_REPLACE=$POSTGRES_PASSWORD_REPLACE
export PORT_REPLACE=5432
export DJANGO_SECRET_KEY_REPLACE=thisisaninsecurekey
export DJANGO_DEBUG_REPLACE=True
export ALLOWED_HOSTS_REPLACE=""

# we'll need the namespace to exist
kubectl apply -f manifests/namespace.yaml

# now we set up the persisent volumes and claims
envsubst < "manifests/database-volumes-${ENVIRONMENT:=local}.yaml" | kubectl apply -f -

# and finally the deployments and services in front of them
envsubst < manifests/database-statefulset.yaml | kubectl apply -f -
kubectl apply -f manifests/database-service.yaml

# on the local deploy, we don't want a value for ALLOWED_HOSTS, so that settings.py assigns the default
sed '/ALLOWED_HOSTS/d' manifests/backend-config-map.yaml | envsubst | kubectl apply -f -
envsubst < manifests/backend-deployment.yaml | kubectl apply -f -
envsubst < manifests/backend-service.yaml | kubectl apply -f -
