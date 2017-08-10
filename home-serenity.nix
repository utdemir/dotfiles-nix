{ pkgs, ... }:

import ./home-common.nix { inherit pkgs; } // {
  home.packages = with pkgs; [
    minidlna deluge
  ];

  home.file.".minidlna.conf".text = ''
    friendly_name=SerenityEntertainmentConsole
    media_dir=/home/utdemir/Downloads
    db_dir=/home/utdemir/.cache/minidlna
    '';
}
