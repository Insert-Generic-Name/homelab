#!/usr/bin/bash
set -euo pipefail

BASE="/root/homelabTMP/talos"

echo "[INFO] Preparing for system configuration"

cd "$BASE"
talhelper genconfig
cd ./clusterconfig

declare -A MASTERS=(
  [01]="192.168.1.11"
#  [02]="192.168.1.13"
# [03]="192.168.1.15"
)
declare -A WORKERS=(
  [01]="192.168.1.12"
#  [02]="192.168.1.14"
#  [03]="192.168.1.16"
)
apply_config() {
  local node_ip="$1"
  local file="$2"

  echo "Applying $file to $node_ip..."
  talosctl apply-config --insecure --nodes "$node_ip" --file "$file"
}

for id in "${!MASTERS[@]}"; do
  apply_config "${MASTERS[$id]}" "k8s-c-master-${id,,}.yaml"
done

for id in "${!WORKERS[@]}"; do
  apply_config "${WORKERS[$id]}" "k8s-c-worker-${id,,}.yaml"
done

echo "[INFO] Waiting for first node to be up, this should not take too long"

talosctl --talosconfig=./talosconfig config endpoints "${MASTERS[@]}"

until talosctl -n "${MASTERS[01]}" --talosconfig=./talosconfig services etcd 2>/dev/null | grep -q "Running"; do
  sleep 5
done

talosctl bootstrap --nodes "${MASTERS[01]}" --talosconfig=./talosconfig

talosctl kubeconfig --nodes "${MASTERS[@]}" --talosconfig=./talosconfig

echo "[INFO] Done"