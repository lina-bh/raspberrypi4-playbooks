#!/bin/bash
set -euo pipefail
umask 077
ssh lina@rpi4 "sudo cat /etc/rancher/k3s/k3s.yaml" \
  | yq --yaml-output '.clusters[].cluster.server="https://rpi4:6443"' \
       >"$(dirname "$0")/kubeconfig"
