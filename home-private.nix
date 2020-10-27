# This file is gitignore'd, put configuration you don't want to have in git.
# They will still end up world-readable in /nix/store, so don't put secrets.

{ pkgs, ... }:

{
  systemd.user.services.mount-data = {
    Unit = {
        Description = "Mounts utdemir.com:data";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "forking";
      ExecStart = "${pkgs.bash}/bin/sh -c '${pkgs.sshfs}/bin/sshfs -o no_check_root,follow_symlinks,dir_cache=yes,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 home.utdemir.com:data $HOME/data'";
      ExecStop = "${pkgs.bash}/bin/sh -c '${pkgs.fuse}/bin/fusermount -u $HOME/data'";
    };
    Install = { WantedBy = [ "default.target" ]; };
  };

  home.packages = [ pkgs.protonmail-bridge ];
}
