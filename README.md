# Istio Basic — Learning Lab

A hands-on lab for learning [Istio](https://istio.io/) using the official [Bookinfo](https://istio.io/latest/docs/examples/bookinfo/) sample application on Minikube. Everything is automated and idempotent — re-run any step as many times as you like.

## What you will learn

- How to install and configure Istio on a local Kubernetes cluster
- How Istio's sidecar proxy model works in practice
- How to use `EnvoyFilter` to inject custom Lua logic into the request/response path
- How to control traffic with `VirtualService` and `DestinationRule`
- How Istio integrates with Prometheus for metrics scraping
- How to build a reusable Helm chart deployed across multiple microservices

## Architecture

Bookinfo is a simple polyglot application made up of four services:

```
Browser → Gateway → productpage (Python)
                        ├── details   (Ruby)
                        ├── ratings   (Node.js)
                        └── reviews   (Java — v1 no stars / v2 black stars / v3 red stars)
```

Each service runs with an Istio sidecar (Envoy proxy). Traffic flows through the Istio ingress gateway and is shaped by `VirtualService` and `DestinationRule` resources. `EnvoyFilter` (Lua) is enabled on `ratings` and `productpage` to demonstrate header injection.

## Prerequisites

- Debian or Ubuntu Linux
- `curl` and `wget`

Everything else (Docker, Minikube, kubectl, Helm, istioctl) is installed automatically by `install.sh`.

## Quick Start

```sh
git clone <repo-url>
cd istio-basic
./install.sh
```

The script runs four steps in order:

| Step | What happens |
|------|---|
| **1 — Prerequisites** | Installs Docker, Minikube, kubectl, Helm, istioctl |
| **2 — Minikube** | Starts a cluster (4 CPU / 4 GB RAM / docker driver) |
| **3 — Istio** | Installs Istio with the `demo` profile via `istioctl` |
| **4 — Bookinfo** | Deploys all six Helm releases + Istio networking resources |

> **Note:** If Docker is freshly installed the script will ask you to start a new shell (to reload group membership) and re-run.

## Verify the Application

```sh
# Check the page title via an in-cluster curl
kubectl exec "$(kubectl get pod -l app=ratings -n bookinfo -o jsonpath='{.items[0].metadata.name}')" \
  -c ratings -n bookinfo -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"

# Get the external URL
minikube service productpage -n bookinfo --url
```

## Teardown

```sh
./uninstall.sh                   # remove app + Istio, stop Minikube
./uninstall.sh --delete-minikube # also delete the Minikube cluster
```

## Skipping Steps

Each step is idempotent, so you can skip steps you have already completed:

```sh
./install.sh --skip-prerequisites --skip-minikube            # re-install Istio + app
./install.sh --skip-prerequisites --skip-minikube --skip-istio  # re-deploy app only
```

## Configuration

All steps are controlled by environment variables:

| Variable | Default | Description |
|---|---|---|
| `MINIKUBE_MEMORY` | `4096` | RAM in MB |
| `MINIKUBE_CPUS` | `4` | CPU count |
| `MINIKUBE_DISK` | `20g` | Disk size |
| `MINIKUBE_DRIVER` | `docker` | Minikube driver |
| `MINIKUBE_K8S_VERSION` | `stable` | Kubernetes version |
| `ISTIO_PROFILE` | `demo` | Istio install profile |
| `ISTIO_VERSION` | latest | Pin istioctl version |
| `NAMESPACE` | `bookinfo` | Kubernetes namespace |
| `IMAGE_TAG` | `1.20.3` | Bookinfo image tag |

```sh
MINIKUBE_MEMORY=8192 MINIKUBE_CPUS=6 ./install.sh
```

## Helm Chart

The `./` directory is a single Helm chart that is instantiated once per microservice with different `--set` overrides. This demonstrates how one generic chart can serve multiple workloads.

| `values.yaml` key | Description |
|---|---|
| `selectorLabels` | Pod selector and EnvoyFilter workload selector |
| `podLabels` | Must match `selectorLabels` for Istio traffic routing |
| `envoyFilter.create` | Enable the Lua HTTP filter (`true` for `ratings` and `productpage`) |
| `service.create` | `false` for reviews-v2/v3 — they share the reviews-v1 Service |
| `serviceAccount.create` | `false` for reviews-v2/v3 — they share the reviews-v1 ServiceAccount |

```sh
# Preview rendered manifests
helm template ratings ./ --set selectorLabels.app=ratings --set selectorLabels.version=v1 ...
helm lint ./
```

## EnvoyFilter (Lua)

`ratings` and `productpage` have an `EnvoyFilter` that inserts a Lua script into the `SIDECAR_INBOUND` filter chain. It adds custom headers to both inbound requests and outbound responses:

- `x-demo-header-request` — added to every inbound request
- `x-demo-header-response` — added to every response

This is a practical starting point for understanding how to extend Envoy behaviour without modifying application code. The filter is defined in [templates/envoyfilter.yaml](templates/envoyfilter.yaml).

## License

MIT
