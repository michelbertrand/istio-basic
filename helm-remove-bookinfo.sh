#!/bin/bash

# Uninstall Bookinfo applications
helm uninstall details -n bookinfo
helm uninstall ratings -n bookinfo
helm uninstall reviews -n bookinfo
helm uninstall reviews-v2 -n bookinfo
helm uninstall reviews-v3 -n bookinfo
helm uninstall productpage -n bookinfo

# Remove gateway resources
kubectl delete gateway bookinfo-gateway -n bookinfo
kubectl delete virtualservice bookinfo -n bookinfo

# Remove namespace bookinfo
kubectl delete namespace bookinfo

echo "All Bookinfo Helm releases have been uninstalled."