{ config, lib, pkgs, ... }:

with lib;
{
  options = {
    dotfiles.git.enabled = mkEnableOption "git";
  };

  config = mkIf config.dotfiles.git.enabled {
    home.packages = with pkgs; [
      git-lfs
      gitAndTools.hub
      gitAndTools.gh
    ];

    programs.git = {
      enable = true;
      userName = config.dotfiles.params.fullname;
      userEmail = config.dotfiles.params.email;
      aliases = {
        co = "checkout";
        st = "status -sb";
      };
      delta = {
        enable = true;
      };
      ignores = [
        ".envrc"
        ".direnv"
      ];
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        "pull" = {
          ff = "only";
        };
        "commit" = {
          verbose = "true";
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
      signing = {
        signByDefault = true;
        key = config.dotfiles.params.gpgKey;
        gpgPath = "gpg";
      };
    };
  };
}
