{ config, pkgs, ... }:

{
  config = {
    xsession = {
      enable = true;
      windowManager.command = "i3";
    };

    home.packages = with pkgs; [
      i3
      i3lock
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
      picom
      redshift
      libnotify
      lxappearance
    ];
    home.file.".config/associations".source = ../dotfiles/associations;

    home.file.".config/i3/config".source = ../dotfiles/i3/config;
    home.file.".config/i3/autostart.sh".source = ../dotfiles/i3/autostart.sh;
    home.file.".config/i3/wallpaper.jpg".source = ../dotfiles/i3/wallpaper.jpg;
    home.file.".config/i3blocks/config".source = ../dotfiles/i3/i3blocks;
    home.file.".config/rofi/config".source = ../dotfiles/rofi;
    home.file.".config/fontconfig/fonts.conf".source = ../dotfiles/fonts.conf;
    home.file.".config/dunst/dunstrc".source = ../dotfiles/dunstrc;
    home.file.".config/autorandr/postswitch" = {
      source = ../dotfiles/autorandr-postswitch;
      executable = true;
    };

    home.file.".config/picom.conf".text = ''
      opacity-rule = [
        "90:class_g = 'kitty' && focused",
        "70:class_g = 'kitty' && !focused"
      ];
      shadow = true;

      backend = "glx";
      unredir-if-possible = true;
    '';

    systemd.user.services.battery-notification =
      let p = pkgs.runCommand "battery-notification"
        {
          buildInputs = [ pkgs.makeWrapper ];
        } ''
        mkdir -p $out/bin
        makeWrapper ${../scripts/battery-notification.sh} $out/bin/battery-notification.sh \
          --prefix PATH : "${pkgs.acpi}/bin:${pkgs.libnotify}/bin:${pkgs.bash}/bin:${pkgs.gnugrep}/bin"
      '';
      in
      {
        Unit = {
          Description = "Sends a notification on low battery.";
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${p}/bin/battery-notification.sh";
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
