let
sources = import ./sources.nix;
pkgs = import sources.nixpkgs {};

configuration = {
  imports = [
    ../system.nix
    ../hardware.nix
    (import sources.home-manager { inherit pkgs; }).nixos
    /etc/nixos/hardware-configuration.nix
    { nixpkgs.overlays = [ (se: su: { dotfiles-inputs = sources; }) ]; }
  ];
};
in

(import "${sources.nixpkgs}/nixos" { inherit configuration; }).system
