export PATH=$HOME/.local/bin:.node_modules/.bin/:$HOME/bin:/usr/local/bin:$PATH

export ZSH=/Users/utdemir/.oh-my-zsh

ZSH_THEME="flazz"

plugins=(
    git
    common-aliases
    httpie
    )

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export EDITOR='emacs'

. $HOME/.nix-profile/etc/profile.d/nix.sh
