{ config, pkgs, ... }:

{
  config = {
    home.packages = with pkgs; [
      git-lfs
      gitAndTools.hub
    ];

    programs.git = {
      enable = true;
      userName = config.dotfiles.name;
      userEmail = config.dotfiles.email;
      aliases = {
        co = "checkout";
        st = "status -sb";
      };
      extraConfig = {
        "pull" = {
          ff = "only";
        };
        "filter \"lfs\"" = {
          process = "git-lfs filter-process";
          required = true;
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
        };
        url = {
          "ssh://git@github.com/" = { insteadOf = https://github.com/; };
        };
        hub = {
          protocol = "git";
        };
        advice = {
          detachedHead = false;
        };
      };
    } // (
      if config.dotfiles.gpgKey != ""
      then {
        signing = {
          signByDefault = true;
          key = config.dotfiles.gpgKey;
          gpgPath = "gpg";
        };
      }
      else { }
    );
  };
}
