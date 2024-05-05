#! /bin/sh

ACCOUNT_ID=PUT_YOUR_AWS_ACCOUNT_ID_HERE

# tear down the existing resources
for resource in deploy ingress svc sts pvc pv configmap; do
  kubectl delete $resource -n sassy --all;
done

eksctl create iamserviceaccount \
    --name ebs-csi-controller-sa \
    --namespace kube-system \
    --cluster sassy \
    --role-name AmazonEKS_EBS_CSI_DriverRole \
    --role-only \
    --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
    --approve

eksctl create iamserviceaccount \
  --name aws-load-balancer-controller \
  --namespace kube-system \
  --cluster sassy \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn "arn:aws:iam::${ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy" \
  --approve

kubectl apply \
    --validate=false \
    -f https://github.com/jetstack/cert-manager/releases/download/v1.13.5/cert-manager.yaml

kubectl apply -f manifests/v2_7_2_full.yaml

kubectl apply -f manifests/v2_7_2_ingclass.yaml

eksctl create addon --name aws-ebs-csi-driver --cluster sassy --service-account-role-arn "arn:aws:iam::${ACCOUNT_ID}:role/AmazonEKS_EBS_CSI_DriverRole" --force

# this might actually be the ingress controller resource we need...
# kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"


# this only matters when deploying to production
# (note: I don't actually remember what this is for, but I'm sure you'll figure it out)
export EBS_VOLUME_ID=PUT_AN_EBS_VOLUME_ID_HERE

export POSTGRES_USER_REPLACE=prod-userboom
export POSTGRES_PASSWORD_REPLACE=supersecretproductionpasswordboom

export BACKEND_IMAGE_NAME="${ACCOUNT_ID}.dkr.ecr.eu-west-1.amazonaws.com/sassy-backend:latest"
export BACKEND_DB_SEED_IMAGE_NAME="${ACCOUNT_ID}.dkr.ecr.eu-west-1.amazonaws.com/sassy-backend-db-seed:latest"

# for postgres access
export SUPERUSER_USERNAME_REPLACE=superadminboom
export SUPERUSER_PASSWORD_REPLACE=thisisaproductionpasswordboom

export EXPOSED_TYPE=NodePort

export DB_HOST_REPLACE=postgres
export DB_USER_REPLACE=$POSTGRES_USER_REPLACE
export DB_PASSWORD_REPLACE=$POSTGRES_PASSWORD_REPLACE
export PORT_REPLACE=5432
export DJANGO_SECRET_KEY_REPLACE=jc487jcn4uhn488s8s9fkj3jkd8fh
export DJANGO_DEBUG_REPLACE=False

# we'll need the namespace to exist
kubectl apply -f manifests/namespace.yaml

# now we set up the persisent volumes and claims
envsubst < "manifests/database-volumes-${ENVIRONMENT:=production}.yaml" | kubectl apply -f -

# and finally the deployments and services in front of them
envsubst < manifests/database-statefulset.yaml | kubectl apply -f -
kubectl apply -f manifests/database-service.yaml

sed '/ALLOWED_HOSTS/d' manifests/backend-config-map.yaml | envsubst | kubectl apply -f -
envsubst < manifests/backend-deployment.yaml | kubectl apply -f -
envsubst < manifests/backend-service.yaml | kubectl apply -f -

kubectl apply -f manifests/backend-ingress.yaml
