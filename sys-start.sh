#!/usr/bin/env bash
set -euo pipefail

# This script bootstraps the system itself and fakes the loadbalancer. Its not related to the k8s deployment itself, its just a convenience messed up script

VM_NAME="talslop"
ENVOY_SVC=""
# Start VM on boot
virsh -c qemu:///system start ${VM_NAME}
echo "#########################################"
echo "Setting up the VM"
echo "#########################################"
sleep 30
echo "#########################################"
echo "VM is running, setting up fake loadbalancer"
echo "#########################################"
kubectl port-forward -n network-system svc/${ENVOY_SVC} 12000:80 --address 0.0.0.0