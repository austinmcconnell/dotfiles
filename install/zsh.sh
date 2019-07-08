#!/bin/sh

if ! is-executable brew; then
  echo "**************************************************"
  echo "Skipping ZSH Installs: Homebrew not installed"
  echo "**************************************************"
  return
else
  echo "**************************************************"
  echo "Installing ZSH packages"
  echo "**************************************************"
fi

brew install zsh

grep "/usr/local/bin/zsh" /private/etc/shells &>/dev/null || sudo zsh -c "echo /usr/local/bin/zsh  >> /private/etc/shells"
if [ "$SHELL" != "/usr/local/bin/zsh" ]; then
  chsh -s /usr/local/bin/zsh
fi

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

ln -sfv "$DOTFILES_DIR/etc/zsh/austin.zsh-theme" ~/.oh-my-zsh/custom/themes/

if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt/.git" ] ; then
	git --work-tree="$HOME/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt" --git-dir="$HOME/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt/.git" pull origin master;
else
  git clone git@github.com:superbrothers/zsh-kubectl-prompt.git "$HOME/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt"
fi


if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-nvm/.git" ] ; then
	git --work-tree="$HOME/.oh-my-zsh/custom/plugins/zsh-nvm" --git-dir="$HOME/.oh-my-zsh/custom/plugins/zsh-nvm/.git" pull origin master;
else
  git clone https://github.com/lukechilds/zsh-nvm "$HOME/.oh-my-zsh/custom/plugins/zsh-nvm"
fi
