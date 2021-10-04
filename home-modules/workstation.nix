{ config, lib, pkgs, ... }:

with lib;

let
  myPass =
    pkgs.pass.withExtensions (ext: [
      ext.pass-otp
      (pkgs.runCommand "pass-rotate" { } ''
        install -vDm ugo=x \
          ${../scripts/pass-rotate} \
          $out/lib/password-store/extensions/rotate.bash
      '')
    ]);
in
{
  options = {
    dotfiles.workstation.enabled = mkEnableOption "workstation";
  };
  config = mkIf config.dotfiles.workstation.enabled {
    home.packages = with pkgs; [
      (callPackage ../scripts { pass = myPass; })

      # WM
      acpi
      maim

      # Apps
      asciiquarium
      chromium
      deluge
      gimp
      mypaint
      libreoffice
      meld
      mplayer
      pcmanfm
      qemu
      qemu_kvm
      scrot
      sxiv
      tmate
      xclip
      xsel
      zathura
      inkscape
      macchanger
      gthumb
      pocket-add

      # services
      google-cloud-sdk
      gist
      slack
      spotify
      whois
      zoom-us
      kubectl
      steam
      xorg.libxcb # required for steam
      element-desktop
      signal-desktop
      ssb-patchwork
      awscli2

      # Fonts
      hack-font

      # CLI
      ascii
      asciinema
      bashmount
      cmatrix
      cpufrequtils
      cpulimit
      curl
      direnv
      dnsutils
      dos2unix
      entr
      (
        pkgs.haskell.lib.justStaticExecutables
          pkgs.haskellPackages.steeloverseer
      )
      fd
      ffmpeg
      file
      findutils
      fzf
      gettext
      ghostscript
      gnupg
      graphviz
      hexedit
      hexyl
      htop
      htop
      imagemagick
      iw
      jq
      yq
      (haskell.lib.justStaticExecutables pkgs.haskellPackages.lentil)
      ltrace
      moreutils
      mpv
      mtr
      multitail
      ncdu
      nload
      nmap
      openssl
      pandoc
      paperkey
      pdftk
      powerstat
      powertop
      pv
      pwgen
      ranger
      ripgrep
      rsync
      sqlite
      strace
      tcpdump
      tig
      gitui
      tmux
      tokei
      tree
      units
      unzip
      up
      watch
      weechat
      wget
      yq
      zbar
      zip
      rclone
      cookiecutter
      bandwhich
      sshfs
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science

      (texlive.combine {
        inherit (texlive) scheme-small;
      })

      jaro
      (runCommand "jaro-xdg-open" { } ''
        mkdir -p $out/bin
        ln -s ${jaro}/bin/jaro $out/bin/xdg-open
      '')

      # password-store
      myPass


      # editors
      vim

      # closure
      leiningen

      # haskell
      stack
      haskellPackages.cabal-install
      (haskellPackages.ghcWithPackages (p: with p; [
        aeson
        cassava
        lens
      ]))
      (haskell.lib.justStaticExecutables haskellPackages.ghcid)
      (haskell.lib.justStaticExecutables haskellPackages.ormolu)

      # python
      python37
      python37Packages.virtualenv

      # nix
      nix-prefetch
      patchelf
      nix-top
      nix-tree
      niv
      nixpkgs-fmt
      cachix
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      sshKeys = [ config.dotfiles.params.gpgSshKeygrip ];
      extraConfig = ''
        pinentry-program ${pkgs.pinentry-gtk2}/bin/pinentry
      '';
    };

    manual.manpages.enable = true;

    home.file.".config/ranger/rc.conf".source = ../dotfiles/ranger/rc.conf;
    home.file.".config/ranger/rifle.conf".source = ../dotfiles/ranger/rifle.conf;
    home.file.".config/ranger/commands.py".source = ../dotfiles/ranger/commands.py;

    home.file.".profile" = {
      text = ''
        export NIX_PATH=nixpkgs=${pkgs.path}
        export TMPDIR=/tmp
        export TMP=$TMPDIR
        source ${../dotfiles/profile}
      '';
      executable = true;
    };
  };
}
