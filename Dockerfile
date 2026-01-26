FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV IS_WORK_COMPUTER=0

# Install minimal dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user (dotfiles shouldn't run as root)
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER testuser
WORKDIR /home/testuser

# Copy dotfiles
COPY --chown=testuser:testuser . /home/testuser/.dotfiles

# Set required environment variables for install scripts
ENV DOTFILES_DIR=/home/testuser/.dotfiles
ENV DOTFILES_EXTRA_DIR=/home/testuser/.extra
ENV XDG_CONFIG_HOME=/home/testuser/.config
ENV XDG_DATA_HOME=/home/testuser/.local/share
ENV XDG_CACHE_HOME=/home/testuser/.cache
ENV PATH="${DOTFILES_DIR}/bin:${PATH}"
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
