{ config, pkgs, nodes, modulesPath, ... }:

{
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
    allowedTCPPorts = [ 22 ];
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
}
