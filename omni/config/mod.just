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
deploy: omniconfig_halter omniconfig cluster kubeconfig end

omniconfig_halter:
    dir=$(dirname "$(pwd)")
    if  [ ! -s ../.private/omniconfig ]; then
    echo "=========================================="
    echo "Download the omniconfig and move it to ${dir} before proceeding"
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
