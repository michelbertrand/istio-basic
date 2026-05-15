# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [1.1.0] - 15-05-2025
### Added
- `install.sh` — single idempotent entry point that runs all setup steps in order
- `uninstall.sh` — full teardown with `--delete-minikube` and `--keep-istio` flags
- `scripts/common.sh` — shared logging helpers and idempotency check functions
- `scripts/01-setup-prerequisites.sh` — automated installation of Docker, Minikube, kubectl, Helm, and istioctl on Debian/Ubuntu
- `scripts/02-setup-minikube.sh` — Minikube startup with configurable memory, CPU, disk, and driver via environment variables
- `scripts/03-install-istio.sh` — Istio installation via `istioctl` (demo profile, configurable)
- `scripts/04-deploy-bookinfo.sh` — idempotent Bookinfo deployment using `helm upgrade --install`
- `.gitignore`

### Changed
- Helm releases now use `helm upgrade --install` (idempotent) instead of `helm install`
- All Helm releases now scoped to the `bookinfo` namespace explicitly
- README rewritten to reflect the new setup workflow
- `bookinfo-gateway.yaml` applied via `kubectl apply` in `04-deploy-bookinfo.sh`

## [1.0.4] - 07-04-2025
### Added
- Initial release of the Istio Basic Helm Chart.
- Ratings service
- Reviews service v1, v2 and v3
- Productpage service
- Envoy filter using Lua scripts
- General error fix / Specially for pod labels in Service
- The default log level for istio-proxy is warn, change the lua scipt to use logWarn instead of logInfo
- Added script to manage creation or deletion of the chart from bookinfo and istio resources
- Bug fxes to create the application
- Add response handler to the Lua script in the Envoy filter