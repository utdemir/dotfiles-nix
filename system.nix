{ pkgs, ... }:

let
  user = import ./user.nix;
  getName = drv:
    if builtins.hasAttr "pname" drv
    then drv.pname
    else if builtins.hasAttr "name" drv
    then (builtins.parseDrvName drv.name).name
    else throw "Cannot figure out name of: ${drv}";
in
{
  imports =
    builtins.filter builtins.pathExists [ ./system-private.nix ];

  networking.hostName = user.hostname;

  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem
        (getName pkg)
        [ "firefox-bin"
          "firefox-release-bin-unwrapped"
          "google-chrome"
          "spotify"
          "slack"
          "zoom-us"
          "intel-ocl"
        ];
  };

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://utdemir.cachix.org"
    ];
    binaryCachePublicKeys = [
      "utdemir.cachix.org-1:mDgucWXufo3UuSymLuQumqOq1bNeclnnIEkD4fFMhsw="
    ];
    trustedUsers = [ "root" user.username ];
    autoOptimiseStore = true;
    maxJobs = 2;
    nixPath = [
      "nixpkgs=${pkgs.path}"
    ];
    daemonNiceLevel = 19;
  };

  networking.dhcpcd.enable = false;
  networking.networkmanager.enable = true;

  time.timeZone = "Pacific/Auckland";

  environment.systemPackages = with pkgs; [ vim git ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 0;
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

  services.ipfs = {
    enable = true;
    autoMount = true;
    localDiscovery = false;
    gatewayAddress = "/ip4/127.0.0.1/tcp/8090";
  };

  virtualisation.docker = {
    enable = true;
    liveRestore = false;
    autoPrune.enable = true;
  };

  services.logind.lidSwitch = "ignore";

  services.xserver = {
    enable = true;
    autorun = true;
    desktopManager.xterm.enable = true;
    displayManager.lightdm = {
      enable = true;
      greeter.enable = false;
      autoLogin = {
        enable = true;
        user = "utdemir";
      };
    };
    xkbOptions = "caps:escape";
  };

  services.lorri.enable = true;

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
  };

  hardware.pulseaudio.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = [ pkgs.intel-ocl ];

  users.extraUsers.${user.username} = {
    home = "/home/${user.username}";
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = "${pkgs.zsh}/bin/zsh";
  };
  home-manager.users.${user.username} = args: import ./home.nix (args // { inherit pkgs user; });

  system.stateVersion = "19.09";
}
