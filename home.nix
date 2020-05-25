{ user, pkgs, ... }:
let
  sources = import ./nix/sources.nix;
  jaro = pkgs.callPackage ./packages/jaro.nix { xdgRedirect = true; };
in
{
  imports =
    builtins.filter builtins.pathExists [ ./home-private.nix ];

  home.packages = with pkgs; [
    # WM
    acpi
    arandr
    autorandr
    dunst
    feh
    i3
    i3lock
    i3blocks
    kitty
    libnotify
    lxappearance
    maim
    networkmanagerapplet
    parcellite
    pasystray
    pavucontrol
    redshift
    rofi
    unclutter
    xautolock
    xdotool
    xfontsel
    xnee
    xorg.xbacklight
    xorg.xev
    xorg.xkill
    keynav

    # Apps
    asciiquarium
    bazel
    chromium
    deluge
    gimp
    qutebrowser
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
    claws-mail
    inkscape
    macchanger
    gthumb

    # services
    awscli
    google-cloud-sdk
    gist
    gitAndTools.hub
    slack
    spotify
    whois
    zoom-us
    skype
    kubectl
    steam
    xorg.libxcb # required for steam
    ssb-patchwork
    riot-desktop

    # Fonts
    (pkgs.iosevka.override {
      privateBuildPlan = {
        family = "Iosevka utdemir";
        design = [ "slab" "term" ];
      };
      set = "utdemir";
    })

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
    broot
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
    ltrace
    moreutils
    mpv
    mtr
    multitail
    ncdu
    nix-zsh-completions
    nload
    nmap
    openssl
    pandoc
    paperkey
    pass-otp
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
    zsh
    zsh-syntax-highlighting
    rclone
    cookiecutter
    git-lfs
    bandwhich
    csvkit
    sshfs
    (hunspellWithDicts [ hunspellDicts.en-gb-ise ])
    (texlive.combine {
      inherit (texlive) scheme-small;
    })

    (
      callPackage ./nix/mk-scripts.nix
        { } {
        path = ./scripts;
        postBuild = ''
          wrapProgram "$out/bin/ergo" \
            --prefix PATH ":" "${yad}/bin"
        '';
      }
    )
    jaro
    (runCommand "jaro-xdg-open" {} ''
      mkdir -p $out/bin
      ln -s ${jaro}/bin/jaro $out/bin/xdg-open
    '')

    # editors
    vim
    (kakoune.override {
      configure = {
        plugins = [
          (callPackage ./packages/kakoune-surround.nix { })
          (callPackage ./packages/kakoune-rainbow.nix { })
        ];
      };
    })

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

    # java/scala
    openjdk8
    scala

    # python
    python37
    python37Packages.virtualenv

    # nix
    nix-prefetch
    patchelf
    nix-top
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

  programs.git = {
    enable = true;
    userName = user.name;
    userEmail = user.email;
    aliases = {
      co = "checkout";
      st = "status -sb";
    };
    extraConfig = {
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
    if user.gpgKey != ""
    then {
      signing = {
        signByDefault = true;
        key = user.gpgKey;
        gpgPath = "gpg";
      };
    }
    else { }
  );

  services.syncthing.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys =
      if user.gpgSshKeygrip != ""
      then [ user.gpgSshKeygrip ]
      else [ ];
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-gtk2}/bin/pinentry
    '';
  };

  xsession = {
    enable = true;
    windowManager.command = "i3";
  };

  manual.manpages.enable = true;

  home.file.".config/kak/kakrc".source = ./dotfiles/kakrc;
  home.file.".config/associations".source = ./dotfiles/associations;

  home.file.".config/i3/config".source = ./dotfiles/i3/config;
  home.file.".config/i3/autostart.sh".source = ./dotfiles/i3/autostart.sh;
  home.file.".config/i3/wallpaper.png".source = ./dotfiles/i3/wallpaper.png;
  home.file.".config/i3blocks/config".source = ./dotfiles/i3/i3blocks;

  home.file.".config/kitty/kitty.conf".source = ./dotfiles/kitty.conf;

  home.file.".config/rofi/config".source = ./dotfiles/rofi;

  home.file.".config/qutebrowser/config.py".source = ./dotfiles/qutebrowser.py;

  home.file.".config/ranger/rc.conf".source = ./dotfiles/ranger/rc.conf;
  home.file.".config/ranger/rifle.conf".source = ./dotfiles/ranger/rifle.conf;

  home.file.".zshrc".text = ''
    ${pkgs.any-nix-shell}/bin/any-nix-shell zsh | source /dev/stdin
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source ${./dotfiles/p10k.zsh}
    source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    source ${./dotfiles/zshrc}
  '';

  home.file.".profile" = {
    text = ''
      export NIX_PATH=nixpkgs=${pkgs.path}
      source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      source ${./dotfiles/profile}
    '';
    executable = true;
  };

  home.file.".config/fontconfig/fonts.conf".source = ./dotfiles/fonts.conf;

  home.file.".config/dunst/dunstrc".source = ./dotfiles/dunstrc;
  home.file.".config/autorandr/postswitch" = {
    source = ./dotfiles/autorandr-postswitch;
    executable = true;
  };

  systemd.user.services.battery-notification =
    let p = pkgs.runCommand "battery-notification"
      {
        buildInputs = [ pkgs.makeWrapper ];
      } ''
      mkdir -p $out/bin
      makeWrapper ${./scripts/battery-notification.sh} $out/bin/battery-notification.sh \
        --prefix PATH : "${pkgs.acpi}/bin:${pkgs.libnotify}/bin:${pkgs.bash}/bin:${pkgs.gnugrep}/bin"
    '';
    in
    {
      Unit = {
        Description = "Sends a notification on low battery.";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${p}/bin/battery-notification.sh";
      };
    };
  systemd.user.timers.battery-notification = {
    Timer = {
      OnCalendar = "minutely";
      Unit = "battery-notification.service";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  news.notify = "silent";

  # Force home-manager to use pinned nixpkgs
  _module.args.pkgs = pkgs.lib.mkForce pkgs;
}
