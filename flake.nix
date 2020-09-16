{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, ... }@inputs: {
    nixosConfigurations."${(import ./user.nix).hostname}" = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./system.nix
        ./hardware.nix
        inputs.home-manager.nixosModules.home-manager
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
      ];
    };
  };
}
