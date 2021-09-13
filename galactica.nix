{ config, pkgs, ... }:

{
  imports = [
    ./generated/galactica-hardware-configuration.nix
    ./common.nix
    ./system-modules/syncthing.nix
  ];

  config = {

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

    environment.systemPackages = [
      pkgs.rclone
      pkgs.ncdu
      pkgs.ranger
    ];

    # backups
    services.jenkins = {
      enable = true;
      withCLI = true;
      packages = [ pkgs.rclone ];
      jobBuilder = {
        enable = true;
        accessUser = "admin";
        accessTokenFile = "/secrets/jenkins-job-builder-admin-token";
        nixJobs = [
          {
            job = {
              name = "Fetch Google Drive (me@utdemir.com)";
              triggers = [{ timed = "@daily"; }];
              builders = [
                {
                  shell = ''
                    timeout 6h rclone sync -v gdrive-utdemir:/ /mnt/external1/backups/gdrive-utdemir/contents/
                  '';
                }
              ];
            };
          }
        ];
      };
    };

    services.snapper = {
      configs = {
        gdrive-utdemir = {
          subvolume = "/mnt/external1/backups/gdrive-utdemir";
          extraConfig = ''
            TIMELINE_CREATE=yes
            TIMELINE_CLEANUP=yes
          '';
        };
      };
    };

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
  };
}
