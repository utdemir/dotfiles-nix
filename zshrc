export PATH=$HOME/.local/bin:node_modules/.bin/:$HOME/bin:/usr/local/bin:$PATH

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="flazz"

plugins=(
    git
    aws
    )

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export EDITOR='emacs -nw'

. $HOME/.nix-profile/etc/profile.d/nix.sh

## CUSTOM SCRIPTS

function trace() {
    echo "! $@"; $@
}

function gh() {
  if [[ "$#" == 1 ]]; then
    repo="$(echo $1 | cut -f1 -d/)"
    owner="$(echo $1 | cut -f2 -d/)"
  elif [[ "$#" == 2 ]]; then
    repo="$1"
    owner="$2"
  else
    echo "Invalid params" >&2
  fi
  
  root="$HOME/Documents/workspace/github"
  tmpdir=$(mktemp -d)
  
  if ! [[ -e "$root/$repo/$owner" ]]; then
      url="git@github.com:$repo/$owner"
      if trace git clone --depth 1 "$url" "$tmpdir"; then
        trace mkdir -p "$root/$repo"
        trace mv "$tmpdir" "$root/$repo/$owner"
        trace cd "$root/$repo/$owner"
      else
        trace rm -rf $tmpdir; return
      fi
  else
      trace cd "$root/$repo/$owner"
      git fetch
  fi

}

alias t2="tree -L 2"
alias t3="tree -L 3"
alias t4="tree -L 4" 
alias t5="tree -L 5"
