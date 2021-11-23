{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    dotfiles.x11.enabled = mkEnableOption "x11";
  };

  config = mkIf config.dotfiles.x11.enabled {
    environment.systemPackages = [ pkgs.arandr ];
    services.xserver = {
      enable = true;
      autorun = true;
      desktopManager.xterm.enable = true;
      displayManager = {
        autoLogin = {
          enable = true;
          user = config.dotfiles.params.username;
        };
        lightdm = {
          enable = true;
          greeter.enable = false;
        };
      };
      xkbOptions = "caps:escape";
    };
  };
}
