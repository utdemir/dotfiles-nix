let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };

  machines = [
    { hostname = "marvin"; ip = "100.93.35.37"; }
    { hostname = "serenity"; ip = "100.120.224.51"; }
    { hostname = "galactica"; ip = "100.124.248.14"; }
    { hostname = "satellite"; ip = "100.74.139.49"; }

  ];
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
(pkgs.lib.pipe
  machines
  [
    (builtins.map (machine: pkgs.lib.nameValuePair machine.hostname {
      imports = [
        ./system-modules/x11.nix
        ./system-modules/syncthing.nix
        (import sources.home-manager { inherit pkgs; }).nixos
        (./. + "/${machine.hostname}.nix")
      ];
      deployment.targetHost = machine.ip;
      deployment.targetUser = "root";
      deployment.substituteOnDestination = true;

      dotfiles.params.ip = machine.ip;

      networking = {
        hostName = machine.hostname;
      };
    }))
    pkgs.lib.listToAttrs
  ]
)
