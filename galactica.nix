{ config, pkgs, ... }:

{

  ############
  # HARDWARE #
  ############

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  hardware.cpu.intel.updateMicrocode = true;

  swapDevices = [
    { device = "/swapfile"; size = 4096; }
  ];

  services.fstrim.enable = true;
  services.logind.lidSwitch = "ignore";

  # filesystems
  environment.etc.crypttab = {
    enable = true;
    text = ''
      external1 UUID=2c945651-4cfa-4af1-bb3f-9e009c130b3d /secrets/external1-keyfile luks
    '';
  };

  fileSystems."/mnt/external1" = {
    device = "/dev/mapper/external1";
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [
      "/dev/mapper/external1"
    ];
  };

  ##########
  # SYSTEM #
  ##########

  dotfiles.syncthing.syncthingId = "SH4KL6W-REKPKEQ-J4NEO4S-ORZHPTY-JJ6OKGR-VQ53IOV-CGH7KV6-LSZ6RQN";
  dotfiles.x11.enabled = false;

  # network
  networking = {
    enableIPv6 = false;
    useNetworkd = false;
    useDHCP = true;
    wireless = {
      enable = true;
      interfaces = [ "wlp3s0" ];
    };
    nameservers = [ "1.1.1.1" "8.8.4.4" ];
  };
  services.resolved.enable = false;

  ########
  # HOME #
  ########

  home-manager.users."${config.dotfiles.params.username}" = {
    dotfiles = {
      wm.enabled = false;
      qutebrowser.enabled = false;
      kak.enabled = true;
      git.enabled = true;
      fish.enabled = true;
      workstation.enabled = false;
    };
  };
}
