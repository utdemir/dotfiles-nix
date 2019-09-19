let c = import "${(import ./sources.nix).nixpkgs}/nixos" {
  configuration = ./ci-configuration.nix;
};
in c.system

