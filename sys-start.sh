#!/usr/bin/env bash
set -euo pipefail

# This script bootstraps the system itself and fakes the loadbalancer. Its not related to the k8s deployment itself, its just a convenience messed up script

# Variables, set this manually
VM_NAME="talslop"
ENVOY_SVC="envoy-network-system-envoy-gateway-b7e4c8a5"
#

if virsh -c qemu:///system domstate "${VM_NAME}" 2>/dev/null | grep -q "running"; then
    echo "######################################################"
    echo "VM '${VM_NAME}' is already running."
    echo "######################################################"
else
    virsh -c qemu:///system start "${VM_NAME}"
    echo "######################################################"
    echo "Setting up VM '${VM_NAME}'"
    echo "######################################################"
    sleep 30
fi
echo "##############################################################"
echo " Setting up fake loadbalancer. To stop it, close the terminal"
echo "##############################################################"
while true; do kubectl port-forward -n network-system svc/${ENVOY_SVC} 12000:80 --address 0.0.0.0; done