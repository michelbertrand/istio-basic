#!/usr/bin/env bash
# Install Istio on Minikube using the demo profile. Idempotent.
#
# Environment variables (all optional):
#   ISTIO_PROFILE   Istio profile   (default: demo)

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

ISTIO_PROFILE="${ISTIO_PROFILE:-demo}"

main() {
    log_step "Installing Istio"

    if namespace_exists istio-system && \
       kubectl get deployment istiod -n istio-system &>/dev/null 2>&1 && \
       kubectl rollout status deployment/istiod -n istio-system --timeout=10s &>/dev/null 2>&1; then
        log_success "Istio is already installed and istiod is running."
        return
    fi

    log_info "Installing Istio with profile=$ISTIO_PROFILE..."
    istioctl install --set profile="$ISTIO_PROFILE" -y

    log_info "Verifying Istio installation..."
    istioctl verify-install

    log_success "Istio installed successfully."
}

main "$@"
