{ pkgs, ... }:

{
  imports = [ ./common-home.nix ];
  home.packages = with pkgs; [
    (kubernetes.override { components = [ "cmd/kubectl" ]; })
    protobuf3_2
    travis
    slack
    (callPackage ./packages/kt.nix {})
  ];

}
