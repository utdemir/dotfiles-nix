#!/usr/bin/env sh

set -x

nix-env -f default.nix -i utdemir-env \
  --arg nixpkgs $HOME/Documents/workspace/github/nixos/nixpkgs \
  -j 4 --show-trace

dotfiles
