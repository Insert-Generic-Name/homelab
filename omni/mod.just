# "=========================================="
#                 "Stage 1"
# "=========================================="
set quiet
set no-exit-message
set default-script
set default-list
set shell := ['bash', '-euo', 'pipefail', '-c']
set script-interpreter := ['bash', '-euo', 'pipefail']

[confirm("Ready to deploy Stage 1? [y|n] ")]
bootstrap: greeter checks create_key vars_tmpl run
deploy: omniconfig_halter omniconfig cluster kubeconfig end
greeter:
    echo "=========================================="
    echo "Activating Stage 1"
    echo "=========================================="

checks:
    # Check if Openbao is able to read Omni secrets
    if ! bao kv get -mount=omni omni >/dev/null 2>&1; then
    echo "=========================================="
    echo "Openbao CLI is unable to retrieve secrets, exiting"
    echo "=========================================="
    exit 1
    fi

    # Check if GNUPG is installed on the system.
    if ! gpg --version >/dev/null 2>&1; then
    echo "=========================================="
    echo "GNUPG must be installed manually in the system, exiting"
    echo "=========================================="
    exit 1
    fi

create_key:
    # Create omni.asc key used for etcd encryption if not already present
    if ! gpg --batch --list-keys "omni@internal.local" >/dev/null 2>&1; then
    echo "=========================================="
    echo "Generating Omni asc key for etcd encryption"
    echo "=========================================="
    gpg --batch --passphrase '' --quick-generate-key "Omni (Used for etcd data encryption) omni@internal.local" rsa4096 cert never >/dev/null 2>&1
    FINGERPRINT=$(gpg --with-colons --list-keys "omni@internal.local"  | awk -F: '$1 == "fpr" {print $10; exit}') >/dev/null 2>&1
    gpg --batch --passphrase '' --quick-add-key ${FINGERPRINT} rsa4096 encr never >/dev/null 2>&1
    gpg --export-secret-key --armor omni@internal.local > ./config/omni.asc
    fi

vars_tmpl:
    echo "=========================================="
    echo "Creating omni configuration files"
    echo "=========================================="

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

    # Envsubst creates configuration files by applying the values inside the templates
    for config_files in "${config_files[@]}"; do
    envsubst -i "./templates/$config_files.tmpl" -o "./.generated/$config_files" --no-unset --no-empty -fail-fast
    done

    # Unset variables
    unset "${omni_secrets[@]}"

run:
    echo "=========================================="
    echo "Starting containers"
    echo "=========================================="
    if ! docker compose up -d; then
    echo "=========================================="
    echo "Unable to run containers, ensure that Docker is ready, exiting"
    echo "=========================================="
    exit 1
    fi

omniconfig_halter:
    if  [ ! -s ../.private/omniconfig ]; then
    echo "=========================================="
    echo "Download the omniconfig and move it to '.private' before proceeding"
    echo "=========================================="
    read -p "Ready to proceed? [y|n]" answer
    if  [[ "$answer" != "y" && "$answer" != "yes" ]]; then
    exit 1
    fi
    fi
omniconfig:
    if ! omnictl config contexts >/dev/null 2>&1; then
    echo "=========================================="
    echo "Unable to get contexts from omnictl, exiting"
    echo "=========================================="
    exit 1
    fi

    echo "=========================================="
    echo "Connecting Omnictl. Authenticate in your browser if prompted."
    echo "=========================================="
    if ! omnictl get clusters >/dev/null 2>&1; then
    echo "=========================================="
    echo "Could not initiate authentication, make sure that kubelogin is installed, exiting"
    echo "=========================================="
    exit 1
    fi
cluster:
    echo "=========================================="
    echo "Applying configurations"
    echo "=========================================="


    if !  omnictl apply -f ./config/machine-class.yaml >/dev/null 2>&1; then
    echo "=========================================="
    echo "machineclass configuration not found, exiting"
    echo "=========================================="
    exit 1
    fi

    if ! omnictl cluster template sync -f ./config/cluster.yaml; then
    echo "=========================================="
    echo "cluster configuration not found, exiting"
    echo "=========================================="
    exit 1
    fi
kubeconfig:
    echo "=========================================="
    echo "Connecting Kubectl. Authenticate in your browser if prompted."
    echo "=========================================="
    if ! omnictl kubeconfig --cluster $CLUSTER_NAME >/dev/null 2>&1; then
    echo "=========================================="
    echo "Failed to download kubeconfig, make sure that $CLUSTER_NAME is set, exiting"
    echo "=========================================="
    exit 1
    fi

end:
    echo "=========================================="
    echo "Stage 1 has been completed sucessfully"
    echo "=========================================="
