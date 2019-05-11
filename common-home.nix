{...}:

let pkgs = import ./pkgs.nix;
    oldPkgs = import ./old_pkgs.nix;
in

{
  home.packages = with pkgs; [
    # WM
    i3 i3status i3lock dmenu rofi unclutter autorandr
    arandr maim networkmanagerapplet parcellite
    lxappearance xfontsel feh
    pasystray pavucontrol xdotool kitty xautolock 
    xorg.xbacklight dunst acpi libnotify xorg.xkill xorg.xev
    blueman redshift

    # Apps
    firefox-bin qutebrowser chromium google-chrome
    libreoffice dia gimp pencil vlc
    spotify smplayer mplayer audacity
    zathura sxiv qiv inotify-tools
    scrot xsel xclip deluge pcmanfm
    steam xorg.libxcb # required for steam
    qemu qemu_kvm ghostwriter pdfpc
    (hunspellWithDicts [ hunspellDicts.en-gb-ise ])

    # Fonts
    ubuntu_font_family source-code-pro

    # CLI
    zsh zsh-syntax-highlighting nix-zsh-completions sc-im
    ranger bashmount imagemagick pdftk ncdu htop tree units
    ascii powertop ghostscript translate-shell nload siege
    asciinema zip unzip file dos2unix findutils direnv
    watch graphviz rsync openssl entr gnupg  kbfs
    gitAndTools.hub gist pv jq ripgrep tree autojump ncdu htop tokei
    units haskellPackages.pandoc curl httpie
    wget hexedit docker_compose mtr nmap cmatrix awscli
    pass-otp zbar tig sqlite fd dnsutils pwgen ltrace strace
    fzf termdown miller s3fs ii multitail gettext cpulimit
    xpdf paperkey moreutils fpp exa john rtv gource ffmpeg
    tcpdump iw weechat tmux socat
    (texlive.combine {
      inherit (texlive) scheme-small;
    })

    (import ./lib/mk-scripts.nix { inherit pkgs; } ./scripts)
    exercism

    # photos
    darktable rawtherapee dcraw libraw 

    # editors
    neovim emacs kakoune ed

    # haskell
    stack cabal2nix haskellPackages.ghcid ghc

    # purescript
    purescript
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
    python37Packages.virtualenv python3Packages.black

    # rust
    rustc cargo carnix

    # prolog
    swiProlog

    # factor
    factor-lang

    # coq
    coq

    (let jupyter = import (builtins.fetchGit {
        url = https://github.com/tweag/jupyterWith;
        rev = "10d64ee254050de69d0dc51c9c39fdadf1398c38";
     }) {}; in
     jupyter.jupyterlabWith { kernels = [
      (jupyter.kernels.iHaskellWith { name = "haskell"; packages = p: with p; [ 
        lens containers bytestring text pipes conduit split
      ]; })
      (jupyter.kernels.iPythonWith { name = "python"; packages = p: with p; [ numpy tqdm ]; })
     ]; }
    )

    # nix
    nix-prefetch-scripts patchelf haskellPackages.cachix
    nix-top nixops
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
  home.file.".config/i3/wallpaper.png".source = ./dotfiles/i3/wallpaper.png;
  home.file.".config/i3status/config".source = ./dotfiles/i3/i3status;

  home.file.".config/kitty/kitty.conf".source = ./dotfiles/kitty.conf;

  home.file.".config/qutebrowser/config.py".source = ./dotfiles/qutebrowser/config.py;
  home.file.".config/qutebrowser/bookmarks/urls".source =
    ./dotfiles/qutebrowser/bookmarks;

  home.file.".config/mimeapps.list".source = ./dotfiles/mimeapps.list;
  
  home.file.".zshrc".source = ./dotfiles/zshrc;

  home.file.".config/fontconfig/fonts.conf".source = ./dotfiles/fonts.conf;

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
