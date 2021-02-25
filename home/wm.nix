{ config, pkgs, ... }:
let
  # Wallpaper:
  #   By JJ Harrison (https://www.jjharrison.com.au/)
  #   - Own work, CC BY-SA 4.0, https://commons.wikimedia.org/w/index.php?curid=90332278
  wallpaper = ../static/wallpaper.jpg;
in
{
  config = {
    xsession = {
      enable = true;
      windowManager.command = "i3";
    };

    home.packages = with pkgs; [
      i3
      i3lock-fancy
      i3blocks
      arandr
      autorandr
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
    ];
    home.file.".config/associations".source = ../dotfiles/associations;
    home.file.".config/i3/config".source = ../dotfiles/i3/config;

    home.file.".config/i3/autostart.sh" = {
      executable = true;
      text = ''
        feh --bg-fill "${wallpaper}" --no-xinerama &

        autorandr --change --default small &

        sleep 1
        ergo &
        keynav &
        unclutter &
        nm-applet &
        parcellite &
        pasystray &
        xautolock -locker "i3lock-fancy"  -time 5 -detectsleep &
        redshift -l -36.84853:174.76349 & # auckland, nz
      '';
    };

    home.file.".config/i3blocks/config".source = ../dotfiles/i3/i3blocks;
    home.file.".config/rofi/config".source = ../dotfiles/rofi;
    home.file.".config/fontconfig/fonts.conf".source = ../dotfiles/fonts.conf;
    home.file.".config/dunst/dunstrc".source = ../dotfiles/dunstrc;

    home.file.".config/autorandr/postswitch" = {
      text = ''
        #!/usr/bin/env sh
        feh --bg-fill ${wallpaper} --no-xinerama
      '';
      executable = true;
    };

    systemd.user.services.battery-notification = {
      Unit = {
        Description = "Sends a notification on low battery.";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.callPackage ../scripts {}}/bin/battery-notification.sh";
      };
    };

    systemd.user.timers.battery-notification = {
      Timer = {
        OnCalendar = "minutely";
        Unit = "battery-notification.service";
        Persistent = true;
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

  };
}
