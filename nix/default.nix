let
  sources = import ./sources.nix;
  configuration = {
    imports = [
      ../system.nix
      ../hardware.nix
      "${sources.home-manager}/nixos"
      /etc/nixos/hardware-configuration.nix
    ];
    nixpkgs.config.allowBroken = true;
  };
in
(import "${sources.nixpkgs}/nixos" { inherit configuration; }).system
