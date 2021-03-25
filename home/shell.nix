{ config, pkgs, ... }:

{
  config = {
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
        { name = "fish-pure"; src = pkgs.dotfiles-inputs.fishPlugins-pure; }
        { name = "done"; src = pkgs.dotfiles-inputs.fishPlugins-done; }
      ];
    };
  };
}
