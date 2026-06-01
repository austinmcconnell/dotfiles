# Taps
tap "gentleman-programming/tap"
tap "heroku/brew"
tap "molovo/revolver"
tap "zunit-zsh/zunit"
tap "bats-core/bats-core"

# Formulas (packages not owned by a topic script)
brew "autoenv"
brew "bash"
brew "bat"
brew "bats-assert"
brew "coreutils"
brew "direnv"
brew "dive"
brew "dprint"
brew "duf"
brew "dust"
brew "engram"
brew "enscript"
brew "fd"
brew "findutils"
brew "fzf"
brew "gawk"
brew "gh"
brew "gnu-sed"
brew "gnu-tar"
brew "gnu-time"
brew "grep"
brew "gnupg"
brew "hadolint"
brew "httpie"
brew "jq"
brew "nano"
brew "pandoc"
brew "ripgrep"
brew "rumdl"
brew "shellcheck"
brew "shfmt"
brew "ssh-copy-id"
brew "taplo"
brew "tree"
brew "trivy"
brew "unar"
brew "vale"
brew "vals"
brew "wget"
brew "watch"
brew "yamllint"
brew "yq"
brew "zunit"
brew "awscli"

# macOS-only formulas
brew "blueutil" if OS.mac?
brew "dockutil" if OS.mac?
brew "mas" if OS.mac? && personal?
brew "wifi-password" if OS.mac?

# macOS-only casks
if OS.mac?
  cask "alfred"
  cask "backuploupe" if personal?
  cask "bartender"
  cask "basictex"
  cask "bluesnooze"
  cask "calibre" if personal?
  cask "chatgpt"
  cask "discord" if personal?
  cask "docker" if personal?
  cask "evernote"
  cask "flux-app"
  cask "firefox"
  cask "gpg-suite"
  cask "hazel" if personal?
  cask "iterm2"
  cask "keepingyouawake" if personal?
  cask "monitorcontrol"
  cask "multipass"
  cask "obsidian"
  cask "openlens"
  cask "oversight"
  cask "postico"
  cask "postman"
  cask "rectangle"
  cask "redis-insight"
  cask "slack" if personal?
  cask "spotify"
  cask "sublime-text"
  cask "tableplus"
  cask "the-unarchiver"
  cask "typora"
  cask "vagrant"
  cask "via"
  cask "viscosity" if personal?
  cask "visual-studio-code"
  cask "zoom"

  # Fonts
  cask "font-fira-code"
  cask "font-meslo-lg-nerd-font"
  cask "font-fira-code-nerd-font"
  cask "font-hack-nerd-font"
  cask "font-inconsolata-nerd-font"
  cask "font-sauce-code-pro-nerd-font"

  # TLS tooling
  brew "mkcert"
  brew "nss"
end
