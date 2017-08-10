{ pkgs, ... }:

import ./home-common.nix { inherit pkgs; } // {
  home.packages = with pkgs; [
    (kubernetes.override { components = [ "cmd/kubectl" ]; })
  ];
}
