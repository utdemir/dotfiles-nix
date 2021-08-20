{ config, lib, pkgs, ... }:

with lib;
let
  # Wallpaper:
  #   By JJ Harrison (https://www.jjharrison.com.au/)
  #   - Own work, CC BY-SA 4.0, https://commons.wikimedia.org/w/index.php?curid=90332278
  wallpaper = ../static/wallpaper.jpg;

  loadEditorLayout =
    pkgs.runCommand "i3-load-editor-layout" { buildInputs = [ pkgs.makeWrapper ]; } ''
      set -x
      mkdir -p "$out/bin"
      makeWrapper \
        "${../dotfiles/i3/load-editor-layout.sh}" \
        "$out/bin/i3-load-editor-layout" \
        --set EDITOR_LAYOUT_JSON "${../dotfiles/i3/editor-layout.json}"
    '';
in
{
  options = {
    dotfiles.wm.enabled = mkEnableOption "wm";
  };
  config = mkIf config.dotfiles.wm.enabled {
    xsession = {
      enable = true;
      windowManager.command = "i3";
    };

    home.packages = with pkgs; [
      i3
      betterlockscreen
      i3blocks
      dunst
      feh
      rofi
      unclutter
      xautolock
      xfontsel
      xorg.xbacklight
      xorg.xev
      xorg.xkill
      keynav
      networkmanagerapplet
      parcellite
      pasystray
      pavucontrol
      redshift
      libnotify
      lxappearance
      playerctl
      loadEditorLayout
      kitty
    ];
    home.file.".config/associations".source = ../dotfiles/associations;
    home.file.".config/i3/config".source = ../dotfiles/i3/config;

    home.file.".config/i3/autostart.sh" = {
      executable = true;
      text = ''
        feh --bg-fill "${wallpaper}" --no-xinerama &

        sleep 1
        ergo &
        keynav &
        unclutter &
        nm-applet &
        parcellite &
        pasystray &
        xautolock \
          -detectsleep \
          -time 30 -locker "betterlockscreen --lock" \
          -notify 10 -notifier 'notify-send -t 10000 "Screen lock oncoming."' &
        redshift -l -36.84853:174.76349 & # auckland, nz
      '';
    };

    home.file.".config/kitty/kitty.conf".text = ''
      scrollback_lines 100000

      font_family Hack
      font_size 14

      clear_all_shortcuts yes

      map ctrl+shift+c copy_to_clipboard
      map ctrl+shift+v paste_from_clipboard
      map ctrl+shift+l show_scrollback

      map ctrl+shift+u kitten hints
      map ctrl+shift+p kitten hints --type path --program -
      map ctrl+shift+h kitten hints --type hash --program -

      map ctrl+shift+. kitten unicode_input

      map ctrl+shift+equal change_font_size all +2.0
      map ctrl+shift+minus change_font_size all -2.0
      map ctrl+shift+0 change_font_size all 0
    '';

    home.file.".config/i3blocks/config".source = ../dotfiles/i3/i3blocks;
    home.file.".config/rofi/config".source = ../dotfiles/rofi;
    home.file.".config/fontconfig/fonts.conf".source = ../dotfiles/fonts.conf;
    home.file.".config/dunst/dunstrc".source = ../dotfiles/dunstrc;
  };
}
