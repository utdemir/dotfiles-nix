{ user, pkgs, ...}:
{
  home.packages = with pkgs; [
    # WM
    i3 i3status i3lock dmenu rofi unclutter autorandr arandr maim
    networkmanagerapplet parcellite lxappearance xfontsel feh pasystray
    pavucontrol xdotool kitty xautolock xorg.xbacklight dunst acpi
    libnotify xorg.xkill xorg.xev redshift

    # Apps
    firefox-bin qutebrowser chromium google-chrome libreoffice gimp
    spotify smplayer mplayer zathura sxiv sweethome3d.application scrot
    xsel xclip deluge pcmanfm tmate qemu qemu_kvm pdfpc asciiquarium
    zoom-us slack
    (hunspellWithDicts [ hunspellDicts.en-gb-ise ])

    # Games
    steam xorg.libxcb # required for steam
     
    # Fonts
    ubuntu_font_family source-code-pro

    # CLI
    zsh zsh-syntax-highlighting nix-zsh-completions ranger bashmount
    imagemagick pdftk ncdu htop tree ascii powertop ghostscript nload
    asciinema zip unzip file dos2unix findutils direnv watch graphviz
    rsync openssl entr gnupg gitAndTools.hub gist pv jq yq  ripgrep
    tree autojump ncdu htop tokei units pandoc curl wget hexedit
    docker_compose mtr nmap cmatrix awscli pass-otp zbar tig sqlite fd
    dnsutils pwgen ltrace strace fzf termdown s3fs multitail gettext
    cpulimit paperkey moreutils fpp exa ffmpeg tcpdump iw weechat tmux
    up pythonPackages.subliminal
    (texlive.combine {
      inherit (texlive) scheme-small;
    })

    (import ./lib/mk-scripts.nix { inherit pkgs; } ./scripts)
    
    # photos
    dcraw libraw 

    # editors
    neovim kakoune
    (import ./lib/mk-emacs.nix { inherit pkgs; } ./dotfiles/emacs.el )

    # haskell
    stack cabal2nix ghc haskellPackages.ghcid
   
    # agda
    haskellPackages.Agda

    # purescript
    purescript
    nodePackages.bower

    # nodejs
    nodejs

    # scheme
    chicken

    # c
    gcc gnumake

    # java/scala
    openjdk8 sbt scala hadoop
    (spark.override { 
      mesosSupport = false; 
      RSupport = false; 
      pythonPackages = python3Packages;
    })
    
    # sh
    haskellPackages.ShellCheck

    # python
    python2 python37 python37Packages.virtualenv python3Packages.black

    # rust
    rustc cargo carnix

    # prolog
    swiProlog

    # factor
    factor-lang

    # coq
    coq

    # nix
    nix-prefetch-scripts patchelf haskellPackages.cachix nixops nix-top
  ];

  programs.git = {
    enable = true;
    userName = user.name;
    userEmail = user.email;
    aliases = {
      co = "checkout";
      st = "status -sb";
    };
    extraConfig = ''
        [url "git@github.com:"]
        insteadOf = https://github.com/  
    '';
  } // (if user.gpgKey != ""
        then { signing = { signByDefault = true;
                           key = user.gpgKey;
                           gpgPath = "gpg"; }; }
        else {});

  services.gpg-agent.enable = true;

  xsession = {
    enable = true;
    windowManager.command = "${pkgs.i3}/bin/i3";
  };

  services.keybase.enable = true;
  manual.manpages.enable = false;

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
  home.file.".profile" = {
    text = ''
      export NIX_PATH=nixpkgs=${pkgs.path}
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
