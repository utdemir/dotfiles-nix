import "${(import ./pkgs.nix).path}/nixos" {
  configuration = ./configuration.nix;
}
