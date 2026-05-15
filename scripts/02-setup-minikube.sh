#!/usr/bin/env bash
# Start Minikube with enough resources for Istio. Idempotent.
#
# Environment variables (all optional):
#   MINIKUBE_MEMORY   RAM in MB       (default: 4096)
#   MINIKUBE_CPUS     CPU count       (default: 4)
#   MINIKUBE_DISK     Disk size       (default: 20g)
#   MINIKUBE_DRIVER   VM driver       (default: docker)
#   MINIKUBE_K8S_VER  K8s version     (default: stable)

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

MINIKUBE_MEMORY="${MINIKUBE_MEMORY:-4096}"
MINIKUBE_CPUS="${MINIKUBE_CPUS:-4}"
MINIKUBE_DISK="${MINIKUBE_DISK:-20g}"
MINIKUBE_DRIVER="${MINIKUBE_DRIVER:-docker}"
MINIKUBE_K8S_VER="${MINIKUBE_K8S_VER:-stable}"

main() {
    log_step "Setting up Minikube"

    if is_minikube_running; then
        log_success "Minikube is already running."
        minikube status
        return
    fi

    local host_status
    host_status=$(minikube status --format='{{.Host}}' 2>/dev/null || echo "Nonexistent")

    if [[ "$host_status" == "Stopped" || "$host_status" == "Paused" ]]; then
        log_info "Minikube cluster exists but is stopped. Starting..."
        minikube start
    else
        log_info "Starting new Minikube cluster (driver=$MINIKUBE_DRIVER memory=${MINIKUBE_MEMORY}MB cpus=$MINIKUBE_CPUS disk=$MINIKUBE_DISK)..."
        minikube start \
            --driver="$MINIKUBE_DRIVER" \
            --memory="$MINIKUBE_MEMORY" \
            --cpus="$MINIKUBE_CPUS" \
            --disk-size="$MINIKUBE_DISK" \
            --kubernetes-version="$MINIKUBE_K8S_VER"
    fi

    log_success "Minikube is running."
    minikube status
}

main "$@"
