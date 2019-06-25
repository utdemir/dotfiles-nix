{ config, pkgs, ... }:

let
  hercules-ci-agent = 
    let src = builtins.fetchTarball "https://github.com/hercules-ci/hercules-ci-agent/archive/stable.tar.gz";
        pkg = pkgs.callPackage (src + "/nix/packages.nix") {};
    in  pkgs.haskell.lib.justStaticExecutables pkg.hercules-ci-agent;
in
{
  systemd.services.hercules-ci-agent = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      StandardOutput = "null";
      StandardError = "syslog";
      ExecStart = ''
        ${hercules-ci-agent}/bin/hercules-ci-agent \
          --cluster-join-token-path /home/utdemir/.hercules-agent-token.key
      '';
      Environment = "NIX_PATH=nixpkgs=${pkgs.path}";
      User = "utdemir";
      Restart = "always";
      RestartSec = 30;
    };
  };
  
}
