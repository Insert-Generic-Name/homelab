# "=========================================="
#                 "Stage 2"
# "=========================================="
set quiet
set no-exit-message
set default-script
set shell := ['bash', '-euo', 'pipefail', '-c']
set script-interpreter := ['bash', '-euo', 'pipefail']

[confirm("Ready to deploy Stage 2? [y|n] ")]
default: checks create-resources deploy-crds deploy-apps

checks:
    # Checks if Openbao is able to read Kubernetes secrets
    if ! bao kv get -mount=kubernetes bootstrap >/dev/null 2>&1  ; then
    just log error "Openbao CLI is unable to retrieve secrets, exiting" "stage" "{{ recipe_name() }}"
    exit 1
    fi
# Check if Kubectl is able to communicate with the cluster
create-resources:
    just log info "Creating initial kubernetes resources" "stage" "{{ recipe_name() }}"
    kubectl apply -f "./resources/namespaces.yaml"

    # Needed secret refs on templates
    k8s_secrets=(
    DOMAIN
    BAO_TOKEN
    )

    # Export the secrets as environment variables
    for secret in "${k8s_secrets[@]}"; do
    export $secret="$(bao kv get -mount=kubernetes -field="$secret" bootstrap)"
    done

    # Envsubst replaces the values, writes to stdout and kubectl applies the generated manifest on the fly
    envsubst -i ./resources/secrets.yaml.tmpl  --no-unset --no-empty -fail-fast | kubectl apply -f -

    # Unset variables
    unset "${k8s_secrets[@]}"

deploy-crds:
    just log info "Applying CRDs" "stage" "{{ recipe_name() }}"
    if ! helmfile -f "./helmfile/crds.yaml" template -q | yq ea -r -e 'select(.kind == "CustomResourceDefinition")' | kubectl apply --server-side --force-conflicts -f -; then
    just log error "Unable to apply CRDs" "stage" "{{ recipe_name() }}"
    exit 1
    fi

deploy-apps:
    just log info "Deploying infrastructure" "stage" "{{ recipe_name() }}"
    helmfile apply -f "./helmfile/apps.yaml"
