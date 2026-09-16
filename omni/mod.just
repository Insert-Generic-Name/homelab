# "=========================================="
#                 "Stage 1"
# "=========================================="
set quiet
set no-exit-message
set default-script
set default-list
set shell := ['bash', '-euo', 'pipefail', '-c']
set script-interpreter := ['bash', '-euo', 'pipefail']

[confirm("Ready to deploy Stage 1|Step: Bootstrap? [y|n] ")]
[doc('Initial bootstrapping & platform configuration')]
bootstrap: checks create_key render_config

[confirm("Ready to deploy Stage 1|Step: Deploy? [y|n] ")]
[doc('Deployment & cluster configuration')]
deploy: get_omniconfig create_cluster get_kubeconfig

[private]
checks:
    # Check if Openbao is able to read Omni secrets
    if ! bao kv get -mount=omni omni >/dev/null 2>&1; then
    just log error "Openbao CLI is unable to retrieve secrets, exiting" "stage" "{{ recipe_name() }}"
    exit 1
    fi

    # Check if GNUPG is installed on the system.
    if ! gpg --version >/dev/null 2>&1; then
    just log error "GNUPG is not installed, exiting" "stage" "{{ recipe_name() }}"
    exit 1
    fi

[private]
create_key:
    gen_key () {
        gpg --batch --passphrase '' --quick-generate-key "Omni (Used for etcd data encryption) omni@internal.local" rsa4096 cert never >/dev/null 2>&1
        FINGERPRINT=$(gpg --with-colons --list-keys "omni@internal.local" | awk -F: '$1 == "fpr" {print $10; exit}')
        gpg --batch --passphrase '' --quick-add-key "${FINGERPRINT}" rsa4096 encr never >/dev/null 2>&1
        gpg --export-secret-key --armor "omni@internal.local" > ./.generated/omni.asc
    }

    if [[ -s ./.generated/omni.asc ]]; then
    # If file exists do nothing
    elif gpg --list-keys "omni@internal.local" >/dev/null 2>&1; then
    # If file is missing but gpg key is still in the system it must be placed back, else Omni will fail to deploy.
    just log info "Omni.asc file missing; exporting existing key" "stage" "{{ recipe_name() }}"
    gpg --export-secret-key --armor "omni@internal.local" > ./.generated/omni.asc
    else
     # If the file nor gpg key can be found, create a new key
    just log info "Omni key missing; generating new key" "stage" "{{ recipe_name() }}"
    gen_key
    fi

[private]
render_config:
    just log info "Rendering omni configuration files from templates" "stage" "{{ recipe_name() }}"

    # Needed secret refs on templates
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
    # Configuration file templates
    config_files=(
    omni.yaml
    dex.yaml
    Caddyfile
    )


    # Export the secrets as environment variables
    for secret in "${omni_secrets[@]}"; do
    export $secret="$(bao kv get -mount=omni -field="$secret" omni)"
    done

    # Check if all variables are set
    for secret in "${omni_secrets[@]}"; do
    if [[ -z "${!secret:-}" ]]; then
    just log error "One or more secrets failed to export, exiting" "stage" "{{ recipe_name() }}"
    exit 1
    fi
    done

    # Envsubst creates configuration files by applying the values inside the templates
    for config_files in "${config_files[@]}"; do
    envsubst -i "./templates/$config_files.tmpl" -o "./.generated/$config_files" --no-unset --no-empty -fail-fast
    done

    # Unset variables
    unset "${omni_secrets[@]}"

[private]
get_omniconfig:
    dir=$(dirname "$(pwd)")
    if  [ ! -s ../omniconfig ]; then
    just log info "Download the omniconfig and move it to ${dir} before proceeding" "stage" "{{ recipe_name() }}"
    read -p "Ready to proceed? [y|n]" answer
    if  [[ "$answer" != "y" && "$answer" != "yes" ]]; then
    exit 1
    fi
    fi

    if ! omnictl config contexts >/dev/null 2>&1; then
    just log error "Unable to get contexts from omnictl, exiting" "stage" "{{ recipe_name() }}"
    exit 1
    fi

    just log info "Connecting Omnictl. Authenticate in your browser if prompted." "stage" "{{ recipe_name() }}"

    if ! omnictl get clusters >/dev/null 2>&1; then
    just log error "Could not initiate authentication, make sure that kubelogin is installed, exiting." "stage" "{{ recipe_name() }}"
    exit 1
    fi

[private]
create_cluster:
    just log info "Applying configurations" "stage" "{{ recipe_name() }}"

    if !  omnictl apply -f ./config/machine-class.yaml >/dev/null 2>&1; then
    just log  error "machineclass configuration not found, exiting" "stage" "{{ recipe_name() }}"
    exit 1
    fi

    if ! omnictl cluster template sync -f ./config/cluster.yaml; then
    just log error "cluster configuration not found, exiting" "stage" "{{ recipe_name() }}"
    exit 1
    fi

[private]
get_kubeconfig:
    just log info "Connecting Kubectl. Authenticate in your browser if prompted." "stage" "{{ recipe_name() }}"

    if ! omnictl kubeconfig --cluster "$CLUSTER_NAME" >/dev/null 2>&1; then
    just log info "Failed to download kubeconfig, make sure that $CLUSTER_NAME is set, exiting" "stage" "{{ recipe_name() }}"
    exit 1
    fi
