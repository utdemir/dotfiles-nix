{ pkgs }:
let mkDotfiles = files:
  pkgs.writeScriptBin "dotfiles" ''
    function trace() {
      echo "! $@"; $@
    }

    set -o errexit
    set -o nounset

    ${ pkgs.lib.concatMapStringsSep "\n" ({path, target}: ''
         mkdir -p "$HOME/$(dirname ${path})";
	 trace ln -sf "${target}" "$HOME/${path}"
         '')
       files }
  '';

in
mkDotfiles [
  { path = ".gitconfig";          target = ./dotfiles/gitconfig;        }
  { path = ".gitignore_global";   target = ./dotfiles/gitignore;        }
  { path = ".zshrc";              target = ./dotfiles/zshrc;            }
  { path = ".zsh_custom";         target = ./dotfiles/zsh_custom;       }
  { path = ".stack/config.yaml" ; target = ./dotfiles/stackconfig.yaml; }
]
