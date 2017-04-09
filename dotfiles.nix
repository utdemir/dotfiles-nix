{ pkgs }:

with import ./lib.nix { inherit pkgs; };

mkDotfiles [
  { path = ".gitconfig";          target = ./dotfiles/gitconfig;        }
  { path = ".gitignore_global";   target = ./dotfiles/gitignore;        }
  { path = ".zshrc";              target = ./dotfiles/zshrc;            }
  { path = ".zsh_custom";         target = ./dotfiles/zsh_custom;       }
  { path = ".stack/config.yaml" ; target = ./dotfiles/stackconfig.yaml; }
]
