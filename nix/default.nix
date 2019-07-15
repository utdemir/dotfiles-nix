import "${(import ./sources.nix).nixpkgs}/nixos" {
  configuration = ./configuration.nix;
}
