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
      device = "/dev/disk/by-uuid/5eff54ab-ff36-4e43-a158-0cd54234b7c0";
      allowDiscards = true;
    }
  ];

  swapDevices = [
    { device = "/swapfile"; size = 2048; }
  ];

  networking.hostName = "serenity";

  virtualisation.virtualbox.host.enable = true;
}
