{ ... }:

let pkgs = import ./pkgs.nix;
in

{
  imports = [ ./common-home.nix ];

  home.packages = with pkgs; [
    deluge

    steam
    google-cloud-sdk
  ];
}
