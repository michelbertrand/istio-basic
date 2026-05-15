#!/usr/bin/env bash
# Main entry point. Runs all setup steps in order. Safe to run multiple times.
#
# Usage:
#   ./install.sh [OPTIONS]
#
# Options:
#   --skip-prerequisites   Skip tool installation (docker, minikube, kubectl, helm, istioctl)
#   --skip-minikube        Skip Minikube start
#   --skip-istio           Skip Istio installation
#   --skip-app             Skip Bookinfo deployment
#   -h, --help             Show this help
#
# Environment variables (passed through to sub-scripts):
#   MINIKUBE_MEMORY    RAM in MB for Minikube   (default: 4096)
#   MINIKUBE_CPUS      CPU count for Minikube   (default: 4)
#   MINIKUBE_DISK      Disk size for Minikube   (default: 20g)
#   MINIKUBE_DRIVER    VM driver                (default: docker)
#   ISTIO_PROFILE      Istio install profile    (default: demo)
#   NAMESPACE          App namespace            (default: bookinfo)
#   IMAGE_TAG          Bookinfo image tag       (default: 1.20.3)
#   ISTIO_VERSION      Pin istioctl version     (default: latest)
#   MINIKUBE_VERSION   Pin minikube version     (default: latest)

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/common.sh"

SKIP_PREREQUISITES=false
SKIP_MINIKUBE=false
SKIP_ISTIO=false
SKIP_APP=false

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --skip-prerequisites) SKIP_PREREQUISITES=true ;;
            --skip-minikube)      SKIP_MINIKUBE=true ;;
            --skip-istio)         SKIP_ISTIO=true ;;
            --skip-app)           SKIP_APP=true ;;
            -h|--help)
                sed -n 's/^# \?//p' "$0" | head -20
                exit 0
                ;;
            *) log_error "Unknown option: $1"; exit 1 ;;
        esac
        shift
    done
}

run_step() {
    local script="$1"
    bash "$script"
}

main() {
    parse_args "$@"

    echo ""
    echo "================================================="
    echo "  Istio + Bookinfo on Minikube — Setup"
    echo "================================================="
    echo ""

    $SKIP_PREREQUISITES || run_step "$SCRIPT_DIR/scripts/01-setup-prerequisites.sh"
    $SKIP_MINIKUBE      || run_step "$SCRIPT_DIR/scripts/02-setup-minikube.sh"
    $SKIP_ISTIO         || run_step "$SCRIPT_DIR/scripts/03-install-istio.sh"
    $SKIP_APP           || run_step "$SCRIPT_DIR/scripts/04-deploy-bookinfo.sh"

    echo ""
    log_success "Setup complete! Run './install.sh --help' to see available options."
}

main "$@"
