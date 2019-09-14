{ user, pkgs, ...}:
let
sources = import ./nix/sources.nix;
in
{
  imports = [ ./home-private.nix ];

  home.packages = with pkgs; [
    # WM
    acpi arandr autorandr dunst feh i3 i3lock i3status kitty libnotify
    lxappearance maim networkmanagerapplet parcellite pasystray
    pavucontrol redshift rofi srandrd unclutter xautolock xdotool xfontsel
    xnee xorg.xbacklight xorg.xev xorg.xkill

    # Apps
    asciiquarium bazel chromium deluge firefox-bin gimp google-chrome
    libreoffice meld mplayer pcmanfm pdfpc qemu qemu_kvm qutebrowser scrot
    slack smplayer sweethome3d.application sxiv tmate xclip xsel zathura

    # services
    awscli circleci-cli google-cloud-sdk gist gitAndTools.hub slack spotify
    whois zoom-us
    steam xorg.libxcb # required for steam

    # Fonts
    ubuntu_font_family source-code-pro

    # CLI
    ascii asciinema autojump bashmount cmatrix cpufrequtils cpulimit
    curl direnv dnsutils docker_compose dos2unix entr exa fd ffmpeg file
    findutils fpp fzf gettext ghostscript gnupg graphviz hexedit htop
    htop imagemagick iw jq ltrace lynx moreutils mpv mtr multitail
    ncdu nix-zsh-completions nload nmap openssl pandoc paperkey
    pass-otp pdftk powerstat powertop pv pwgen pythonPackages.glances
    pythonPackages.subliminal ranger ripgrep rsync s3fs sqlite strace
    tcpdump termdown tig tmux tokei tree tree units unzip up watch
    weechat wget yq zbar zip zsh zsh-syntax-highlighting
    (hunspellWithDicts [ hunspellDicts.en-gb-ise ])
    (texlive.combine {
      inherit (texlive) scheme-small;
    })

    (import ./nix/mk-scripts.nix { inherit pkgs; } ./scripts)

    # editors
    emacs neovim
    (kakoune.override {
      configure = {
        plugins = [ (callPackage ./packages/kakoune-surround.nix {}) ];
      };
    })
    # haskell
    stack cabal2nix ghc
    (haskell.lib.justStaticExecutables haskellPackages.ghcid)

    # java/scala
    openjdk8 scala

    # python
    python37

    # nix
    nix-prefetch-scripts patchelf nixops nix-top
    (haskell.lib.justStaticExecutables (import sources.niv {}).niv)
    (haskell.lib.justStaticExecutables haskellPackages.cachix)
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
        url = {
          "ssh://git@github.com/" = { insteadOf = https://github.com/; };
        };
        hub = {
          protocol = "git";
        };
    };
  } // (if user.gpgKey != ""
        then { signing = { signByDefault = true;
                           key = user.gpgKey;
                           gpgPath = "gpg"; }; }
        else {});

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    sshKeys =
      if user.gpgSshKeygrip != ""
      then [ user.gpgSshKeygrip ]
      else [];
  };

  xsession = {
    enable = true;
    windowManager.command = "${pkgs.i3}/bin/i3";
  };

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

  home.file.".zshrc".text = ''
    ${pkgs.any-nix-shell}/bin/any-nix-shell zsh | source /dev/stdin
    source ${pkgs.autojump}/etc/profile.d/autojump.sh
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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
    let p = pkgs.runCommand "battery-notification" {
      buildInputs = [ pkgs.makeWrapper ];
    } ''
      mkdir -p $out/bin
      makeWrapper ${./scripts/battery-notification.sh} $out/bin/battery-notification.sh \
        --prefix PATH : "${pkgs.acpi}/bin:${pkgs.libnotify}/bin:${pkgs.bash}/bin"
    '';
    in {
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
}
