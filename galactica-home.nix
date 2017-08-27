{ pkgs, ... }:

{
  imports = [ ./common-home.nix ];
  home.packages = with pkgs; [
    (kubernetes.override { components = [ "cmd/kubectl" ]; })
    protobuf3_2
    slack
    autorandr
    (callPackage ./packages/kt.nix {})
  ];

  home.file.".autorandr/postswitch" = {
    mode = "755";
    text = ''
      #!/usr/bin/env sh
      feh --bg-center ~/.config/i3/wallpaper.png
    '';
  };
}
