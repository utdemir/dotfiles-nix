{ config, pkgs, ... }:

{
  imports =
    [ ./common-configuration.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  swapDevices = [
    { device = "/swapfile"; size = 4096; }
  ];

  networking.hostName = "galactica";

}
