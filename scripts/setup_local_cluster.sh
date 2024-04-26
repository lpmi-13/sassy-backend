#! /bin/sh

# first, set up the local container registry so we can push/pull images
./scripts/start_registry.sh

# now we can build and push the container image for the backend application
./scripts/build_container.sh

# and finally set up the k8s deployments
./scripts/deploy-local.sh