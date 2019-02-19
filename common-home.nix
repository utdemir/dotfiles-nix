{...}:

let pkgs = import ./pkgs.nix;
    oldPkgs = import ./old_pkgs.nix;
in

{
  home.packages = with pkgs; [
    # WM
    i3 i3status i3lock dmenu rofi unclutter autorandr
    arandr compton maim networkmanagerapplet parcellite
    lxappearance xfontsel 
    pasystray pavucontrol xdotool kitty xautolock 
    (oldPkgs.haskell.lib.doJailbreak oldPkgs.haskellPackages.arbtt)
    xorg.xbacklight dunst acpi libnotify xorg.xkill

    # Apps
    firefox qutebrowser chromium
    libreoffice dia gimp pencil vlc
    spotify smplayer mplayer audacity
    zathura sxiv qiv inotify-tools
    scrot xsel xclip deluge pcmanfm
    xorg.libxcb # required for steam
    qemu qemu_kvm

    # Fonts
    ubuntu_font_family source-code-pro

    # CLI
    zsh zsh-syntax-highlighting nix-zsh-completions sc-im
    ranger bashmount imagemagick pdftk ncdu htop tree units
    ascii powertop ghostscript translate-shell nload siege
    asciinema zip unzip file dos2unix findutils
    watch graphviz rsync openssl entr gnupg keybase
    gitAndTools.hub gist pv jq ripgrep tree autojump ncdu htop tokei
    units haskellPackages.pandoc curl httpie
    wget hexedit docker_compose mtr nmap cmatrix awscli
    pass-otp zbar tig sqlite fd dnsutils pwgen ltrace strace
    fzf termdown miller s3fs ii multitail gettext cpulimit
    xpdf paperkey moreutils fpp exa john rtv

    (import ./lib/mk-scripts.nix { inherit pkgs; } ./scripts)
    exercism

    oldPkgs.nixops

    # photos
    darktable rawtherapee dcraw 

    # editors
    neovim emacs kakoune ed

    # haskell
    stack cabal2nix haskellPackages.ghcid ghc

    # purescript
#    (haskell.packages.ghc844.override {
#      overrides = se: su: {
#        spdx = haskell.lib.doJailbreak su.spdx;
#        purescript = haskell.lib.overrideCabal su.purescript (s: {
#          preConfigure = "hpack";
#          executableHaskellDepends = s.executableHaskellDepends ++ [ se.hpack se.microlens-platform ];
#          src = pkgs.fetchFromGitHub {
#            owner = "purescript"; repo = "purescript";
#            rev = "a8e0911222f46411776978a13866eb097175162c";
#            sha256 = "0705b101kgcad4cq6xnmbjw6szb4j33ssjm6xag1n4w9477wdl08";
#          };
#        });
#      };
#    }).purescript
    nodePackages.bower

    # scheme
    chicken

    # pony
    ponyc

    # c
    gcc gnumake

    # scala
    openjdk8 sbt scala

    # sh
    haskellPackages.ShellCheck

    # python
    python2 python37
    python37Packages.virtualenv pipenv python3Packages.black

    # rust
    rustc cargo carnix rustfmt

    # prolog
    swiProlog

    # factor
    factor-lang

    # coq
    coq

    # nix
    nix-prefetch-scripts patchelf oldPkgs.cachix
  ];

  programs.git = {
    enable = true;
    userName = "Utku Demir";
    userEmail = "me@utdemir.com";
    signing = {
      signByDefault = true;
      key = "76CCC3C7A7398C1321F5438BF3F8629C3E0BF60B";
      gpgPath = "gpg";
    };
    aliases = {
      co = "checkout";
      st = "status -sb";
    };
#    extraConfig = ''
#        [url "git@github.com:"]
#        insteadOf = https://github.com/  
#    '';
  };

  services.gpg-agent.enable = true;

  xsession = {
    enable = true;
    windowManager.command = "${pkgs.i3}/bin/i3";
    profileExtra = ''
    export SBT_OPTS="-Xms512M -Xmx1024M -Xss2M -XX:MaxMetaspaceSize=1024M"
    '';
  };

  services.keybase.enable = true;
  manual.manpages.enable = false;

  home.file.".stack/config.yaml".source = ./dotfiles/stack;

  home.file.".config/kak/kakrc".source = ./dotfiles/kakrc;
  
  home.file.".config/i3/config".source = ./dotfiles/i3/config;
  home.file.".config/i3/autostart.sh".source = ./dotfiles/i3/autostart.sh;
  home.file.".config/i3status/config".source = ./dotfiles/i3/i3status;

  home.file.".config/kitty/kitty.conf".source = ./dotfiles/kitty.conf;

  home.file.".config/qutebrowser/config.py".source = ./dotfiles/qutebrowser/config.py;
  home.file.".config/qutebrowser/bookmarks/urls".source =
    ./dotfiles/qutebrowser/bookmarks;

  home.file.".config/mimeapps.list".source = ./dotfiles/mimeapps.list;
  
  home.file.".zshrc".source = ./dotfiles/zshrc;

  home.file.".config/fontconfig/fonts.conf".source = ./dotfiles/fonts.conf;

  home.file.".arbtt/categorize.cfg".source = ./dotfiles/arbtt-categorize.cfg;

  home.file.".config/dunst/dunstrc".source = ./dotfiles/dunstrc;

  systemd.user.services.battery-notification = 
    let p = pkgs.runCommand "battery-notification" {
      buildInputs = [ pkgs.makeWrapper ];
    } ''
      mkdir -p $out/bin
      makeWrapper ${./scripts/battery-notification.sh} $out/bin/battery-notification.sh \
        --prefix PATH : "${pkgs.acpi}/bin:${pkgs.libnotify}/bin:${pkgs.bash}/bin"
    '';
    in {
      Unit = {
        Description = "Sends a notification on low batery.";
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
}
