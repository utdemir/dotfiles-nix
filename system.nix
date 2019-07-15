{ pkgs, ... }:

let user = import ./user.nix;
in 
{
  networking.hostName = user.hostname;

  nixpkgs.config.allowUnfree = true;
  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://utdemir.cachix.org"
    ];
    binaryCachePublicKeys = [
      "utdemir.cachix.org-1:eiAZrUaF4HVt/hLQeIdsbfRUtVUyKV8WYE8XKwJCD+8="
    ];
    trustedUsers = [ "root" user.username ];
  }; 
  
  networking.networkmanager.enable = true;

  time.timeZone = "Pacific/Auckland";

  environment.systemPackages = with pkgs; [ vim git ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 0; 
    "fs.inotify.max_user_watches" = 2048000;
  };

  boot.cleanTmpDir = true;

  services.openssh.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
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
    displayManager.slim = {
      enable = true;
      defaultUser = user.username;
      autoLogin = true;
    };
    xkbOptions = "caps:escape";
    synaptics.enable = true;
  };

  # FIXME: https://github.com/NixOS/nixpkgs/issues/63533
  # services.earlyoom = {
  #   enable = true;
  #   freeMemThreshold = 5;
  # };
  
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
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
