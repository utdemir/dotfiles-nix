{ config, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [ pkgs.zsh pkgs.nix-zsh-completions pkgs.zoxide ];

    home.file.".zshrc".text = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh | source /dev/stdin
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

      eval "$(zoxide init zsh)"

      # Env
      export TERM=xterm-256color

      export PASSWORD_STORE_ENABLE_EXTENSIONS=true

      # ZSH params
      REPORTTIME=3

      HISTSIZE=10000
      SAVEHIST=10000
      HISTFILE=~/.history
      APPEND_HISTORY=true

      setopt AUTO_CD
      setopt NO_FLOW_CONTROL

      # Keybindings
      bindkey "^[[3~" delete-char
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word

      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey '\C-x\C-e' edit-command-line

      unsetopt flow_control

      # Completions
      autoload -Uz compinit

      setopt always_to_end
      setopt complete_in_word
      zmodload zsh/complist
      autoload -Uz compinit
      compinit

      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Z}{a-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

      if [[ ! -e $HOME/.zcompdump ]];
      then echo "! compinit" >&2; compinit;
      else compinit -C;
      fi

      # Prompt
      autoload -U add-zsh-hook
      add-zsh-hook precmd pre_prompt
      function pre_prompt() {
        psvar[11]=${"$\{IN_NIX_SHELL:+\"nix-shell[$IN_NIX_SHELL]\"}"}
      }

      # Exit status
      AGKOZAK_CUSTOM_PROMPT='%(?..%B%F{red}(%?%)%f%b )'
      # Command execution time
      AGKOZAK_CUSTOM_PROMPT+='%(9V.%9v .)'
      # Username and hostname
      AGKOZAK_CUSTOM_PROMPT+='%(!.%S%B.%B%F{green})%n%1v%(!.%b%s.%f%b) '
      # Path
      AGKOZAK_CUSTOM_PROMPT+=$'%B%F{blue}%2v%f%b\n'
      # Nix-shell
      AGKOZAK_CUSTOM_PROMPT+="%11v"
      # Prompt character
      AGKOZAK_CUSTOM_PROMPT+='%(4V.:.%#) '
      # Git status
      AGKOZAK_CUSTOM_RPROMPT='%(3V.%F{yellow}%3v%f.)'

      source ${pkgs.agkozak-zsh-prompt}/agkozak-zsh-prompt.plugin.zsh

      # Tools

      export FZF_DEFAULT_OPTS='--no-height'
      source $(fzf-share)/completion.zsh
      source $(fzf-share)/key-bindings.zsh

      eval "$(direnv hook zsh)"

      # Utils

      alias l="ls -l"
      alias ..="cd .."
      alias ...="cd ../.."
      alias ....="cd ../../.."
      alias .....="cd ../../../.."

      alias r="ranger"
      alias icat="kitty +kitten icat"

      function trace() {
          echo "! $@" >&2
          "$@"
      }

      function tmp() {
          cd "$(mktemp -d)"
      }

      function hr() {
          printf '\n%.0s' {1..10}
          for _ in $(seq 1 3); do
              printf '=%.0s' {1..$COLUMNS}
          done
          printf '\n%.0s' {1..10}
      }

      function qr2pass() {
               [[ -z "$1" ]] && { echo "otp name empty"; return 1; }
               maim --delay 0.5 |
                    zbarimg -q --raw /dev/stdin |
                    pass otp append "$1"
      }

      # Sticky

      local zle_sticked=""

      zle-line-init() {
          BUFFER="$zle_sticked$BUFFER"
          zle end-of-line
      }
      zle -N zle-line-init

      function zle-set-sticky {
          zle_sticked="$BUFFER"
          zle -M "Sticky: '$zle_sticked'."
      }
      zle -N zle-set-sticky
      bindkey '^S' zle-set-sticky

      function accept-line {
          if [[ -z "$BUFFER" ]] && [[ -n "$zle_sticked" ]]; then
              zle_sticked=""
              echo -n "\nRemoved sticky."
          fi
          zle .accept-line
      }
      zle -N accept-line

      # Ultimate Plumber

      zle-upify() {
          buf="$(echo "$BUFFER" | sed 's/[ |]*$//')"
          tmp="$(mktemp)"
          eval "$buf |& up --unsafe-full-throttle -o '$tmp' 2>/dev/null"
          cmd="$(tail -n +2 "$tmp")"
          rm -f "$tmp"
          BUFFER="$BUFFER | $cmd"
          zle end-of-line
      }
      zle -N zle-upify

      bindkey '^U' zle-upify

      # Overrides

      if [[ -f "$HOME/.zshrc.local" ]]; then
        source "$HOME/.zshrc.local"
      fi
    '';
  };
}
