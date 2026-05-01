# Kubernetes Setup Guide

This guide explains the local Kubernetes environment in the dotfiles repository.

## Overview

The setup provides a local Kubernetes cluster using k3d (k3s in Docker) with Helm charts managed
declaratively by helmfile.

**Runtime**: k3d — lightweight k3s nodes running as Docker containers **Chart management**: helmfile
— declarative Helm release configuration **Charts deployed**: ingress-nginx, cert-manager,
metrics-server, kube-prometheus-stack, loki, alloy, podinfo (frontend + backend)

## Quick Start

```bash
cd ~/.dotfiles
./install/kubernetes/setup.sh
```

This installs tools (k3d, kubectl, helm, helmfile, mkcert), creates a k3d cluster, deploys all
charts, configures cert-manager with a local CA, adds `/etc/hosts` entries, and runs component
tests.

## Prerequisites

On macOS, `setup.sh` installs these automatically via Homebrew:

- k3d
- kubectl
- kubectx
- helm
- helmfile
- mkcert

## Configuration

### Environment variables

Configuration lives in `~/.dotfiles/etc/kubernetes/.env`, created from `.env.template` on first run.

| Variable                | Default    | Purpose                                              |
| ----------------------- | ---------- | ---------------------------------------------------- |
| `LOCAL_DOMAIN`          | `dev.test` | Base domain for ingress hostnames                    |
| `ENABLE_LIMIT_RANGE`    | `true`     | Apply default LimitRange to non-system namespaces    |
| `ENABLE_RESOURCE_QUOTA` | `true`     | Apply default ResourceQuota to non-system namespaces |

Chart installation is controlled by `helmfile.yaml`, not environment variables.

### Cluster configuration

The k3d cluster config is at `etc/kubernetes/k3d-config.yaml`:

- 1 server node + 2 agent nodes
- Ports 80 and 443 mapped to localhost via the k3d load balancer
- Traefik and the built-in metrics-server are disabled (replaced by ingress-nginx and the helmfile
  metrics-server chart)

### Helm values

Chart values are in `etc/kubernetes/values/`:

- `cert-manager.yaml` — enables CRDs
- `metrics-server.yaml` — kubelet args and insecure TLS for k3s
- `kube-prometheus-stack.yaml.gotmpl` — ingress config using `LOCAL_DOMAIN`, Loki datasource
- `loki.yaml` — monolithic mode, filesystem storage, 7-day retention
- `alloy.yaml` — DaemonSet log collector, ships pod logs to Loki
- `podinfo-frontend.yaml.gotmpl` — ingress, TLS, ServiceMonitor, backend URL
- `podinfo-backend.yaml` — Redis enabled, ServiceMonitor

## Components

### Ingress & TLS

- **ingress-nginx** — Ingress controller routing external traffic to services
- **cert-manager** — Automatic TLS certificates via a local mkcert CA

### Monitoring & Observability

- **kube-prometheus-stack** — Prometheus (metrics), Grafana (dashboards), Alertmanager (alerts)
- **metrics-server** — Node and pod resource metrics for `kubectl top` and HPA
- **Loki** — Log aggregation with label-based indexing (monolithic mode, filesystem storage)
- **Alloy** — DaemonSet log collector shipping pod logs to Loki via the Kubernetes API

### Sample Workload

- **Podinfo frontend** — Go microservice exposed via ingress at `podinfo.dev.test`, forwards `/echo`
  requests to the backend
- **Podinfo backend** — Internal service with Redis caching, serves echo and cache endpoints

Both podinfo services expose Prometheus metrics via ServiceMonitor CRDs.

## Architecture

```text
etc/kubernetes/
├── helmfile.yaml                          ← chart releases and dependency ordering
├── k3d-config.yaml                        ← cluster shape and port mappings
├── .env.template                          ← environment variable defaults
├── limit-range.yaml                       ← default container resource limits
├── resource-quota.yaml                    ← default namespace resource quotas
├── values/
│   ├── alloy.yaml
│   ├── cert-manager.yaml
│   ├── kube-prometheus-stack.yaml.gotmpl
│   ├── loki.yaml
│   ├── metrics-server.yaml
│   ├── podinfo-backend.yaml
│   └── podinfo-frontend.yaml.gotmpl
├── manifests/
│   └── cert-manager-cluster-issuer.yaml
└── test/
    ├── alloy.bats
    ├── cert-manager.bats
    ├── helmfile-releases.bats
    ├── ingress-nginx.bats
    ├── loki.bats
    ├── metrics-server.bats
    ├── podinfo.bats
    └── prometheus-stack.bats

install/kubernetes/
├── setup.sh                               ← main entry point
├── common.sh                              ← shared functions and env loading
├── hooks/
│   └── configure-cert-manager.sh          ← helmfile postsync hook
```

## Testing Components

Tests use [bats](https://github.com/bats-core/bats-core) and run automatically during setup. Run
them manually:

```bash
bats ~/.dotfiles/etc/kubernetes/test/
```

Or run individual test files:

```bash
bats ~/.dotfiles/etc/kubernetes/test/loki.bats
bats ~/.dotfiles/etc/kubernetes/test/podinfo.bats
```

## Troubleshooting

### Resetting the cluster

```bash
k3d cluster delete dev
./install/kubernetes/setup.sh
```

### Checking chart status

```bash
helmfile --file etc/kubernetes/helmfile.yaml list
```

### Common issues

- **Docker not running**: k3d requires Docker. Start Docker Desktop first.
- **Port conflicts**: If ports 80/443 are in use, the k3d load balancer will fail to start.
- **metrics-server TLS errors**: The `--kubelet-insecure-tls` flag in the values file handles k3s
  certificate differences. If metrics-server pods crash, verify the flag is present.
- **etcd/scheduler metrics warnings**: k3s exposes these differently than kubeadm clusters. Warnings
  from kube-prometheus-stack are expected and harmless.
- **Loki PVC data loss**: k3d stores PVC data inside Docker containers. Deleting the cluster
  (`k3d cluster delete`) destroys all Loki log data. This is expected for a dev cluster.

## Resources

- [k3d Documentation](https://k3d.io/)
- [Helmfile Documentation](https://helmfile.readthedocs.io/)
- [Ingress NGINX Documentation](https://kubernetes.github.io/ingress-nginx/)
- [Cert Manager Documentation](https://cert-manager.io/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [Metrics Server Documentation](https://github.com/kubernetes-sigs/metrics-server/)
- [Grafana Loki Documentation](https://grafana.com/docs/loki/latest/)
- [Grafana Alloy Documentation](https://grafana.com/docs/alloy/latest/)
- [Podinfo Documentation](https://github.com/stefanprodan/podinfo)
