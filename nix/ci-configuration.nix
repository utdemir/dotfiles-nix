{
    require = [ ../system.nix
                ../hardware.nix
                ../../home-manager/nixos
              ];

    nixpkgs.config.allowBroken = true;
    fileSystems."/" = { device = "/dev/null"; };
}
