let sources = import ./sources.nix;
in
{
    require = [ ../system.nix
                ../hardware.nix
                "${sources.home-manager}/nixos"
              ];

    nixpkgs.config.allowBroken = true;
    fileSystems."/" = { device = "/dev/null"; };
}
