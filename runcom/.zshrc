export ZSH=~/.oh-my-zsh

ZSH_THEME="austin"

plugins=(autoenv brew docker docker-compose git kubectl pip pylint heroku httpie)

# User configuration
export PATH="~/miniconda/bin:$PATH"

source $ZSH/oh-my-zsh.sh

export SSH_KEY_PATH="~/.ssh/id_macbookpro"

# Sources
source '/Users/Austin/google-cloud-sdk/completion.zsh.inc'
source '/Users/Austin/google-cloud-sdk/path.zsh.inc'
source /Users/Austin/.travis/travis.sh

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Resolve DOTFILES_DIR
READLINK=$(which greadlink || which readlink)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
  SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/projects/dotfiles" ]; then
  DOTFILES_DIR="$HOME/projects/dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Make utilities available
PATH="$DOTFILES_DIR/bin:$PATH"

# Read cache
DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"
[ -f "$DOTFILES_CACHE" ] && . "$DOTFILES_CACHE"

# Finally we can source the dotfiles (order matters)
for DOTFILE in "$DOTFILES_DIR"/system/.{alias,env,function,path}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

# Clean up
unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE EXTRAFILE

# Export
export DOTFILES_DIR DOTFILES_EXTRA_DIR
