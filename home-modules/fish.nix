{ config, lib, pkgs, ... }:

with lib;
{
  options = {
    dotfiles.fish.enabled = mkEnableOption "fish";
  };
  config = mkIf config.dotfiles.fish.enabled {
    home.packages = [ pkgs.zoxide pkgs.any-nix-shell ];

    programs.fish = {
      enable = true;
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../../";
        "...." = "cd ../../../";
        "....." = "cd ../../../../";
        "tmp" = ''cd (mktemp -d)'';
      };
      shellAbbrs = {
        r = "ranger";
      };
      shellInit = ''
        zoxide init fish | source
        any-nix-shell fish --info-right | source

        set -e fish_greeting
      '';
      plugins = [
        { name = "fish-pure"; src = pkgs.dotfiles-sources.fishPlugins-pure; }
        { name = "done"; src = pkgs.dotfiles-sources.fishPlugins-done; }
      ];
    };
  };
}
