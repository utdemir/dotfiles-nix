{ ci ? false }:

let 
versions = import ../versions.nix;
in 
import "${versions.nixpkgs}/nixos" {
  configuration = if ci
                    then ./ci-configuration.nix
                    else ./configuration.nix;
}
