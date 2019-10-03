{
    require = [ ../system.nix
                ../hardware.nix
                "${import ./home-manager.nix}/nixos"
              ];

    nixpkgs.config.allowBroken = true;
    fileSystems."/" = { device = "/dev/null"; };
}
