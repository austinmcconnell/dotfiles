#!/bin/sh

if is-executable zsh; then
  echo "**************************************************"
  echo "Configuring Zsh"
  echo "**************************************************"
else
  if is-macos; then
    echo "**************************************************"
    echo "Installing Zsh with brew"
    echo "**************************************************"
    brew install zsh
    brew install --cask font-fira-code
  elif is-debian; then
    echo "**************************************************"
    echo "Installing Zsh with apt"
    echo "**************************************************"
    sudo add-apt-repository -y universe
    sudo apt update
    sudo apt install -y zsh
    sudo apt install fonts-firacode
  else
    echo "**************************************************"
    echo "Skipping Zsh installation: Unidentified OS"
    echo "**************************************************"
    return
  fi
fi

ln -sfv "$DOTFILES_DIR/runcom/.zshrc" ~

grep "$(which zsh)" /etc/shells &>/dev/null || sudo zsh -c "echo $(which zsh) >> /etc/shells"

if [ "$SHELL" != "$(which zsh)" ]; then
  chsh --shell $(which zsh) $USER
fi

if [ -d "$HOME/.oh-my-zsh" ] ; then
  git --work-tree="$HOME/.oh-my-zsh" --git-dir="$HOME/.oh-my-zsh/.git" pull origin master;
else
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

ln -sfv "$DOTFILES_DIR/etc/zsh/austin.zsh-theme" ~/.oh-my-zsh/custom/themes/

if [ -d "$HOME/.repositories/kube-ps1/.git" ] ; then
  git --work-tree="$HOME/.repositories/kube-ps1" --git-dir="$HOME/.repositories/kube-ps1/.git" pull origin master;
else
  git clone https://github.com/jonmosco/kube-ps1.git "$HOME/.repositories/kube-ps1"
fi

if [ -d "$ZSH/themes/spaceship-prompt" ] ; then
  git --work-tree="$ZSH/themes/spaceship-prompt" --git-dir="$ZSH/themes/spaceship-prompt/.git" pull origin master;
else
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH/themes/spaceship-prompt" --depth=1
  ln -s "$ZSH/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH/themes/spaceship.zsh-theme"
fi

# if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt/.git" ] ; then
	# git --work-tree="$HOME/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt" --git-dir="$HOME/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt/.git" pull origin master;
#else
  # git clone https://github.com/superbrothers/zsh-kubectl-prompt.git "$HOME/.oh-my-zsh/custom/plugins/zsh-kubectl-prompt"
# fi


# if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-nvm/.git" ] ; then
	# git --work-tree="$HOME/.oh-my-zsh/custom/plugins/zsh-nvm" --git-dir="$HOME/.oh-my-zsh/custom/plugins/zsh-nvm/.git" pull origin master;
# else
  # git clone https://github.com/lukechilds/zsh-nvm "$HOME/.oh-my-zsh/custom/plugins/zsh-nvm"
# fi

#rm ~/.zcompdump*

# Setup terminfo
mkdir -p "$HOME"/.terminfo
tic -o "$HOME"/.terminfo "$DOTFILES_DIR"/etc/terminfo/tmux.terminfo
tic -o "$HOME"/.terminfo "$DOTFILES_DIR"/etc/terminfo/tmux-256color.terminfo
tic -o "$HOME"/.terminfo "$DOTFILES_DIR"/etc/terminfo/xterm-256color.terminfo
