{ config, pkgs, ... }:

{
  config = {
    home.packages = [ pkgs.zoxide ];

    programs.fish = {
      enable = true;
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../../";
        "...." = "cd ../../../";
        "....." = "cd ../../../../";
      };
      shellAbbrs = {
        r = "ranger";
      };
      shellInit = ''
         set -e fish_greeting

         source $NIX_USER_PROFILE_DIR/home-manager/home-path/share/fish/vendor_completions.d/pass.fish

         zoxide init fish | source
      '';

      plugins = [
        { name = "fish-pure"; src = pkgs.sources."fishPlugins.pure"; }
        { name = "done"; src = pkgs.sources."fishPlugins.done"; }
        { name = "fzf.fish"; src = pkgs.sources."fishPlugins.fzf.fish"; }
      ];
    };
  };
}
