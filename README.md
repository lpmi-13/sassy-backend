# A Sassy Backend

This is the backend for My Totally Serious Saas Business. It's Django REST Framework and sends back very important data that customers will benefit most highly from, even in their home prefectures!

## Running Locally

Because the whole idea is to run this "in production" on EKS, the local runs are going to be via k3s (rather than something simpler like docker-compose).

So you'll need k3s installed, as well as Docker (for building/pushing the container images to the locally running container registry). Beyond that, you'll also need kubectl, but a k3s install should sort that out for you anyway.
