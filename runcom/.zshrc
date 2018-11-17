export ZSH=~/.oh-my-zsh

ZSH_THEME="austin"

plugins=(autoenv brew docker docker-compose git kubectl pip pipenv heroku httpie)

source $ZSH/oh-my-zsh.sh

export SSH_KEY_PATH=~/.ssh/id_macbookpro

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

DOTFILES_DIR="$HOME/projects/dotfiles"

# Make utilities available
PATH="$DOTFILES_DIR/bin:$PATH"

# Finally we can source the dotfiles (order matters)
for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function,path}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

# Export
export DOTFILES_DIR DOTFILES_EXTRA_DIR

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'; fi

#PyEnv
eval "$(pyenv init -)"
