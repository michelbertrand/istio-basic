#!/usr/bin/env bash
# Install Debian-compatible prerequisites: docker, minikube, kubectl, helm, istioctl.
# Each step is idempotent — already-installed tools are skipped.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

MINIKUBE_VERSION="${MINIKUBE_VERSION:-latest}"
ISTIO_VERSION="${ISTIO_VERSION:-}"  # empty = latest stable

install_docker() {
    if command_exists docker && docker info &>/dev/null; then
        log_success "Docker already installed and accessible: $(docker --version)"
        return
    fi

    if command_exists docker; then
        log_warn "Docker installed but not accessible without sudo. Adding user to docker group..."
        $SUDO usermod -aG docker "$USER"
        log_warn "Start a new shell session (or run 'newgrp docker') and re-run this script."
        exit 0
    fi

    log_info "Installing Docker via get.docker.com..."
    curl -fsSL https://get.docker.com | $SUDO sh
    $SUDO usermod -aG docker "$USER"
    log_warn "Docker installed. Start a new shell session (or run 'newgrp docker') then re-run this script."
    exit 0
}

install_minikube() {
    if command_exists minikube; then
        log_success "Minikube already installed: $(minikube version --short 2>/dev/null)"
        return
    fi

    log_info "Installing Minikube (${MINIKUBE_VERSION})..."
    local url
    if [[ "$MINIKUBE_VERSION" == "latest" ]]; then
        url="https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
    else
        url="https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION}/minikube-linux-amd64"
    fi
    curl -fsSL -o /tmp/minikube "$url"
    $SUDO install /tmp/minikube /usr/local/bin/minikube
    rm -f /tmp/minikube
    log_success "Minikube installed: $(minikube version --short)"
}

install_kubectl() {
    if command_exists kubectl; then
        log_success "kubectl already installed: $(kubectl version --client --short 2>/dev/null | head -1)"
        return
    fi

    log_info "Installing kubectl (stable)..."
    local stable
    stable=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
    curl -fsSL -o /tmp/kubectl "https://dl.k8s.io/release/${stable}/bin/linux/amd64/kubectl"
    $SUDO install /tmp/kubectl /usr/local/bin/kubectl
    rm -f /tmp/kubectl
    log_success "kubectl installed: $(kubectl version --client --short 2>/dev/null | head -1)"
}

install_helm() {
    if command_exists helm; then
        log_success "Helm already installed: $(helm version --short)"
        return
    fi

    log_info "Installing Helm..."
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    log_success "Helm installed: $(helm version --short)"
}

install_istioctl() {
    if command_exists istioctl; then
        log_success "istioctl already installed: $(istioctl version --remote=false 2>/dev/null | head -1)"
        return
    fi

    log_info "Installing istioctl${ISTIO_VERSION:+ ($ISTIO_VERSION)}..."
    local tmp_dir
    tmp_dir=$(mktemp -d)
    pushd "$tmp_dir" > /dev/null

    if [[ -n "$ISTIO_VERSION" ]]; then
        curl -fsSL https://istio.io/downloadIstio | ISTIO_VERSION="$ISTIO_VERSION" TARGET_ARCH=x86_64 sh -
    else
        curl -fsSL https://istio.io/downloadIstio | TARGET_ARCH=x86_64 sh -
    fi

    local istio_dir
    istio_dir=$(ls -d istio-* 2>/dev/null | head -1)
    $SUDO install "${istio_dir}/bin/istioctl" /usr/local/bin/istioctl
    popd > /dev/null
    rm -rf "$tmp_dir"
    log_success "istioctl installed: $(istioctl version --remote=false 2>/dev/null | head -1)"
}

main() {
    log_step "Setting up prerequisites"

    if ! grep -qi "debian\|ubuntu" /etc/os-release 2>/dev/null; then
        log_warn "This script targets Debian/Ubuntu. Other distros may need manual adjustments."
    fi

    log_info "Updating package index..."
    $SUDO apt-get update -qq
    $SUDO apt-get install -y -qq curl wget ca-certificates gnupg lsb-release

    install_docker
    install_minikube
    install_kubectl
    install_helm
    install_istioctl

    log_success "All prerequisites are ready."
}

main "$@"
