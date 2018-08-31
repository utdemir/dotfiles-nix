{ config, pkgs, ... }:

{
  imports =
    [ ./common-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  swapDevices = [
    { device = "/swapfile"; size = 4096; }
  ];

  networking.hostName = "galactica";

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint pkgs.gutenprintBin ];
    browsing = true;
  };

  networking.extraHosts = ''
    127.0.0.1 galactica
  '' + builtins.readFile ./movio-hosts.txt;
}
