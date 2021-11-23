{ config, pkgs, nodes, ... }:

with pkgs.lib;

{
  imports = [
    ./nix/dotfiles-params.nix
    ./system-modules/x11.nix
    ./system-modules/syncthing.nix
  ];

  options = { };

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

    dotfiles.syncthing = {
      enabled = true;
      extraDevices = {
        "utdemir-phone" = {
          id = "JPN3MV6-UPOQPTL-ME3DWNI-TIV5ZUV-U5JPJ5E-LFAZP2W-6UVFTWR-B4KAVAM";
          addresses = [ "tcp://100.117.118.54:22000" ];
        };
      };
    };

    networking.firewall = {
      enable = true;
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };

    networking.hosts =
      with pkgs.lib;
      pipe
        nodes
        [
          (mapAttrs (_k: v: v.config))
          (filterAttrs (_k: v: v.networking.hostName != config.networking.hostName))
          (mapAttrs' (_k: v: nameValuePair v.dotfiles.params.ip [ v.networking.hostName ]))
        ];

    time.timeZone = "Pacific/Auckland";
    environment.systemPackages = with pkgs;
      [ tmux neovim git curl wget ];

    environment.pathsToLink = [ "/share/fish" ];
    programs.command-not-found.enable = false;
    programs.dconf.enable = true;
    documentation.nixos.enable = false;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
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
        ++ pkgs.lib.optional config.networking.networkmanager.enable "networkmanager"
        ++ pkgs.lib.optional config.dotfiles.syncthing.enabled config.services.syncthing.group;
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
          ./home-modules/vscode.nix
          ./home-modules/workstation.nix
        ];

        dotfiles.params = config.dotfiles.params;

        news.display = "silent";
      };
    };
  };
}
