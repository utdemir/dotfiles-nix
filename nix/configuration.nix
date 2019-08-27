{
    require = [ ../system.nix
                ../system-private.nix
                ../hardware.nix
                "${(import ./sources.nix).home-manager}/nixos"
                /etc/nixos/hardware-configuration.nix
              ];

    nixpkgs.config.allowBroken = true;
}
