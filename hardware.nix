{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.cpu.intel.updateMicrocode = true;

  programs.ssh.extraConfig = ''
    Host beta.nixbuild.net
      StrictHostKeyChecking no
      UserKnownHostsFile /dev/null
      PubkeyAcceptedKeyTypes ssh-ed25519
      IdentityFile /root/.ssh/nixbuild
  '';

  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "beta.nixbuild.net";
        system = "x86_64-linux";
        maxJobs = 100;
        supportedFeatures = [ "benchmark" "big-parallel" ];
      }
    ];
  };

  services.fstrim.enable = true;
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
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.libinput = {
    enable = true;
  };

  swapDevices = [
    { device = "/swapfile"; size = 4096; }
  ];

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint pkgs.gutenprintBin ];
    browsing = true;
  };

  # hardware-configuration
  # Use output of nixos-generate-config to create this:

  hardware.enableRedistributableFirmware = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/269e98d4-74ee-4dda-a829-dba9e61b2d1b";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."nixos-root".device = "/dev/disk/by-uuid/6d3b2738-fddb-49f5-bd38-311d8229666d";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/65BA-3108";
      fsType = "vfat";
    };
}
