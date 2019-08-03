{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.cpu.intel.updateMicrocode = true;
  boot.kernelModules = [ "kvm-intel" ];

  swapDevices = [
    { device = "/swapfile"; size = 4096; }
  ];

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint pkgs.gutenprintBin ];
    browsing = true;
  };
}
