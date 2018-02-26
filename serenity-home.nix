{ pkgs, ... }:

{
  imports = [ ./common-home.nix ];

  home.packages = with pkgs; [
    minidlna deluge dropbox skype

    steam
    google-cloud-sdk
  ];

  home.file.".minidlna.conf".text = ''
    friendly_name=SerenityEntertainmentConsole
    media_dir=/home/utdemir/Downloads
    db_dir=/home/utdemir/.cache/minidlna
    '';
}
