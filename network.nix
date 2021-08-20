let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };

  machines = {
    marvin = "100.93.35.37";
    serenity = "100.120.224.51";
    galactica = "100.124.248.14";
  };

in
{
  network = {
    pkgs = (pkgs.appendOverlays [
      (se: su: {
        dotfiles-sources = sources;
      })
      (import ./nix/overlay.nix)
    ]);
  };
} //
(pkgs.lib.mapAttrs
  (hostname: ip: {
    imports = [
      (import sources.home-manager { inherit pkgs; }).nixos
      (./. + "/generated/${hostname}-hardware-configuration.nix")
      ./common.nix
      (./. + "/${hostname}.nix")
    ];
    deployment.targetHost = ip;
    deployment.targetUser = "root";
    deployment.substituteOnDestination = true;

    networking = {
      hostName = hostname;
      hosts =
        with pkgs.lib;
          pipe
            machines
            [ (filterAttrs (k: _: k != hostname))
              (mapAttrs' (name: ip: nameValuePair ip [ name ]))
            ];
    };
  })
  machines
)
