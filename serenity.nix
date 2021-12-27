{ config, pkgs, ... }:

{
  imports =
    let nixos-hardware = (import ./nix/sources.nix).nixos-hardware;
    in
    [
      ./generated/serenity-hardware-configuration.nix
      ./common.nix
      ./system-modules/syncthing.nix
      "${nixos-hardware}/lenovo/thinkpad"
      "${nixos-hardware}/common/cpu/intel"
      "${nixos-hardware}/common/cpu/intel/kaby-lake"
      "${nixos-hardware}/common/pc/laptop/ssd"
      "${nixos-hardware}/common/pc/laptop/acpi_call.nix"
    ];

  config = {
    ############
    # HARDWARE #
    ############

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    hardware.cpu.intel.updateMicrocode = true;

    services.fstrim.enable = true;
    services.xserver.videoDrivers = [ "intel" ];

    services.tlp.settings = {
      # powersave enables intel's p-state driver
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # https://linrunner.de/en/tlp/docs/tlp-faq.html#battery
      # use "tlp fullcharge" to override temporarily
      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 90;
      START_CHARGE_THRESH_BAT1 = 85;
      STOP_CHARGE_THRESH_BAT1 = 90;
    };
    services.throttled.enable = true;
    services.xserver.libinput = {
      enable = true;
    };

    swapDevices = [
      { device = "/swapfile"; size = 4096; }
    ];

    ##########
    # SYSTEM #
    ##########

    dotfiles.syncthing.syncthingId = "3X33LT5-75LHZCH-7UA4B7V-SPK65YR-RKXN2AL-TQHGENF-HHGS4B4-BSNLOAR";
    dotfiles.x11.enabled = true;

    networking.networkmanager.enable = true;
    virtualisation.docker = {
      enable = true;
      liveRestore = false;
      autoPrune.enable = true;
    };

    services.logind.lidSwitch = "ignore";
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

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
        vscode.enabled = true;
      };
    };
  };
}
