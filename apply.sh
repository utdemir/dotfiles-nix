#!/usr/bin/env sh

nix-env -f env.nix -i utdemir-env -j 4 --show-trace && dotfiles
