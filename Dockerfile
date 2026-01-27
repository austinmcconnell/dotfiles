# Dockerfile for Testing Dotfiles Installation
#
# PURPOSE: Provide a clean, repeatable environment to test the install scripts
# in isolation without affecting the host system.
#
# CRITICAL PRINCIPLE: This Dockerfile should NOT manually install tools that
# the install scripts are designed to install. Instead, it should:
#   1. Set up the base environment (OS, dependencies, env vars)
#   2. Fix environmental issues (SSL certs, permissions, etc.)
#   3. Let the install scripts do their job exactly as they would on a real system
#
# DO NOT add manual installations of tools like ruby, node, python, starship, etc.
# If an install script fails, fix the ENVIRONMENT or the SCRIPT, not the Dockerfile.
# The goal is to test that the install scripts work correctly on a fresh system.

FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Chicago
ENV IS_WORK_COMPUTER=0

# Configure timezone (must be done before any package installation)
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Homebrew dependencies (from Homebrew docs)
RUN apt-get update && apt-get install -y \
    build-essential \
    procps \
    curl \
    file \
    git \
    sudo \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user (Homebrew requires non-root)
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Add custom CA certificate if provided (for corporate proxies, Cloudflare WARP, etc.)
# Usage: docker build --build-arg CUSTOM_CA_CERT="$(cat /path/to/cert.pem)" ...
ARG CUSTOM_CA_CERT=""
RUN if [ -n "$CUSTOM_CA_CERT" ]; then \
        echo "$CUSTOM_CA_CERT" > /usr/local/share/ca-certificates/custom-ca.crt && \
        update-ca-certificates; \
    else \
        update-ca-certificates; \
    fi

USER testuser
WORKDIR /home/testuser

# Install Homebrew
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

# Copy dotfiles
COPY --chown=testuser:testuser . /home/testuser/.dotfiles

# Set required environment variables for install scripts
ENV DOTFILES_DIR=/home/testuser/.dotfiles
ENV DOTFILES_EXTRA_DIR=/home/testuser/.extra
ENV XDG_CONFIG_HOME=/home/testuser/.config
ENV XDG_DATA_HOME=/home/testuser/.local/share
ENV XDG_CACHE_HOME=/home/testuser/.cache
ENV PATH="${DOTFILES_DIR}/bin:${PATH}"
# Fix SSL certificate issues in Docker for downloads (brew, pyenv, etc.)
ENV HOMEBREW_CURLRC=1
ENV HOMEBREW_NO_VERIFY_ATTESTATIONS=1
ENV CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
# Skip SSL verification for pyenv downloads (Docker network issue)
ENV PYTHON_BUILD_CURL_OPTS="--insecure"
ENV PYTHON_BUILD_WGET_OPTS="--no-check-certificate"

# For Docker builds, comment out SSH URL rewriting in git config
RUN sed -i '/\[url "git@github.com:"\]/,/pushInsteadOf/s/^/#/' ${DOTFILES_DIR}/etc/git/config

# Create required directories
RUN mkdir -p ${XDG_CONFIG_HOME} ${XDG_DATA_HOME} ${XDG_CACHE_HOME} ${DOTFILES_EXTRA_DIR}

# Core installations
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/git.sh"
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/zsh.sh"
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/apt.sh"

# Language installations (separate for caching and visibility)
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/python.sh"
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/ruby.sh"
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/node.sh"
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/go.sh"

# Remaining installations
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/vim.sh"
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/scripts.sh"
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/ssh.sh"
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/dircolors.sh"
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/xdg-compliance.sh"
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/glow.sh"
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/terraform.sh"

# Default to zsh shell
CMD ["/usr/bin/zsh"]
