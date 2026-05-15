#!/usr/bin/env bash
# Deploy the Bookinfo sample application using the Helm chart. Idempotent.
# Uses `helm upgrade --install` so re-runs install or upgrade safely.
#
# Environment variables (all optional):
#   NAMESPACE    Target namespace   (default: bookinfo)
#   IMAGE_TAG    Image tag          (default: 1.20.3)

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHART_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/common.sh"

NAMESPACE="${NAMESPACE:-bookinfo}"
IMAGE_TAG="${IMAGE_TAG:-1.20.3}"

helm_deploy() {
    local release="$1"; shift
    log_info "Deploying release: $release"
    helm upgrade --install "$release" "$CHART_DIR" \
        --namespace "$NAMESPACE" \
        --create-namespace \
        "$@"
}

create_namespace() {
    # kubectl create with --dry-run piped to apply is idempotent
    kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
    kubectl label namespace "$NAMESPACE" istio-injection=enabled --overwrite
}

main() {
    log_step "Deploying Bookinfo application"

    create_namespace

    log_info "Applying Istio Gateway and VirtualService..."
    kubectl apply -f "$CHART_DIR/bookinfo-gateway.yaml"

    log_info "Applying DestinationRules..."
    kubectl apply -f "$CHART_DIR/destination-rule-all.yaml"

    helm_deploy details \
        --set namespace="$NAMESPACE" \
        --set selectorLabels.app=details \
        --set selectorLabels.version=v1 \
        --set podLabels.app=details \
        --set podLabels.version=v1 \
        --set nameOverride=details \
        --set fullnameOverride=details-v1 \
        --set image.repository=docker.io/istio/examples-bookinfo-details-v1 \
        --set image.tag="$IMAGE_TAG" \
        --set image.pullPolicy=IfNotPresent \
        --set envoyFilter.create=false \
        --set service.port=9080 \
        --set service.labels.app=details \
        --set service.labels.service=details \
        --set serviceAccount.name=bookinfo-details \
        --set 'serviceAccount.annotations.account=details'

    helm_deploy ratings \
        --set namespace="$NAMESPACE" \
        --set selectorLabels.app=ratings \
        --set selectorLabels.version=v1 \
        --set podLabels.app=ratings \
        --set podLabels.version=v1 \
        --set nameOverride=ratings \
        --set fullnameOverride=ratings-v1 \
        --set image.repository=docker.io/istio/examples-bookinfo-ratings-v1 \
        --set image.tag="$IMAGE_TAG" \
        --set image.pullPolicy=IfNotPresent \
        --set envoyFilter.create=true \
        --set service.port=9080 \
        --set service.labels.app=ratings \
        --set service.labels.service=ratings \
        --set serviceAccount.name=bookinfo-ratings \
        --set 'serviceAccount.annotations.account=ratings'

    helm_deploy reviews \
        --set namespace="$NAMESPACE" \
        --set selectorLabels.app=reviews \
        --set selectorLabels.version=v1 \
        --set podLabels.app=reviews \
        --set podLabels.version=v1 \
        --set nameOverride=reviews \
        --set fullnameOverride=reviews-v1 \
        --set image.repository=docker.io/istio/examples-bookinfo-reviews-v1 \
        --set image.tag="$IMAGE_TAG" \
        --set image.pullPolicy=IfNotPresent \
        --set envoyFilter.create=false \
        --set 'volumes[0].name=wlp-output' \
        --set 'volumes[0].emptyDir=null' \
        --set 'volumes[1].name=tmp' \
        --set 'volumes[1].emptyDir=null' \
        --set 'volumeMounts[0].name=wlp-output' \
        --set 'volumeMounts[0].mountPath=/opt/ibm/wlp/output' \
        --set 'volumeMounts[1].name=tmp' \
        --set 'volumeMounts[1].mountPath=/tmp' \
        --set service.port=9080 \
        --set service.labels.app=reviews \
        --set service.labels.service=reviews \
        --set serviceAccount.name=bookinfo-reviews \
        --set 'serviceAccount.annotations.account=reviews'

    helm_deploy reviews-v2 \
        --set namespace="$NAMESPACE" \
        --set selectorLabels.app=reviews \
        --set selectorLabels.version=v2 \
        --set podLabels.app=reviews \
        --set podLabels.version=v2 \
        --set nameOverride=reviews \
        --set fullnameOverride=reviews-v2 \
        --set image.repository=docker.io/istio/examples-bookinfo-reviews-v2 \
        --set image.tag="$IMAGE_TAG" \
        --set image.pullPolicy=IfNotPresent \
        --set envoyFilter.create=false \
        --set 'volumes[0].name=wlp-output' \
        --set 'volumes[0].emptyDir=null' \
        --set 'volumes[1].name=tmp' \
        --set 'volumes[1].emptyDir=null' \
        --set 'volumeMounts[0].name=wlp-output' \
        --set 'volumeMounts[0].mountPath=/opt/ibm/wlp/output' \
        --set 'volumeMounts[1].name=tmp' \
        --set 'volumeMounts[1].mountPath=/tmp' \
        --set service.port=9080 \
        --set service.labels.app=reviews \
        --set service.labels.service=reviews \
        --set service.create=false \
        --set serviceAccount.create=false

    helm_deploy reviews-v3 \
        --set namespace="$NAMESPACE" \
        --set selectorLabels.app=reviews \
        --set selectorLabels.version=v3 \
        --set podLabels.app=reviews \
        --set podLabels.version=v3 \
        --set nameOverride=reviews \
        --set fullnameOverride=reviews-v3 \
        --set image.repository=docker.io/istio/examples-bookinfo-reviews-v3 \
        --set image.tag="$IMAGE_TAG" \
        --set image.pullPolicy=IfNotPresent \
        --set envoyFilter.create=false \
        --set 'volumes[0].name=wlp-output' \
        --set 'volumes[0].emptyDir=null' \
        --set 'volumes[1].name=tmp' \
        --set 'volumes[1].emptyDir=null' \
        --set 'volumeMounts[0].name=wlp-output' \
        --set 'volumeMounts[0].mountPath=/opt/ibm/wlp/output' \
        --set 'volumeMounts[1].name=tmp' \
        --set 'volumeMounts[1].mountPath=/tmp' \
        --set service.port=9080 \
        --set service.labels.app=reviews \
        --set service.labels.service=reviews \
        --set service.create=false \
        --set serviceAccount.create=false

    helm_deploy productpage \
        --set namespace="$NAMESPACE" \
        --set selectorLabels.app=productpage \
        --set selectorLabels.version=v1 \
        --set podLabels.app=productpage \
        --set podLabels.version=v1 \
        --set nameOverride=productpage \
        --set fullnameOverride=productpage-v1 \
        --set image.repository=docker.io/istio/examples-bookinfo-productpage-v1 \
        --set image.tag="$IMAGE_TAG" \
        --set image.pullPolicy=IfNotPresent \
        --set envoyFilter.create=true \
        --set 'volumes[0].name=tmp' \
        --set 'volumes[0].emptyDir=null' \
        --set 'volumeMounts[0].name=tmp' \
        --set 'volumeMounts[0].mountPath=/tmp' \
        --set service.port=9080 \
        --set service.labels.app=productpage \
        --set service.labels.service=productpage \
        --set serviceAccount.name=bookinfo-productpage \
        --set 'serviceAccount.annotations.account=productpage' \
        --set-string 'podAnnotations.prometheus\.io/scrape=true' \
        --set-string 'podAnnotations.prometheus\.io/port=9080' \
        --set-string 'podAnnotations.prometheus\.io/path=/metrics'

    log_info "Waiting for all pods to become ready (up to 5 min)..."
    kubectl wait pods -n "$NAMESPACE" --all --for=condition=Ready --timeout=300s

    log_success "Bookinfo application deployed."
    echo ""
    log_info "Get the application URL:"
    echo "  minikube service productpage -n $NAMESPACE --url"
    echo ""
    log_info "Verify via in-cluster request:"
    echo "  kubectl exec \"\$(kubectl get pod -l app=ratings -n $NAMESPACE -o jsonpath='{.items[0].metadata.name}')\" \\"
    echo "    -c ratings -n $NAMESPACE -- curl -sS productpage:9080/productpage | grep -o '<title>.*</title>'"
}

main "$@"
