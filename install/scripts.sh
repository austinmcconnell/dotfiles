#!/bin/bash

echo "**************************************************"
echo "Symlinking Scripts"
echo "**************************************************"

mkdir -p "$HOME"/projects/scripts

ln -sfv "$DOTFILES_DIR/scripts/reinitialize_git_repositories.py" "$HOME"/projects/scripts
ln -sfv "$DOTFILES_DIR/scripts/sort_git_repos_by_owner.py" "$HOME"/projects/scripts
ln -sfv "$DOTFILES_DIR/scripts/sort_docker_compose.py" "$HOME"/projects/scripts
ln -sfv "$DOTFILES_DIR/scripts/free-space-alert.scpt" "$HOME"/projects/scripts
ln -sfv "$DOTFILES_DIR/scripts/verify-certs.sh" "$HOME"/projects/scripts
ln -sfv "$DOTFILES_DIR/scripts/compare-env.sh" "$HOME"/projects/scripts
ln -sfv "$DOTFILES_DIR/scripts/find-command-in-path.sh" "$HOME"/projects/scripts
