#!/usr/bin/env bash
set -euo pipefail

# This script shows the needed bootstrapping operations, currently a shitshow, rewrite to make it actually useful
# with real checks like if/else, conditionals, arrays and loops to enforce max DRY
# Rewrite to Justfile/Taskfile later on ( or any other task runner)

## Omni phase

# Create omni.asc key used for etcd encryption
gpg --batch --passphrase '' \
  --quick-generate-key \
  "Omni (Used for etcd data encryption) omni@internal.local" \
  rsa4096 cert never

FINGERPRINT=$(gpg --with-colons --list-keys "omni@internal.local" \
  | awk -F: '$1 == "fpr" {print $10; exit}')

gpg --batch --passphrase '' \
  --quick-add-key ${FINGERPRINT} rsa4096 encr never

gpg --export-secret-key --armor omni@internal.local > ./omni/config/omni.asc

# Create configs based on template ( Must do before starting Omni container)

envsubst -i ./omni/templates/omni.yaml.tmpl -o ./omni/config/omni.yaml
envsubst -i ./omni/templates/dex.yaml.tmpl -o ./omni/config/dex.yaml
envsubst -i ./omni/templates/Caddyfile.tmpl -o ./omni/config/Caddyfile


## Kubernetes phase

# Create both namespaces so the secrets can be created.

kubectl create ns flux-system && kubectl create ns external-secrets

# Create the real templates based on environment variables injected by mise, which retrieved from OpenBao

envsubst -i ./bootstrap/secrets/secrets.yaml.tmpl | kubectl apply -f -

