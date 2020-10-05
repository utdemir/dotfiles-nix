{ config, pkgs, ... }:
{
  imports =
    (builtins.filter builtins.pathExists [ ./home-private.nix ]) ++ [
      ./nix/dotfiles.nix
      ./home/wm.nix
      ./home/git.nix
      ./home/qutebrowser.nix
      ./home/kitty.nix
      ./home/shell.nix
      ./home/vscode.nix
    ];

  dotfiles = import ./user.nix;

  home.packages = with pkgs; [
    # WM
    acpi
    maim

    # Apps
    asciiquarium
    chromium
    deluge
    gimp
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

    # services
    awscli
    google-cloud-sdk
    gist
    slack
    spotify
    whois
    zoom-us
    kubectl
    ssb-patchwork
    element-desktop

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
    docker_compose
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
    (let hp = haskellPackages.override {
       overrides = se: su: {
         PyF = haskell.lib.dontCheck su.PyF;
       };
     };
     in haskell.lib.justStaticExecutables hp.krank
    )
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

    (
      callPackage ./nix/mk-scripts.nix
        { }
        {
          path = ./scripts;
          postBuild = ''
            wrapProgram "$out/bin/ergo" \
              --prefix PATH ":" "${yad}/bin"
          '';
        }
    )
    jaro
    (runCommand "jaro-xdg-open" { } ''
      mkdir -p $out/bin
      ln -s ${jaro}/bin/jaro $out/bin/xdg-open
    '')

    # password-store
    (pass.withExtensions (ext: [
      ext.pass-otp
      (runCommand "pass-rotate" { } ''
        install -vDm ugo=x \
          ${./scripts/pass-rotate} \
          $out/lib/password-store/extensions/rotate.bash
      '')
    ]))

    # editors
    vim
    (kakoune.override {
      configure = {
        plugins = [ kakoune-surround kakoune-rainbow ];
      };
    })

    # bazel
    bazel

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
    (
      haskell.lib.justStaticExecutables
        (pkgs.haskellPackages.override {
          overrides = se: su: {
            servant-auth-server = haskell.lib.doJailbreak su.servant-auth-server;
          };
        }).cachix
    )
  ];

  services.syncthing.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys =
      if config.dotfiles.gpgSshKeygrip != ""
      then [ config.dotfiles.gpgSshKeygrip ]
      else [ ];
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-gtk2}/bin/pinentry
    '';
  };

  manual.manpages.enable = true;

  home.file.".config/kak/kakrc".source = ./dotfiles/kakrc;

  home.file.".config/ranger/rc.conf".source = ./dotfiles/ranger/rc.conf;
  home.file.".config/ranger/rifle.conf".source = ./dotfiles/ranger/rifle.conf;
  home.file.".config/ranger/commands.py".source = ./dotfiles/ranger/commands.py;

  home.file.".profile" = {
    text = ''
      export NIX_PATH=nixpkgs=${pkgs.path}
      source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      source ${./dotfiles/profile}
    '';
    executable = true;
  };

  news.display = "silent";

  # Force home-manager to use pinned nixpkgs
  _module.args.pkgs = pkgs.lib.mkForce pkgs;
}
