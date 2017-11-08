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

  networking.extraHosts = ''
    127.0.0.1 galactica
    10.6.210.56     ip-10-6-210-56.mm.movio.co
    10.6.210.148    ip-10-6-210-148.mm.movio.co
    10.6.210.127    ip-10-6-210-127.mm.movio.co
    10.6.210.239    ip-10-6-210-239.mm.movio.co
    10.6.210.226    ip-10-6-210-226.mm.movio.co
    10.6.200.122    ip-10-6-200-122.mm.movio.co
    10.6.200.190    ip-10-6-200-190.mm.movio.co
    10.6.200.140    ip-10-6-200-140.mm.movio.co
    10.6.200.133    ip-10-6-200-133.mm.movio.co
    10.6.200.107    ip-10-6-200-107.mm.movio.co
    10.6.210.243    ip-10-6-210-243.mm.movio.co
    10.6.210.156    ip-10-6-210-156.mm.movio.co
    10.6.210.206    ip-10-6-210-206.mm.movio.co
    10.6.210.224    ip-10-6-210-224.mm.movio.co
    10.6.210.85     ip-10-6-210-85.mm.movio.co
  '';
}
