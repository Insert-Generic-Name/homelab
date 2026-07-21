#!/bin/bash

# Fetch all node names, skipping the header line
NODES=$(kubectl get nodes --no-headers -o custom-columns=":metadata.name")

for NODE in $NODES; do
  echo "---------------------------------------"
  echo "Draining node: $NODE"
  echo "---------------------------------------"

  kubectl drain "$NODE" \
    --ignore-daemonsets \
    --delete-emptydir-data \
    --force

  echo "Successfully drained: $NODE"
done

echo "All nodes have been processed."