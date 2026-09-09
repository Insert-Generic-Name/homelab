# "=========================================="
#                 "Stage 2"
# "=========================================="
set quiet
set no-exit-message
set default-script
set shell := ['bash', '-euo', 'pipefail', '-c']
set script-interpreter := ['bash', '-euo', 'pipefail']

[confirm("Ready to deploy Stage 2? [y|n] ")]
default: greeter checks namespaces secrets crds apps end

greeter:
    echo "=========================================="
    echo "Activating Stage 2"
    echo "=========================================="

checks:
    echo "Running: {{ recipe_name() }}"
    # Checks if Openbao is able to read Kubernetes secrets
    if ! bao kv get -mount=kubernetes bootstrap >/dev/null 2>&1  ; then
    echo "=========================================="
    echo "Openbao CLI is unable to retrieve secrets, exiting"
    echo "=========================================="
    exit 1
    fi

namespaces:
    echo "=========================================="
    echo "Creating inital kubernetes resources"
    echo "=========================================="
    echo "Running: {{ recipe_name() }}"
    kubectl apply -f "./resources/namespaces.yaml"
secrets:
    echo "Running: {{ recipe_name() }}"
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

crds:
    echo "=========================================="
    echo "Applying CRDs"
    echo "=========================================="
    if ! helmfile -f "./helmfile/crds.yaml" template -q | yq ea -r -e 'select(.kind == "CustomResourceDefinition")' | kubectl apply --server-side --force-conflicts -f -; then
    exit 1
    fi

apps:
    echo "=========================================="
    echo "Deploying applications"
    echo "=========================================="
    helmfile apply -f "./helmfile/apps.yaml"
end:
    echo "=========================================="
    echo "Stage 2 has been completed sucessfully"
    echo "=========================================="

    echo "=========================================="
    echo "Stage 3 will be activated automatically"
    echo "=========================================="
