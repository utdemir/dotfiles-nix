let sources = import ./sources.nix;
in
{
    imports = [ ../system.nix
                ../hardware.nix
                "${sources.home-manager}/nixos"
                /etc/nixos/hardware-configuration.nix
              ];

    nixpkgs.config.allowBroken = true;
}
