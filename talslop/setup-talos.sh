#!/usr/bin/env bash
set -euo pipefail

CONTROL_PLANE_IP=192.168.122.18
CLUSTER_NAME=shitshow
DISK_NAME=vda




echo "Generating configurations"

./cleanup.sh
sleep 1
talosctl gen config $CLUSTER_NAME https://$CONTROL_PLANE_IP:6443 --install-disk /dev/$DISK_NAME --config-patch @patch.yaml
sleep 2

echo "Applying configurations"

talosctl apply-config --insecure --nodes $CONTROL_PLANE_IP --file controlplane.yaml

echo "Configuring endpoints"

talosctl --talosconfig=./talosconfig config endpoints $CONTROL_PLANE_IP
sleep 10 #test

echo "Bootstrapping etcd"

talosctl bootstrap --nodes $CONTROL_PLANE_IP --talosconfig=./talosconfig
sleep 500

echo "Configuring kubeconfig"

talosctl kubeconfig --nodes $CONTROL_PLANE_IP --talosconfig=./talosconfig
