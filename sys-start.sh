#!/usr/bin/env bash
set -euo pipefail

# This script bootstraps the system itself and fakes the loadbalancer. Its not related to the k8s deployment itself, its just a convenient "off-the-books" script ( mainly because Gemini vibe coded it )

# Setup: Run this command ONCE, it allows the script to run sudo-less.
#:~$ sudo setcap 'cap_net_bind_service=+ep' $(readlink -f $(which kubectl))

# Variables, set this manually
VM_NAME="talslop"
ENVOY_SVC="envoy-network-system-envoy-gateway-b7e4c8a5"
LISTENER_IP=$(tailscale ip -4)
FORWARDED_PORTS=(80 )

# VM bootstrap
if virsh -c qemu:///system domstate "${VM_NAME}" 2>/dev/null | grep -q "running"; then
echo "Skipping task"
else
    virsh -c qemu:///system start "${VM_NAME}"
echo "##############################################################"
echo "Setting up VM '${VM_NAME}'"
echo "##############################################################"
    sleep 30
fi
# LoadBalancer bootstrap
echo "##############################################################"
echo " Setting up fake loadbalancer. To stop it, press Ctrl+C twice"
echo "##############################################################"
while true; do
    # The '|| true' keeps 'set -e' from exiting the script when kubectl drops
    kubectl port-forward -n network-system "svc/${ENVOY_SVC}" "${FORWARDED_PORTS[@]}" --address "${LISTENER_IP}" || true

    echo "Load Balancer dropped, reconnecting in 2 seconds..."
    sleep 2
done