{ config, pkgs, ... }:

let
sources = import ./nix/sources.nix;
in

{
  imports = [
    "${sources.nixos-hardware}/lenovo/thinkpad"
    "${sources.nixos-hardware}/common/cpu/intel"
    "${sources.nixos-hardware}/common/pc/laptop/ssd"
    "${sources.nixos-hardware}/common/pc/laptop/acpi_call.nix"
    "${sources.nixos-hardware}/common/pc/laptop/cpu-throttling-bug.nix"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.cpu.intel.updateMicrocode = true;
  boot.kernelModules = [ "kvm-intel" ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  services.xserver.videoDrivers = [ "intel" ];

  swapDevices = [
    { device = "/swapfile"; size = 4096; }
  ];

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint pkgs.gutenprintBin ];
    browsing = true;
  };
}
