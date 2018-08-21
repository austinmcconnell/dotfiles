if ! is-macos -o ! is-executable brew; then
  echo "Skipped: zsh 4"
  return
fi

brew install zsh

grep "/usr/local/bin/zsh" /private/etc/shells &>/dev/null || sudo zsh -c "echo /usr/local/bin/zsh  >> /private/etc/shells"
chsh -s /usr/local/bin/zsh

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

ln -sfv "$DOTFILES_DIR/zsh/austin.zsh-theme" ~/.oh-my-zsh/custom/themes/
