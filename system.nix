{ config, pkgs, ... }:
let
  sources = import ./nix/sources.nix;
  getName = drv:
    if builtins.hasAttr "pname" drv
    then drv.pname
    else if builtins.hasAttr "name" drv
    then (builtins.parseDrvName drv.name).name
    else throw "Cannot figure out name of: ${drv}";
in
{
  imports =
    (builtins.filter builtins.pathExists [ ./system-private.nix ]) ++ [
      ./user.nix
    ];

  networking.hostName = config.dotfiles.hostname;

  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg:
        builtins.elem
          (getName pkg)
          [
            "google-chrome"
            "spotify"
            "slack"
            "zoom-us"
            "intel-ocl"
            "skypeforlinux"
            "faac" # required for zoom
          ];
    };
    overlays = [
      (import sources.emacs-overlay)
      (import ./overlay.nix)
    ];
  };

  nix = {
    binaryCaches = [
      "https://utdemir.cachix.org"
      "https://hs-nix-template.cachix.org"
    ];
    binaryCachePublicKeys = [
      "utdemir.cachix.org-1:mDgucWXufo3UuSymLuQumqOq1bNeclnnIEkD4fFMhsw="
      "hs-nix-template.cachix.org-1:/YbjZCrYAw7d9ayLayk7ZhBdTEkR10ZFmFuOq6ZJo4c="
    ];
    trustedUsers = [ "root" config.dotfiles.username ];
    autoOptimiseStore = true;
    nixPath = [
      "nixpkgs=${pkgs.path}"
    ];
    daemonNiceLevel = 19;
    gc.automatic = true;
    optimise.automatic = true;
  };

  networking.dhcpcd.enable = false;
  networking.networkmanager.enable = true;

  time.timeZone = "Pacific/Auckland";

  environment.systemPackages = with pkgs; [ vim git ];

  # Linux 5.6 solve some issues with Intel GPUs
  boot.kernelPackages = pkgs.linuxPackages_5_6;

  boot.kernel.sysctl = {
    "vm.swappiness" = 100; # https://chrisdown.name/2018/01/02/in-defence-of-swap.html
    "fs.inotify.max_user_watches" = 2048000;
  };

  boot.cleanTmpDir = true;
  services.fwupd.enable = true;

  services.openssh.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  services.tor = {
    enable = true;
    client.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    liveRestore = false;
    autoPrune.enable = true;
  };

  services.logind.lidSwitch = "ignore";

  services.locate = {
    enable = true;
    interval = "hourly";
  };

  services.xserver = {
    enable = true;
    autorun = true;
    desktopManager.xterm.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = config.dotfiles.username;
      };
      lightdm = {
        enable = true;
        greeter.enable = false;
      };
    };
    xkbOptions = "caps:escape";
  };

  services.lorri.enable = true;

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = [ pkgs.intel-ocl ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  users.extraUsers.${config.dotfiles.username} = {
    home = "/home/${config.dotfiles.username}";
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = "${pkgs.zsh}/bin/zsh";
  };

  home-manager.users.${config.dotfiles.username} = args: import ./home.nix (args // { inherit pkgs;  });

  system.stateVersion = "19.09";
}
