{ ... }:

let pkgs = import ./nixpkgs {};
in

{
  imports = [ ./common-home.nix ];
  home.packages = with pkgs; [
    (kubernetes.override { components = [ "cmd/kubectl" ]; })
    protobuf3_1
    travis
    slack
    (callPackage ./packages/kt.nix {})
  ];

}
