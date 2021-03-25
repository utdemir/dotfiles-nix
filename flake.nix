{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fishPlugins-done = {
      url = "github:franciscolourenco/done";
      flake = false;
    };

    fishPlugins-pure = {
      url = "github:pure-fish/pure";
      flake = false;
    };

    kakounePlugins-surround = {
      url = "github:h-youhei/kakoune-surround";
      flake = false;
    };

    kakounePlugins-rainbow = {
      url = "github:JJK96/kakoune-rainbow";
      flake = false;
    };

    kakounePlugins-kakboard= {
      url = "github:lePerdu/kakboard";
      flake = false;
    };

    kakounePlugins-lsp= {
      url = "github:kak-lsp/kak-lsp";
      flake = false;
    };
  };
  outputs = { self, ... }@inputs: {
    nixosConfigurations."${(import ./user.nix).hostname}" =
      inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system.nix
          ./hardware.nix
          inputs.home-manager.nixosModules.home-manager
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
          { nixpkgs.overlays = [ (se: su: { dotfiles-inputs = inputs; }) ]; }
        ];
      };
  };
}
