#!/usr/bin/env bash
# Shared utilities: logging, idempotency checks, privilege helpers.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}[INFO]${NC}  $*"; }
log_success() { echo -e "${GREEN}[OK]${NC}    $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_step()    { echo -e "\n${BOLD}${BLUE}▶ $*${NC}"; }

# Use sudo only when not already root
SUDO=""
[[ "$(id -u)" != "0" ]] && SUDO="sudo"

command_exists() {
    command -v "$1" &>/dev/null
}

is_minikube_running() {
    minikube status --format='{{.Host}}' 2>/dev/null | grep -q "Running"
}

namespace_exists() {
    kubectl get namespace "$1" &>/dev/null
}
