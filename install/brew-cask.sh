if ! is-macos -o ! is-executable brew; then
  echo "Skipped: Homebrew-Cask"
  return
fi

brew tap caskroom/cask
brew tap caskroom/fonts

# Install packages

apps=(
  atom
  authy
  betterzip
  docker
  dropbox
  evernote
  flux
  google-chrome
  hazel
  iterm2
  keepingyouawake
  macdown
  nextcloud
  oversight
  postico
  slack
  steam
  spectacle
  transmission
  viscosity
)

brew cask install "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv qlimagesize webpquicklook
