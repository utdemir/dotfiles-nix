{ config, lib, pkgs, ... }:

with lib;
{
  options.dotfiles.params = {
    username = mkOption { type = types.str; };
    fullname = mkOption { type = types.str; };
    email = mkOption { type = types.str; };
    gpgKey = mkOption { type = types.str; };
    gpgSshKeygrip = mkOption { type = types.str; };
    sshKey = mkOption { type = types.str; };
    machines = mkOption { type = types.attrsOf types.str; };
    ip = mkOption { type = types.str; };
  };
  config = { };
}
