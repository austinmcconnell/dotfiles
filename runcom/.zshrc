export ZSH=~/.oh-my-zsh

ZSH_THEME="austin"

DOTFILES_DIR="$HOME/projects/dotfiles"
export DOTFILES_DIR
# Make utilities available
PATH="$DOTFILES_DIR/bin:$PATH"

# Finally we can source the dotfiles (order matters)
for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function,path}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

plugins=(autoenv brew docker docker-compose git kubectl pip pipenv heroku httpie zsh-kubectl-prompt zsh-nvm)

source $ZSH/oh-my-zsh.sh

export SSH_KEY_PATH=~/.ssh/id_macbookpro

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'; fi

#PyEnv
eval "$(pyenv init -)"

#NVM
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Stern (kubernetes log streaming)
source <(stern --completion=zsh)

# Source chtf
if [[ -f /usr/local/share/chtf/chtf.sh ]]; then
    source "/usr/local/share/chtf/chtf.sh"
fi
