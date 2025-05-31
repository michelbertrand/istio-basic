# Istio Basic Helm Chart

This project provides a basic [Helm](https://helm.sh/) chart for deploying a simple application with [Istio](https://istio.io/) integration on Kubernetes. It is designed as a starting point for learning or deploying workloads with Istio service mesh features.

## Features

- Deploys a sample application (default: NGINX) with customizable replica count and labels.
- Supports configuration of service accounts, pod security context, and container security context.
- Exposes the application via a Kubernetes Service (default: ClusterIP).
- Optional Ingress resource for external access.
- Readiness and liveness probes.
- Optional Horizontal Pod Autoscaler (HPA) configuration.
- Supports additional volumes and volume mounts.
- Designed to be compatible with Istio sidecar injection.

## Usage

1. **Install prerequisites:**
   - [Helm](https://helm.sh/docs/intro/install/)
   - [kubectl](https://kubernetes.io/docs/tasks/tools/)
   - A running Kubernetes cluster with Istio installed

2. **Clone this repository:**
   ```sh
   git clone <repo-url>
   cd istio-basic
   ```

3. **Install the chart:**
   ```sh
   helm install my-release ./
   ```

4. **Customize deployment:**
   Edit `values.yaml` to adjust image, replicas, service type, ingress, and other settings.

## Configuration

All configuration options are available in `values.yaml`. Key options include:

- `replicaCount`: Number of application replicas
- `image.repository`: Container image to deploy
- `service.type`: Kubernetes Service type (e.g., ClusterIP, NodePort)
- `ingress.enabled`: Enable/disable ingress resource
- `autoscaling.enabled`: Enable/disable HPA

## License

This project is licensed under the MIT License.
