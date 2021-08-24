{ config, pkgs, ... }:

with pkgs.lib;

let
  getName = drv:
    if builtins.hasAttr "pname" drv
    then drv.pname
    else if builtins.hasAttr "name" drv
    then (builtins.parseDrvName drv.name).name
    else throw "Cannot figure out name of: ${drv}";
in
{
  imports = [
    ./system-modules/x11.nix
    ./nix/dotfiles-params.nix
  ];

  options = {};

  config = {

    dotfiles.params = {
      username = "utdemir";
      fullname = "Utku Demir";
      email = "me@utdemir.com";
      gpgKey = "76CCC3C7A7398C1321F5438BF3F8629C3E0BF60B";
      gpgSshKeygrip = "322960383C01BFF65D71C016549835ED43633F27";
      sshKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJ8GzKiErQUgUqq4I6qOLlSXsaPdgUGWll+xs8gClBiq69HjmDdvwP9LbqX2/iC/7DxiOHANoN7dgAVyD9JqlX5CL06Ou7glWU+s/+dAlji5pHSxtUZIm1UhB4LUUaXpswxYkyiNeVAgCkc7Xm8C7e0XGtsnMzanhi75wZ77ZY3CywJGfX8RbfitEOb9vyi+8L3OtN5bQZ/EORRgVMzmdT0meGB+RtjjJICKugQiQRgNzmgsM/Ir7ZniW2rHdHC3f4esZ56YLo9ZFNKkHjVRbRUn6EBdfBZ+TITClDnsvCMKSYfRMbr4bT754fTVwfmkFdrIDvzuty/RLjpWl5O58qFopZ63Akh7fFPRa6reDD83b4dSbbvWjCZbrt34AiR0+YAZ6O4+m9teSdLWe4cXPCjc0kxd+HotTIy191qXwYcHaBI9M4O3bZQX9el0LrCU4ysLxQmQepN3KnNrfh6KzW8sNygRAlsh9uplV32C7OyIAdN6kkiMFo+L6Zy4n76GeQBQ/NgIKrvX2V3uvbwfzAoTfQL3/Tx3LGbDOWkl88vzeQyHfd1bbf90VmgwanlLcjmVdof0C2DjrebE9PguXz2Wu8azdoP9aMlVNStx7ySP7tB6lxsJ9ZQVku8JQnXsN7tkCaMG8BGRXj9mUmMhmQWoGGjNzNSuoTe21M33FgGw== me@utdemir.com";
    };

    ############
    # HARDWARE #
    ############

    services.fstrim.enable = true;
    services.fwupd.enable = true;

    ##########
    # SYSTEM #
    ##########

    services.tailscale.enable = true;
    services.openssh = {
      enable = true;
      permitRootLogin = "yes";
    };

    networking.firewall = {
      enable = true;
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };

    nixpkgs = {
      config = {
        allowBroken = true;
        allowUnfreePredicate = pkg:
          builtins.elem
            (getName pkg)
            [
              "google-chrome"
              "spotify"
              "spotify-unwrapped"
              "slack"
              "zoom"
              "intel-ocl"
              "steam"
              "steam-original"
              "steam-runtime"
              "faac" # required for zoom
              "nvidia-x11"
              "nvidia-settings"
            ];
      };
    };

    time.timeZone = "Pacific/Auckland";
    environment.systemPackages = with pkgs;
      [
        screen
        neovim
        git
        curl
        wget
      ];

    environment.pathsToLink = [ "/share/fish" ];
    programs.command-not-found.enable = false;
    programs.dconf.enable = true;
    documentation.nixos.enable = false;
    hardware.pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    hardware.opengl.driSupport32Bit = true;
    services.earlyoom = {
      enable = true;
      freeMemThreshold = 5;
    };

    boot = {
      cleanTmpDir = true;
      kernel.sysctl = {
        "fs.inotify.max_user_watches" = 2048000;
      };
    };

    ########
    # USER #
    ########

    users.users.root.openssh.authorizedKeys.keys = [
      config.dotfiles.params.sshKey
    ];

    users.extraUsers."${config.dotfiles.params.username}" = {
      home = "/home/utdemir";
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel" ]
        ++ pkgs.lib.optional config.virtualisation.docker.enable "docker"
        ++ pkgs.lib.optional config.networking.networkmanager.enable "networkmanager";
      shell = "${pkgs.fish}/bin/fish";
      openssh.authorizedKeys.keys = [
        config.dotfiles.params.sshKey
      ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users."${config.dotfiles.params.username}" = {
        imports = [
          ./nix/dotfiles-params.nix
          ./home-modules/kak.nix
          ./home-modules/git.nix
          ./home-modules/fish.nix
          ./home-modules/wm.nix
          ./home-modules/qutebrowser.nix
          ./home-modules/workstation.nix
        ];

        dotfiles.params = config.dotfiles.params;

        news.display = "silent";
      };
    };
  };
}
