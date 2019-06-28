{
    require = [ ../system.nix
                ../hardware.nix
                "${import ./home-manager.nix}/nixos"
                /etc/nixos/hardware-configuration.nix
              ];
}
