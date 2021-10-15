export ZSH=~/.oh-my-zsh

ZSH_THEME="spaceship"

DOTFILES_DIR="$HOME/projects/dotfiles"
export DOTFILES_DIR
# Make utilities available
PATH="$DOTFILES_DIR/bin:$PATH"

# Finally we can source the dotfiles (order matters)
for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function,path}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

if is-macos; then
  for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function,path}.macos; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
  done
fi

# Hook for extra/custom stuff
DOTFILES_EXTRA_DIR="$HOME/.extra"

if [ -d "$DOTFILES_EXTRA_DIR" ]; then
    for EXTRAFILE in "$DOTFILES_EXTRA_DIR"/.{env,alias,function,path}; do
      [ -f "$EXTRAFILE" ] && . "$EXTRAFILE"
    done
fi

plugins=(brew docker docker-compose git httpie nvm pip pipenv terraform)

source $ZSH/oh-my-zsh.sh
source "$HOME/.repositories/kube-ps1/kube-ps1.sh"
source <(kubectl completion zsh)

export SSH_KEY_PATH=~/.ssh/id_macbookpro

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc' ]; then source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc' ]; then source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'; fi

# Source chtf
if [[ -f /usr/local/share/chtf/chtf.sh ]]; then
    source "/usr/local/share/chtf/chtf.sh"
fi

# Add function to test zsh startup time
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}
zmodload zsh/zprof  # Call zprof to get startup profiling

SPACESHIP_DOCKER_SHOW=false
SPACESHIP_GCLOUD_SHOW=false
SPACESHIP_NODE_SHOW=false
# SPACESHIP_KUBECTL_SHOW=true
SPACESHIP_KUBECTL_VERSION_SHOW=false
SPACESHIP_VENV_GENERIC_NAMES=()
SPACESHIP_BATTERY_THRESHOLD=20
