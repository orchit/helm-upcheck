#!/bin/bash
COMMIT=$(git rev-parse --verify HEAD)
docker image build . \
  --build-arg "app_name=helm-upcheck" \
  -t "helm-upcheck:latest" \
  -t "helm-upcheck:${COMMIT}"  \
  -t "orchit/helm-upcheck:latest" \
  -t "orchit/helm-upcheck:${COMMIT}"

docker push orchit/helm-upcheck:${COMMIT}
docker push orchit/helm-upcheck:latest