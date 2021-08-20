{ config, pkgs, ... }:

{
  imports = [
  ];

  ############
  # HARDWARE #
  ############

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.cpu.amd.updateMicrocode = true;

  services.fstrim.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
  };

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint pkgs.gutenprintBin ];
    browsing = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  environment.systemPackages = [ pkgs.chrysalis ];
  services.udev.packages = [ pkgs.chrysalis ];

  ##########
  # SYSTEM #
  ##########

  networking.networkmanager.enable = true;
  system.fsPackages = [ pkgs.btrfs-progs ];

  virtualisation.docker = {
    enable = true;
    liveRestore = false;
    autoPrune.enable = true;
  };

  dotfiles.x11.enabled = true;

  ########
  # HOME #
  ########

  home-manager.users."${config.dotfiles.params.username}" = {
    dotfiles = {
      wm.enabled = true;
      qutebrowser.enabled = true;
      kak.enabled = true;
      git.enabled = true;
      fish.enabled = true;
      workstation.enabled = true;
    };
  };
}
