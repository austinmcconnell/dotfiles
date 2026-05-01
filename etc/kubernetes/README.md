# Kubernetes Setup Guide

This guide explains the local Kubernetes environment in the dotfiles repository.

## Overview

The setup provides a local Kubernetes cluster using k3d (k3s in Docker) with Helm charts managed
declaratively by helmfile.

**Runtime**: k3d — lightweight k3s nodes running as Docker containers **Chart management**: helmfile
— declarative Helm release configuration **Charts deployed**: ingress-nginx, cert-manager,
metrics-server, kube-prometheus-stack

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
- `kube-prometheus-stack.yaml.gotmpl` — ingress config using `LOCAL_DOMAIN`

## Architecture

```text
etc/kubernetes/
├── helmfile.yaml                          ← chart releases and dependency ordering
├── k3d-config.yaml                        ← cluster shape and port mappings
├── .env.template                          ← environment variable defaults
├── limit-range.yaml                       ← default container resource limits
├── resource-quota.yaml                    ← default namespace resource quotas
├── values/
│   ├── cert-manager.yaml
│   ├── kube-prometheus-stack.yaml.gotmpl
│   └── metrics-server.yaml
├── manifests/
│   └── cert-manager-cluster-issuer.yaml
└── test/
    ├── test-ingress-nginx-port-forward.sh
    ├── test-ingress-nginx-hosts-entry.sh
    ├── test-cert-manager.sh
    ├── test-metrics-server.sh
    └── test-horizontal-pod-autoscaler.sh

install/kubernetes/
├── setup.sh                               ← main entry point
├── common.sh                              ← shared functions and env loading
├── k3d-create.sh                          ← cluster creation
├── hooks/
│   └── configure-cert-manager.sh          ← helmfile postsync hook
└── components/
    ├── limit-range.sh                     ← kubectl-applied LimitRange
    └── resource-quota.sh                  ← kubectl-applied ResourceQuota
```

## Testing Components

Test scripts are in `etc/kubernetes/test/`. The setup runs them automatically, but you can run them
individually:

```bash
sh ~/.dotfiles/etc/kubernetes/test/test-ingress-nginx-port-forward.sh
sh ~/.dotfiles/etc/kubernetes/test/test-ingress-nginx-hosts-entry.sh
sh ~/.dotfiles/etc/kubernetes/test/test-cert-manager.sh
sh ~/.dotfiles/etc/kubernetes/test/test-metrics-server.sh
sh ~/.dotfiles/etc/kubernetes/test/test-horizontal-pod-autoscaler.sh
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

## Resources

- [k3d Documentation](https://k3d.io/)
- [Helmfile Documentation](https://helmfile.readthedocs.io/)
- [Ingress NGINX Documentation](https://kubernetes.github.io/ingress-nginx/)
- [Cert Manager Documentation](https://cert-manager.io/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [Metrics Server Documentation](https://github.com/kubernetes-sigs/metrics-server/)
