# Kubernetes Setup Guide

This guide explains how to use the modular Kubernetes setup in the dotfiles repository.

## Overview

The Kubernetes setup provides a modular, configurable local Kubernetes environment using
Kind (Kubernetes in Docker). The setup includes several components that can be enabled or
disabled as needed:

- **MetalLB**: Load balancer implementation for Kubernetes
- **Ingress NGINX**: Ingress controller for routing external traffic
- **Cert Manager**: Certificate management for Kubernetes
- **Prometheus Stack**: Monitoring and alerting
- **Metrics Server**: Resource metrics for Kubernetes

## Quick Start

To set up a Kubernetes cluster with the default configuration:

```bash
cd ~/.dotfiles
./install/kubernetes.sh
```

This will install all necessary tools and set up a Kind cluster with the components enabled in
your configuration.

## Configuration

The Kubernetes setup uses a `.env` file for configuration. You can customize which components are
enabled or disabled using the `k8s-config` command:

```bash
# List current configuration
k8s-config --list

# Enable a component
k8s-config metallb

# Disable a component
k8s-config no-prometheus

# Enable all components
k8s-config --enable-all

# Disable all components
k8s-config --disable-all

# Reset to default configuration
k8s-config --reset
```

## Component Dependencies

Some components depend on others:

- **Metrics Server** depends on **Cert Manager**
- **Ingress NGINX** works best with **MetalLB**

The setup scripts will handle these dependencies automatically.

## Configuration File

The configuration is stored in `~/.dotfiles/etc/kind/.env`. This file is created from the template
at `~/.dotfiles/etc/kind/.env.template` if it doesn't exist.

You can edit this file directly, but it's recommended to use the `k8s-config` command to ensure
proper formatting.

## Advanced Usage

### Manual Component Installation

You can manually install specific components:

```bash
# Source the common functions
source ~/.dotfiles/install/kubernetes/common.sh

# Install a specific component
source ~/.dotfiles/install/kubernetes/components/metallb.sh
```

### Custom Domain

By default, the setup uses `dev.test` as the local domain. You can change this by editing
the `.env` file:

```bash
# Using the k8s-config CLI to update the domain
k8s-config --list  # First check current settings
# Then manually edit the .env file
nano ~/.dotfiles/etc/kind/.env
# Change the LOCAL_DOMAIN value
```

### Testing Components

Each component has test scripts in the `~/.dotfiles/etc/kind/test/` directory. You can run these
tests to verify that components are working correctly:

```bash
sh ~/.dotfiles/etc/kind/test/test-metallb.sh
```

## Troubleshooting

### Common Issues

1. **Docker not running**: Ensure Docker is running before creating a Kind cluster
2. **Port conflicts**: If ports are already in use, the setup may fail
3. **Network issues**: If you have VPN software running, it may interfere with the network setup

### Logs and Debugging

To view logs for a specific component:

```bash
kubectl logs -n <namespace> <pod-name>
```

For example:

```bash
kubectl logs -n ingress-nginx -l app.kubernetes.io/component=controller
```

### Resetting the Cluster

If you encounter issues, you can delete and recreate the cluster:

```bash
kind delete cluster
cd ~/.dotfiles
./install/kubernetes.sh
```

## Extending the Setup

To add a new component:

1. Create a new script in `~/.dotfiles/install/kubernetes/components/`
2. Add the component to the `.env.template` file
3. Update the CLI tool in `~/.dotfiles/install/kubernetes/cli.sh`

## Resources

- [Kind Documentation](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [MetalLB Documentation](https://metallb.universe.tf/)
- [Ingress NGINX Documentation](https://kubernetes.github.io/ingress-nginx/)
- [Cert Manager Documentation](https://cert-manager.io/docs/)
- [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [Metrics Server Documentation](https://github.com/kubernetes-sigs/metrics-server)
