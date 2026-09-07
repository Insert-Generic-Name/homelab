#!/usr/bin/env bash
set -euo pipefail

# Rewrite to Justfile/Taskfile later on ( or any other task runner)

 # Add Stage0 aka Openbao bootstrap

## Omni phase


# Check if Openbao is able to read Omni secrets.
if  ! bao kv get -mount=omni omni >/dev/null 2>&1 ; then
echo "=========================================="
echo "Openbao CLI is unable to retrieve secrets, exiting"
echo "=========================================="

exit 1
fi


# Check if GNUPG is installed on the system.
if ! gpg --version >/dev/null 2>&1 ; then
echo "=========================================="
echo "GNUPG must be installed manually in the system, exiting"
echo "=========================================="

 exit 1
fi

# Create omni.asc key used for etcd encryption
if ! gpg --batch --list-keys "omni@internal.local" >/dev/null 2>&1; then

echo "=========================================="
echo "Generating Omni asc key for etcd encryption"
echo "=========================================="

gpg --batch --passphrase '' --quick-generate-key "Omni (Used for etcd data encryption) omni@internal.local" rsa4096 cert never
FINGERPRINT=$(gpg --with-colons --list-keys "omni@internal.local"  | awk -F: '$1 == "fpr" {print $10; exit}')
gpg --batch --passphrase '' --quick-add-key ${FINGERPRINT} rsa4096 encr never
gpg --export-secret-key --armor omni@internal.local > ./omni/config/omni.asc

fi


omni_secrets=(
  CLOUDFLARE_API_TOKEN
  EMAIL
  GITHUB_CLIENT_ID
  GITHUB_CLIENT_SECRET
  OMNI_ACCOUNT_UUID
  OMNI_CLIENT_ID
  OMNI_CLIENT_SECRET
  OMNI_DOMAIN
)

config_files=(
  omni.yaml
  dex.yaml
  Caddyfile
)

for secret in "${omni_secrets[@]}"; do
  export $secret="$(bao kv get -mount=omni -field="$secret" omni)"
done

for config_files in "${config_files[@]}"; do
envsubst -i "./omni/templates/$config_files.tmpl" -o "./omni/config/$config_files" --no-unset --no-empty -fail-fast
done

unset "${omni_secrets[@]}"

echo "=========================================="
echo "Stage 1 has been completed sucessfully"
echo "=========================================="

## Kubernetes phase

if ! bao kv get -mount=kubernetes bootstrap >/dev/null 2>&1  ; then
echo "=========================================="
echo "Openbao CLI is unable to retrieve secrets, exiting"
echo "=========================================="

exit 1
fi

k8s_secrets=(
  DOMAIN
  BAO_TOKEN
)
0= openbao 1= omni 2=
echo "=========================================="
echo "Creating inital kubernetes secrets"
echo "=========================================="

for secret in "${k8s_secrets[@]}"; do
  export $secret="$(bao kv get -mount=kubernetes -field="$secret" bootstrap)"
done

envsubst -i ./bootstrap/secrets/secrets.yaml.tmpl  --no-unset --no-empty -fail-fast | kubectl apply -f -

unset "${k8s_secrets[@]}"


echo "=========================================="
echo "Stage 2 has been completed sucessfully, initalising step 3"
echo "=========================================="