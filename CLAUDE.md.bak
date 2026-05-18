# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Helm chart (`istio-basic`) used as a reusable template to deploy the Istio [Bookinfo](https://istio.io/latest/docs/examples/bookinfo/) sample application. The same chart is instantiated multiple times — once per microservice — with different `--set` overrides each time. It targets the `bookinfo` namespace on a Kubernetes cluster with Istio installed.

## Key Commands

**Full setup (idempotent — safe to re-run):**
```sh
./install.sh
```

**Full teardown (stops Minikube by default):**
```sh
./uninstall.sh
./uninstall.sh --delete-minikube   # also deletes the cluster
```

**Skip steps you've already done:**
```sh
./install.sh --skip-prerequisites --skip-minikube   # re-deploy Istio + app only
./install.sh --skip-prerequisites --skip-minikube --skip-istio   # re-deploy app only
```

**Override defaults via environment variables:**
```sh
MINIKUBE_MEMORY=8192 MINIKUBE_CPUS=4 ISTIO_PROFILE=demo ./install.sh
NAMESPACE=bookinfo IMAGE_TAG=1.20.3 ./install.sh --skip-prerequisites --skip-minikube --skip-istio
```

**Lint the Helm chart:**
```sh
helm lint ./
```

**Preview rendered manifests for a single release:**
```sh
helm template <release-name> ./ --set <key>=<value> ...
```

**Verify the running app:**
```sh
kubectl exec "$(kubectl get pod -l app=ratings -n bookinfo -o jsonpath='{.items[0].metadata.name}')" \
  -c ratings -n bookinfo -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"
```

## Project Structure

```
istio-basic/
├── install.sh                      # Main entry point — runs all steps in order
├── uninstall.sh                    # Full teardown
├── scripts/
│   ├── common.sh                   # Shared logging, sudo helper, idempotency checks
│   ├── 01-setup-prerequisites.sh  # Install docker, minikube, kubectl, helm, istioctl (Debian)
│   ├── 02-setup-minikube.sh       # Start Minikube (4 CPU / 4 GB / docker driver)
│   ├── 03-install-istio.sh        # Install Istio via istioctl (demo profile)
│   └── 04-deploy-bookinfo.sh      # Deploy all Bookinfo services via Helm
├── templates/                      # Helm chart templates
├── bookinfo-gateway.yaml           # Istio Gateway + VirtualService (kubectl applied)
├── destination-rule-all.yaml       # Istio DestinationRules (kubectl applied)
├── namespace.yaml                  # bookinfo namespace
├── bookinfo.yaml                   # Raw Istio sample YAML (reference — not used by scripts)
└── httpbin.yaml                    # httpbin service (manual use)
```

`helm-create-bookinfo.sh` and `helm-remove-bookinfo.sh` are kept as reference; the `scripts/` directory supersedes them.

## Architecture

### Chart reuse pattern

The chart in `./` is a single generic Helm chart instantiated multiple times. Each Bookinfo service (details, ratings, reviews-v1/v2/v3, productpage) gets its own `helm install` with `--set` overrides to configure image, labels, service ports, service account, volumes, and whether an EnvoyFilter is created. The `helm-create-bookinfo.sh` script captures all these invocations.

Key overrides that change per-release:
- `nameOverride` / `fullnameOverride` — controls resource names
- `selectorLabels.app` / `selectorLabels.version` — controls pod selector and EnvoyFilter workload selector
- `podLabels` — must match `selectorLabels` for Istio traffic routing to work
- `service.create` / `serviceAccount.create` — set to `false` for reviews-v2 and reviews-v3 since they share the service and SA with reviews-v1
- `envoyFilter.create` — only enabled for `ratings` and `productpage`

### EnvoyFilter (Lua)

[templates/envoyfilter.yaml](templates/envoyfilter.yaml) injects a Lua HTTP filter into the Istio sidecar (`SIDECAR_INBOUND`). It adds custom headers on both request and response paths:
- `x-demo-header-request` on inbound requests
- `x-demo-header-response` on responses

The filter uses `logWarn` (not `logInfo`) because the default Istio proxy log level is `warn`.

### Static Istio resources

These files are applied directly with `kubectl`, not via Helm:
- [bookinfo-gateway.yaml](bookinfo-gateway.yaml) — Istio `Gateway` (listens on port 80, selector: `app=istio-ingress`) and `VirtualService` routing `/productpage`, `/static`, `/login`, `/logout`, `/api/v1/products` to the productpage service
- [destination-rule-all.yaml](destination-rule-all.yaml) — `DestinationRule` resources defining subsets (v1/v2/v3) for all four services, enabling Istio traffic splitting
- [namespace.yaml](namespace.yaml) — the `bookinfo` namespace (applied before Helm installs)

### Prometheus scraping

The productpage release enables Prometheus scraping via pod annotations (`prometheus.io/scrape`, `prometheus.io/port=9080`, `prometheus.io/path=/metrics`) set through `--set-string` in the install script.
