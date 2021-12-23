{ config, pkgs, nodes, modulesPath, ... }:

{
  nixpkgs.system = "aarch64-linux";
  nixpkgs.pkgs = import (import ./nix/sources.nix {}).nixpkgs {
    system = "aarch64-linux";
  };

  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"
    ./nix/dotfiles-params.nix
  ];

  ec2.hvm = true;

  services.tailscale.enable = true;
  services.openssh = {
    enable = true;
    gatewayPorts = "clientspecified";
  };

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
    allowedTCPPorts = [ 22 80 443 ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  environment.systemPackages = with pkgs;
    [ tmux neovim git curl wget ];

  users.extraUsers.utdemir = {
    home = "/home/utdemir";
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ ];
    openssh.authorizedKeys.keys = [
      nodes.marvin.config.dotfiles.params.sshKey
    ];
  };

   security.acme = {
     email = "me@utdemir.com";
     acceptTerms = true;
   };

   services.nginx = {
     enable = true;
     virtualHosts."utdemir.com" = {
       forceSSL = true;
       enableACME = true;
       root = import (import ./nix/sources.nix)."utdemir.com";
     };
   };
}
