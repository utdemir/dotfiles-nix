{...}:

let pkgs = import ./pkgs.nix;
    oldPkgs = import ./old_pkgs.nix;
in

{
  home.packages = with pkgs; [
    # WM
    i3 i3status i3lock dmenu rofi unclutter autorandr
    arandr compton maim networkmanagerapplet parcellite
    lxappearance xfontsel ubuntu_font_family source-code-pro
    pasystray pavucontrol xdotool kitty xautolock 
    (haskell.lib.doJailbreak haskellPackages.arbtt)
    xorg.xbacklight

    # Apps
    firefox qutebrowser chromium
    libreoffice dia gimp
    spotify smplayer mplayer audacity
    oldPkgs.zathura sxiv inotify-tools
    scrot xsel xclip steam deluge

    # CLI
    zsh zsh-syntax-highlighting nix-zsh-completions 

    ranger bashmount imagemagick pdftk ncdu htop tree units
    ascii powertop ghostscript translate-shell nload siege
    asciinema zip unzip file dos2unix findutils coreutils
    watch graphviz rsync parallel openssl entr gnupg keybase
    gitAndTools.hub gist pv jq ripgrep tree autojump ncdu htop cloc
    units haskellPackages.lentil haskellPackages.pandoc curl
    wget hexedit docker_compose mtr nmap cmatrix awscli
    pass-otp zbar tig sqlite fd dnsutils pwgen ltrace strace
    fzf termdown miller s3fs ii multitail gettext cpulimit

    (import ./lib/mk-scripts.nix { inherit pkgs; } ./scripts)
    exercism

    # editors
    neovim emacs kakoune ed

    # haskell
    stack cabal2nix haskellPackages.ghcid 

    # purescript
    (haskell.packages.ghc843.override {
      overrides = se: su: {
        spdx = haskell.lib.doJailbreak su.spdx;
        purescript = haskell.lib.overrideCabal su.purescript (s: {
          preConfigure = "hpack";
          executableHaskellDepends = s.executableHaskellDepends ++ [ se.hpack se.microlens-platform ];
          src = pkgs.fetchFromGitHub {
            owner = "purescript"; repo = "purescript";
            rev = "a8e0911222f46411776978a13866eb097175162c";
            sha256 = "0705b101kgcad4cq6xnmbjw6szb4j33ssjm6xag1n4w9477wdl08";
          };
        });
      };
    }).purescript
    nodePackages.bower

    # c
    gcc gnumake

    # scala
    openjdk8 sbt scala

    # sh
    haskellPackages.ShellCheck

    # python
    python2 python3
    python3Packages.virtualenv pipenv python3Packages.black

    # rust
    rustc cargo carnix

    # prolog
    swiProlog

    # coq
    coq

    # nix
    nix-prefetch-scripts
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
  home.file.".local/share/fonts".source = ./dotfiles/fonts; 

  home.file.".arbtt/categorize.cfg".source = ./dotfiles/arbtt-categorize.cfg;
}
