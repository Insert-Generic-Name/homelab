# "=========================================="
#                 "Stage 2"
# "=========================================="
set quiet
set no-exit-message
set default-script
set default-list
set shell := ['bash', '-euo', 'pipefail', '-c']
set script-interpreter := ['bash', '-euo', 'pipefail']

[confirm("Ready to deploy Stage 2? [y|n] ")]
[doc('Initial kubernetes resource generation for bootstrapping')]
deploy: checks create_namespaces create_secrets deploy_crds deploy_apps

[private]
checks:
    # Checks if Openbao is able to read Kubernetes secrets
    if ! bao kv get -mount=kubernetes bootstrap >/dev/null 2>&1; then
    just log error "Openbao CLI is unable to retrieve secrets, exiting" "step" "{{ recipe_name() }}"
    exit 1
    fi

    if ! kubectl get nodes; then
    just log error "kubectl is unable to communicate with the cluster, exiting" "step" "{{ recipe_name() }}"
    exit 1
    fi

[private]
create_namespaces:
    just log info "Creating initial kubernetes namespaces" "step" "{{ recipe_name() }}"
    if ! kubectl apply -f "./resources/namespaces.yaml" > /dev/null 2>&1; then
    just log error "Unable to create namespaces, exiting" "step" "{{ recipe_name() }}"
    exit 1
    fi

[private]
create_secrets:
    just log info "Creating initial kubernetes secrets" "step" "{{ recipe_name() }}"
    # Needed secret refs on templates
    k8s_secrets=(
    DOMAIN
    BAO_TOKEN
    )

    trap 'unset "${k8s_secrets[@]}"' EXIT

    # Export the secrets as environment variables
    for secret in "${k8s_secrets[@]}"; do
    if ! export $secret="$(bao kv get -mount=kubernetes -field="$secret" bootstrap)"; then
    just log error "Unable to export secrets, exiting" "step" "{{ recipe_name() }}"
    exit 1
    fi
    done

    # Check if all variables are set
    for secret in "${k8s_secrets[@]}"; do
    if [[ -z "${!secret:-}" ]]; then
    just log error "One or more secrets failed to render, exiting" "step" "{{ recipe_name() }}"
    exit 1
    fi
    done


    # Envsubst replaces the values, writes to stdout and kubectl applies the generated manifest on the fly
    if ! envsubst -i ./resources/secrets.yaml.tmpl  --no-unset --no-empty -fail-fast | kubectl apply -f -; then
    just log error "Failed to render templates, exiting" "step" "{{ recipe_name() }}"
    exit 1
    fi


    # Unset variables
    unset "${k8s_secrets[@]}"

[private]
deploy_crds:
    just log info "Applying CRDs" "step" "{{ recipe_name() }}"
    if ! helmfile -f "./helmfile/crds.yaml" template -q | yq ea -r -e 'select(.kind == "CustomResourceDefinition")' | kubectl apply --server-side --force-conflicts -f -; then
    just log error "Unable to apply CRDs" "step" "{{ recipe_name() }}"
    exit 1
    fi

[private]
deploy_apps:
    just log info "Deploying infrastructure" "step" "{{ recipe_name() }}"
    if ! helmfile apply -f "./helmfile/apps.yaml"; then
    just log error "Unable to deploy applications" "step" "{{ recipe_name() }}"
    exit 1
    fi
