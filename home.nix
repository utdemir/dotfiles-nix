{ user, pkgs, ...}:
let
sources = import ./nix/sources.nix;
in
{
  imports =
    builtins.filter builtins.pathExists [ ./home-private.nix ];

  home.packages = with pkgs; [
    # WM
    acpi arandr autorandr dunst feh i3 i3lock i3blocks kitty libnotify
    lxappearance maim networkmanagerapplet parcellite pasystray
    pavucontrol redshift rofi srandrd unclutter xautolock xdotool xfontsel
    xnee xorg.xbacklight xorg.xev xorg.xkill

    # Apps
    asciiquarium bazel chromium deluge gimp google-chrome
    libreoffice meld mplayer pcmanfm qemu qemu_kvm scrot
    sxiv tmate xclip xsel zathura claws-mail inkscape macchanger gthumb
    pkgs.nur.repos.rycee.firefox-addons-generator

    # services
    awscli circleci-cli google-cloud-sdk gist gitAndTools.hub slack spotify
    whois zoom-us zulip kubectl steam
    xorg.libxcb # required for steam

    # Fonts
    ubuntu_font_family source-code-pro

    # CLI
    ascii asciinema bashmount cmatrix cpufrequtils cpulimit curl
    direnv dnsutils docker_compose dos2unix entr exa fd ffmpeg file
    findutils fpp fzf gettext ghostscript gnupg graphviz hexedit htop
    htop imagemagick iw jq ltrace lynx moreutils mpv mtr multitail ncdu
    nix-zsh-completions nload nmap openssl pandoc paperkey pass-otp pdftk
    powerstat powertop pv pwgen pythonPackages.subliminal ranger ripgrep
    rsync sqlite strace tcpdump tig tmux tokei tree tree units
    unzip up watch weechat wget yq zbar zip zsh zsh-syntax-highlighting
    rclone starship cookiecutter git-lfs
    (hunspellWithDicts [ hunspellDicts.en-gb-ise ])
    (texlive.combine {
      inherit (texlive) scheme-small;
    })

    (import ./nix/mk-scripts.nix { inherit pkgs; } ./scripts)

    # editors
    neovim
    (kakoune.override {
      configure = {
        plugins = [ (callPackage ./packages/kakoune-surround.nix {}) ];
      };
    })

    # haskell
    stack cabal2nix
    (haskellPackages.ghcWithPackages (p: with p; [
      aeson cassava lens
    ]))
    (haskell.lib.justStaticExecutables haskellPackages.ghcid)

    # java/scala
    openjdk8 scala

    # python
    python37 python37Packages.virtualenv

    # nix
    nix-prefetch-scripts patchelf nix-top niv cachix
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
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-gtk2}/bin/pinentry
    '';
  };

  xsession = {
    enable = true;
    windowManager.command = "i3";
  };

  programs.firefox = {
    enable = true;

    extensions = builtins.attrValues (import ./nix/firefox-addons.nix {
      buildFirefoxXpiAddon = pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon;
      fetchurl = pkgs.fetchurl; stdenv = pkgs.stdenv;
    });

    profiles = {
      default = {
        id = 0;
        isDefault = true;
        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.startup.homepage" = "about:blank";
          "browser.link.open_newwindow" = 2;
          "browser.shell.checkDefaultBrowser" = false;
          "signon.rememberSignons" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.fullscreen.autohide" = false;
        };
        userChrome = ''
          #TabsToolbar {
            visibility: collapse !important;
            margin-bottom: 21px !important;
          }

          #library-button { display: none; }
          #sidebar-button { display: none; }
          #fxa-toolbar-menu-button { display: none; }
          #stop-reload-button { display: none; }
          #home-button { display: none; }
          #customizableui-special-spring1 { display: none; }
          #customizableui-special-spring2 { display: none; }
        '';
      };
    };
  };

  manual.manpages.enable = true;

  home.file.".config/kak/kakrc".source = ./dotfiles/kakrc;

  home.file.".config/i3/config".source = ./dotfiles/i3/config;
  home.file.".config/i3/autostart.sh".source = ./dotfiles/i3/autostart.sh;
  home.file.".config/i3/wallpaper.png".source = ./dotfiles/i3/wallpaper.png;
  home.file.".config/i3blocks/config".source = ./dotfiles/i3/i3blocks;

  home.file.".config/kitty/kitty.conf".source = ./dotfiles/kitty.conf;

  home.file.".config/rofi/config".source = ./dotfiles/rofi;

  home.file.".config/mimeapps.list".source = ./dotfiles/mimeapps.list;

  home.file.".config/starship.toml".source = ./dotfiles/starship.toml;

  home.file.".zshrc".text = ''
    ${pkgs.any-nix-shell}/bin/any-nix-shell zsh | source /dev/stdin
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    source ${./dotfiles/zshrc}

    source ${sources.h}/h.sh
    h_init_zsh
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
        --prefix PATH : "${pkgs.acpi}/bin:${pkgs.libnotify}/bin:${pkgs.bash}/bin:${pkgs.gnugrep}/bin"
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

  # Force home-manager to use pinned nixpkgs
  _module.args.pkgs = pkgs.lib.mkForce pkgs;
}
