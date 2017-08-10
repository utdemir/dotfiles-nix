# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/5eff54ab-ff36-4e43-a158-0cd54234b7c0";
    }
  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 2048;
    }
  ];

  networking.hostName = "serenity"; # Define your hostname.

  # networking.wireless.enable = true;
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    emacs
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  virtualisation.docker = {
    enable = true;
    liveRestore = false;
    # autoPrune.enable = true;
  };
  
  services.xserver = {
    enable = true;
    autorun = true;

    desktopManager.default = "none";
    windowManager = {
      default = "i3";
      i3 = {
        enable = true;
      };
    };
    displayManager.slim = {
      enable = true;
      defaultUser = "utdemir";
      autoLogin = true;
    };

    synaptics = {
      enable = true;
    };
  };

  users.extraUsers.utdemir = {
    home = "/home/utdemir";
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = "${pkgs.zsh}/bin/zsh";
  };

  system.stateVersion = "17.03";

}
