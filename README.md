# E

## Introduction

Welcome to hell

## Pre-requesites

1. Setup Openbao access
On the host system, set the following environment variables

export VAULT_ADDR="https://127.0.0.1:8200"
export BAO_ADDR="$FNOX_VAULT_ADDR


> This step is optional but highly enouraged

Note that .gitleaks.toml.tmpl must be set manually to avoid operational overhead,
to make it simple edit and execute the following script:

> Note: DOMAIN must contain only the domain name; no prefix ("https://") nor suffix (".com")
```
DOMAIN=my-domain envsubst -i "./.gitleaks.toml.tmpl" -o "./.gitleaks.toml"
```
# Important

>MAKE HTTPROUTE SEPARATE ( LIKE FLUX OPERATOR RBAC) AND REMOVE FROM HELMRELEASEE SO IN BOOTSTRAPPING ${DOMAIN} DOESNT EXIST, ( TO AVOID USING HELM OVERLAYS OR WEIRD STUFF)

Maybe use [Trivy](https://trivy.dev/) +   kyverno for opsec


https://oneuptime.com/blog/post/2026-01-17-helm-schema-validation-values/view#validate-during-development
Maybe use this for validating schemas inside helmreleases or maybe add IDE integration



<<- if hasPrefix "oci://" inputs.source.url >>
test


