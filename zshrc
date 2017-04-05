export PATH=$HOME/.local/bin:node_modules/.bin/:$HOME/bin:/usr/local/opt/coreutils/libexec/gnubin:/usr/bin:/bin:$PATH

ZSH_CUSTOM=$HOME/.zsh_custom

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="utdemir"

plugins=(
    git
    aws
    kubectl
    )

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export EDITOR='emacs -nw'

. $HOME/.nix-profile/etc/profile.d/nix.sh

if [[ -e $HOME/.zshrc_local ]]; then
  . $HOME/.zshrc_local
fi

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
      trace git fetch
  fi

}

alias t1="tree -L 1"
alias t2="tree -L 2"
alias t3="tree -L 3"
alias t4="tree -L 4" 
alias t5="tree -L 5"
