#!/usr/bin/env bash
# Tear down Bookinfo, Istio, and optionally Minikube. Safe to run multiple times.
#
# Usage:
#   ./uninstall.sh [OPTIONS]
#
# Options:
#   --delete-minikube   Delete the Minikube cluster entirely (default: stop only)
#   --keep-istio        Skip Istio removal
#   -h, --help          Show this help
#
# Environment variables:
#   NAMESPACE   App namespace   (default: bookinfo)

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/common.sh"

DELETE_MINIKUBE=false
KEEP_ISTIO=false
NAMESPACE="${NAMESPACE:-bookinfo}"

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --delete-minikube) DELETE_MINIKUBE=true ;;
            --keep-istio)      KEEP_ISTIO=true ;;
            -h|--help)
                sed -n 's/^# \?//p' "$0" | head -15
                exit 0
                ;;
            *) log_error "Unknown option: $1"; exit 1 ;;
        esac
        shift
    done
}

remove_bookinfo() {
    log_step "Removing Bookinfo"
    for release in productpage reviews-v3 reviews-v2 reviews ratings details; do
        if helm status "$release" -n "$NAMESPACE" &>/dev/null; then
            log_info "Uninstalling Helm release: $release"
            helm uninstall "$release" -n "$NAMESPACE"
        else
            log_info "Release '$release' not found — skipping."
        fi
    done

    kubectl delete -f "$SCRIPT_DIR/bookinfo-gateway.yaml" --ignore-not-found=true
    kubectl delete -f "$SCRIPT_DIR/destination-rule-all.yaml" --ignore-not-found=true

    if namespace_exists "$NAMESPACE"; then
        log_info "Deleting namespace: $NAMESPACE"
        kubectl delete namespace "$NAMESPACE"
    fi
    log_success "Bookinfo removed."
}

remove_istio() {
    log_step "Removing Istio"
    if ! namespace_exists istio-system; then
        log_info "Istio not installed — skipping."
        return
    fi
    istioctl uninstall --purge -y
    kubectl delete namespace istio-system --ignore-not-found=true
    log_success "Istio removed."
}

manage_minikube() {
    log_step "Minikube"
    if ! is_minikube_running; then
        log_info "Minikube is not running."
        return
    fi
    if $DELETE_MINIKUBE; then
        log_info "Deleting Minikube cluster..."
        minikube delete
        log_success "Minikube cluster deleted."
    else
        log_info "Stopping Minikube (use --delete-minikube to fully delete the cluster)..."
        minikube stop
        log_success "Minikube stopped."
    fi
}

main() {
    parse_args "$@"

    echo ""
    echo "================================================="
    echo "  Istio + Bookinfo on Minikube — Teardown"
    echo "================================================="
    echo ""

    remove_bookinfo
    $KEEP_ISTIO || remove_istio
    manage_minikube

    echo ""
    log_success "Teardown complete."
}

main "$@"
