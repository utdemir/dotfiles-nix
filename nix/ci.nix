let
sources = import ./sources.nix;
configuration = {
  imports = [ ../system.nix
              ../hardware.nix
              "${sources.home-manager}/nixos"
  ];
  nixpkgs.config.allowBroken = true;
  fileSystems."/".device = "/dev/null";
};
in
(import "${sources.nixpkgs}/nixos" { inherit configuration; }).system
