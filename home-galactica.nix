{ pkgs, ... }:

{
  imports = [ ./home-common.nix ];
  home.packages = with pkgs; [
    (kubernetes.override { components = [ "cmd/kubectl" ]; })
  ];
}
