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
#
# LAYER CACHING STRATEGY: Each install script gets only the files it needs
# copied immediately before its RUN. This prevents unrelated config changes
# from invalidating expensive compilation layers. For example, editing
# etc/vim/.vimrc won't trigger a Python or Ruby rebuild.

FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Chicago
ENV IS_WORK_COMPUTER=0
# Set locale to prevent warnings
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Configure timezone (must be done before any package installation)
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Homebrew dependencies (from Homebrew docs) and base OS utilities
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    file \
    git \
    locales \
    procps \
    sudo \
    && locale-gen en_US.UTF-8

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

# Create required directories
RUN mkdir -p ${XDG_CONFIG_HOME} ${XDG_DATA_HOME} ${XDG_CACHE_HOME} ${DOTFILES_EXTRA_DIR}

# --- Per-script COPY strategy ---
# Each install script gets only the files it needs copied before its RUN.
# This prevents unrelated config changes from invalidating expensive layers.

# Shared dependencies (needed by almost all install scripts)
COPY --chown=testuser:testuser bin/ ${DOTFILES_DIR}/bin/
COPY --chown=testuser:testuser install/utils.sh ${DOTFILES_DIR}/install/utils.sh

# Create .extra env config (required by utils.sh and other scripts)
RUN echo "export IS_WORK_COMPUTER=0" > ${DOTFILES_EXTRA_DIR}/.env

# --- git (needed by everything that clones repos) ---
COPY --chown=testuser:testuser install/git.sh ${DOTFILES_DIR}/install/git.sh
COPY --chown=testuser:testuser etc/git/ ${DOTFILES_DIR}/etc/git/
RUN sed -i '/\[url "git@github.com:"\]/,/pushInsteadOf/s/^/#/' ${DOTFILES_DIR}/etc/git/config
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/git.sh"

# --- zsh (sets up ZDOTDIR, functions, completions) ---
COPY --chown=testuser:testuser install/zsh.sh ${DOTFILES_DIR}/install/zsh.sh
COPY --chown=testuser:testuser etc/zsh/ ${DOTFILES_DIR}/etc/zsh/
COPY --chown=testuser:testuser etc/starship/ ${DOTFILES_DIR}/etc/starship/
COPY --chown=testuser:testuser etc/spaceship/ ${DOTFILES_DIR}/etc/spaceship/
COPY --chown=testuser:testuser etc/direnv/ ${DOTFILES_DIR}/etc/direnv/
COPY --chown=testuser:testuser etc/terminfo/ ${DOTFILES_DIR}/etc/terminfo/
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/zsh.sh"

# --- brew (installs CLI tools needed by later scripts) ---
COPY --chown=testuser:testuser install/brew.sh ${DOTFILES_DIR}/install/brew.sh
COPY --chown=testuser:testuser etc/misc/ ${DOTFILES_DIR}/etc/misc/
COPY --chown=testuser:testuser etc/fd/ ${DOTFILES_DIR}/etc/fd/
COPY --chown=testuser:testuser etc/httpie/ ${DOTFILES_DIR}/etc/httpie/
COPY --chown=testuser:testuser etc/bat/ ${DOTFILES_DIR}/etc/bat/
COPY --chown=testuser:testuser etc/sublime-text/ ${DOTFILES_DIR}/etc/sublime-text/
RUN --mount=type=cache,target=/home/testuser/.cache/Homebrew,uid=1000,gid=1000 \
    bash -c "cd ${DOTFILES_DIR} && source ./install/brew.sh"

# --- apt (Linux build dependencies for compiling languages) ---
COPY --chown=testuser:testuser install/apt.sh ${DOTFILES_DIR}/install/apt.sh
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/apt.sh"

# --- Language installations (ordered by build time, slowest first) ---

# python (~2 min — compiles from source)
COPY --chown=testuser:testuser install/python.sh ${DOTFILES_DIR}/install/python.sh
COPY --chown=testuser:testuser etc/python/ ${DOTFILES_DIR}/etc/python/
RUN --mount=type=cache,target=/home/testuser/.cache,uid=1000,gid=1000 \
    bash -c "cd ${DOTFILES_DIR} && source ./install/python.sh" 2>&1 | tee /tmp/python-install.log

# ruby (~2 min — compiles from source)
COPY --chown=testuser:testuser install/ruby.sh ${DOTFILES_DIR}/install/ruby.sh
COPY --chown=testuser:testuser etc/ruby/ ${DOTFILES_DIR}/etc/ruby/
RUN --mount=type=cache,target=/home/testuser/.cache,uid=1000,gid=1000 \
    bash -c "export RUBY_CONFIGURE_OPTS='--with-openssl-dir=$(brew --prefix openssl@3)' && \
    cd ${DOTFILES_DIR} && source ./install/ruby.sh" 2>&1 | tee /tmp/ruby-install.log

# go (~1 min — installs tools from source)
COPY --chown=testuser:testuser install/go.sh ${DOTFILES_DIR}/install/go.sh
RUN --mount=type=cache,target=/home/testuser/.cache,uid=1000,gid=1000 \
    bash -c "cd ${DOTFILES_DIR} && source ./install/go.sh" 2>&1 | tee /tmp/go-install.log

# node (~24s — fnm + npm packages)
COPY --chown=testuser:testuser install/node.sh ${DOTFILES_DIR}/install/node.sh
COPY --chown=testuser:testuser etc/node/ ${DOTFILES_DIR}/etc/node/
RUN --mount=type=cache,target=/home/testuser/.cache,uid=1000,gid=1000 \
    rm -f ${XDG_CACHE_HOME}/node_packages_timestamp && \
    bash -c "cd ${DOTFILES_DIR} && source ./install/node.sh" 2>&1 | tee /tmp/node-install.log

# --- Remaining installations (fast, minimal dependencies) ---
COPY --chown=testuser:testuser install/vim.sh ${DOTFILES_DIR}/install/vim.sh
COPY --chown=testuser:testuser etc/vim/ ${DOTFILES_DIR}/etc/vim/
COPY --chown=testuser:testuser etc/ag/ ${DOTFILES_DIR}/etc/ag/
COPY --chown=testuser:testuser etc/yaml/ ${DOTFILES_DIR}/etc/yaml/
RUN bash -c "cd ${DOTFILES_DIR} && source ./install/vim.sh"

COPY --chown=testuser:testuser install/ssh.sh ${DOTFILES_DIR}/install/ssh.sh
COPY --chown=testuser:testuser install/dircolors.sh ${DOTFILES_DIR}/install/dircolors.sh
COPY --chown=testuser:testuser install/xdg-compliance.sh ${DOTFILES_DIR}/install/xdg-compliance.sh
COPY --chown=testuser:testuser install/glow.sh ${DOTFILES_DIR}/install/glow.sh
COPY --chown=testuser:testuser etc/dircolors/ ${DOTFILES_DIR}/etc/dircolors/
COPY --chown=testuser:testuser etc/glow/ ${DOTFILES_DIR}/etc/glow/
RUN bash -c "cd ${DOTFILES_DIR} && \
    source ./install/ssh.sh && \
    source ./install/dircolors.sh && \
    source ./install/xdg-compliance.sh && \
    source ./install/glow.sh"

# --- Stage 2: Copy remaining files (tests, scripts, docs, etc.) ---
# This layer changes frequently but is cheap — no compilation.
COPY --chown=testuser:testuser . ${DOTFILES_DIR}

# Initialize a git repo so tests that need git context (e.g. get_trunk_branch) work.
# We exclude .git/ from the build context to avoid cache-busting on every commit.
RUN cd ${DOTFILES_DIR} && git init && git checkout -b main && \
    git add -A && git commit --no-gpg-sign -m "init" --quiet && \
    git remote add origin https://github.com/placeholder/dotfiles.git && \
    git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main && \
    git update-ref refs/remotes/origin/main HEAD

# Default to zsh shell
CMD ["/usr/bin/zsh"]
