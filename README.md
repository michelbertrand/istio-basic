# Istio Basic

A Helm chart and automated setup for deploying the [Istio Bookinfo](https://istio.io/latest/docs/examples/bookinfo/) sample application on Minikube. The setup is fully idempotent — you can run it multiple times safely.

## Prerequisites

- Debian or Ubuntu Linux
- `curl` and `wget`

The [install.sh](install.sh) script handles all other tool installation automatically (Docker, Minikube, kubectl, Helm, istioctl).

## Quick Start

```sh
git clone <repo-url>
cd istio-basic
./install.sh
```

That's it. The script runs four steps in order:

1. **Prerequisites** — installs Docker, Minikube, kubectl, Helm, and istioctl
2. **Minikube** — starts a cluster (4 CPU, 4 GB RAM, docker driver)
3. **Istio** — installs Istio with the `demo` profile
4. **Bookinfo** — deploys all services and Istio networking resources

> **Note:** If Docker is freshly installed, the script will ask you to start a new shell session (to reload group membership) and then re-run.

## Teardown

```sh
./uninstall.sh                   # remove app + Istio, stop Minikube
./uninstall.sh --delete-minikube # also delete the Minikube cluster
```

## Skipping Steps

Each step is idempotent, so you can skip steps you've already completed:

```sh
./install.sh --skip-prerequisites --skip-minikube   # re-install Istio + app
./install.sh --skip-prerequisites --skip-minikube --skip-istio   # re-deploy app only
```

## Configuration

All steps accept environment variable overrides:

| Variable | Default | Description |
|---|---|---|
| `MINIKUBE_MEMORY` | `4096` | RAM in MB |
| `MINIKUBE_CPUS` | `4` | CPU count |
| `MINIKUBE_DISK` | `20g` | Disk size |
| `MINIKUBE_DRIVER` | `docker` | Minikube driver |
| `MINIKUBE_K8S_VER` | `stable` | Kubernetes version |
| `ISTIO_PROFILE` | `demo` | Istio install profile |
| `ISTIO_VERSION` | latest | Pin istioctl version |
| `NAMESPACE` | `bookinfo` | Kubernetes namespace |
| `IMAGE_TAG` | `1.20.3` | Bookinfo image tag |

Example:

```sh
MINIKUBE_MEMORY=8192 MINIKUBE_CPUS=6 ./install.sh
```

## Helm Chart

The `./` directory is a single Helm chart instantiated once per Bookinfo microservice. Key `values.yaml` options:

| Key | Description |
|---|---|
| `selectorLabels` | Pod selector and EnvoyFilter workload selector |
| `podLabels` | Must match `selectorLabels` for Istio routing |
| `envoyFilter.create` | Enable the Lua HTTP filter (enabled for `ratings` and `productpage`) |
| `service.create` | Set `false` for reviews-v2/v3 (share the v1 service) |
| `serviceAccount.create` | Set `false` for reviews-v2/v3 (share the v1 service account) |

To preview the rendered manifests for any release:

```sh
helm template ratings ./ --set selectorLabels.app=ratings --set selectorLabels.version=v1 ...
helm lint ./
```

## EnvoyFilter

An Istio `EnvoyFilter` injects a Lua script into the `SIDECAR_INBOUND` filter chain. It adds custom headers to both requests and responses:

- `x-demo-header-request` on inbound requests
- `x-demo-header-response` on responses

The filter is defined in [templates/envoyfilter.yaml](templates/envoyfilter.yaml) and enabled per-release via `envoyFilter.create=true`.

## Verify the Application

After installation, confirm everything is working:

```sh
kubectl exec "$(kubectl get pod -l app=ratings -n bookinfo -o jsonpath='{.items[0].metadata.name}')" \
  -c ratings -n bookinfo -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"
```

Get the external URL:

```sh
minikube service productpage -n bookinfo --url
```

## License

MIT
