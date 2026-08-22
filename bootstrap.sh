#!/usr/bin/env bash
set -euo pipefail

# This script sets the bootstrapping operations, currently a shitshow, rewrite to make it actually useful
# with real checks like if/else
# REWRITE TO JUSTFILE LATER ON

cd ~/homelab

kubectl apply --server-side -f envoy-crds.yaml

kubectl create namespace external-secrets

kubectl create secret generic vault-token \
  --namespace external-secrets \
  --from-literal=token="$(bao kv get -mount=kubernetes-kv -field=BAO_TOKEN k8s-token)"
