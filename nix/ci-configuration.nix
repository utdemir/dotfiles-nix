{
    require = [ ../system.nix
                ../hardware.nix
                "${import ./home-manager.nix}/nixos"
                ./noop-hardware-configuration.nix
              ];
              
    nixpkgs.config.allowBroken = true;
}
