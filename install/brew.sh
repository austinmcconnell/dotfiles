if ! is-macos -o ! is-executable ruby -o ! is-executable curl -o ! is-executable git; then
  echo "Skipped: Homebrew (missing: ruby, curl and/or git)"
  return
fi

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap Goles/battery
brew update
brew upgrade

# Install packages

apps=(
  autoenv
  bats
  battery
  coreutils
  diff-so-fancy
  docker
  dockutil
  git
  git-extras
  grep --with-default-names
  heroku
  httpie
  hub
  mackup
  nano
  postgresql --with-python3
  psgrep
  pyenv
  python3
  shellcheck
  ssh-copy-id
  tree
  unar
  wget
  wifi-password
)

brew install "${apps[@]}"

export DOTFILES_BREW_PREFIX_COREUTILS=`brew --prefix coreutils`
set-config "DOTFILES_BREW_PREFIX_COREUTILS" "$DOTFILES_BREW_PREFIX_COREUTILS" "$DOTFILES_CACHE"

ln -sfv "$DOTFILES_DIR/etc/mackup/.mackup.cfg" ~