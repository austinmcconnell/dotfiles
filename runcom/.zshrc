export ZSH=~/.oh-my-zsh

ZSH_THEME="austin"

ENABLE_CORRECTION="false"

COMPLETION_WAITING_DOTS="true"

plugins=(autoenv brew docker docker-compose git kubectl pip pylint heroku httpie)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin"
export PATH="/Users/Austin/miniconda/bin:$PATH"
export PATH="/usr/local/opt/sqlite/bin:$PATH"
export PYLINTRC='/users/austin/projects/pylintrc/pylintrc'

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='subl --new-window --wait'
fi

export SSH_KEY_PATH="~/.ssh/id_macbookpro"

# Sources
source ~/.alias
source '/Users/Austin/google-cloud-sdk/completion.zsh.inc'
source '/Users/Austin/google-cloud-sdk/path.zsh.inc'
source /Users/Austin/.travis/travis.sh
