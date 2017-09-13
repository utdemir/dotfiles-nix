{ config, pkgs, ... }:

{
  imports =
    [ ./common-configuration.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/fd770830-0e38-4125-88e1-7efec57e9e5c";
      allowDiscards = true;
    }
  ];

  swapDevices = [
    { device = "/swapfile"; size = 4096; }
  ];

  networking.hostName = "galactica";
}
