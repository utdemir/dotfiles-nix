{ ci ? false }:

import "${(import ./sources.nix).nixpkgs}/nixos" {
  configuration = if ci
                    then ./ci-configuration.nix
                    else ./configuration.nix;
}
