{...}:

let pkgs = import ./nixpkgs { config.allowBroken = true; config.allowUnfree = true; };
in

{
  home.packages = with pkgs; [
    # CLI
    ranger
    arandr scrot bashmount
    xsel xclip
    imagemagick pdftk ncdu
    htop tree units ascii
    powertop ghostscript
    haskellPackages.tldr
    translate-shell

    nload siege

    zip unzip

    file dos2unix findutils coreutils
    watch graphviz rsync parallel openssl
    inotify-tools

    zsh
    oh-my-zsh

    entr xdotool

    lastpass-cli gnupg keybase

    # i3
    i3 i3status i3lock feh dmenu rofi rxvt_unicode unclutter
    networkmanagerapplet parcellite
    lxappearance xfontsel ubuntu_font_family source-code-pro

    # Desktop
    firefox

    # Media
    qiv  zathura
    pasystray pavucontrol
    smplayer mplayer audacity gimp

    spotify

    # Utils
    libreoffice dia chromium

    # Programming
    neovim

    (emacsWithPackages (epkgs: with epkgs.melpaPackages // epkgs.elpaPackages; [
      company
      counsel
      counsel-projectile
      csv-mode
      dash
      doom-themes
      dumb-jump
      git-gutter
      go-mode
      graphviz-dot-mode
      haskell-mode
      highlight-symbol
      hindent
      magit
      multiple-cursors
      nix-mode
      projectile
      protobuf-mode
      restclient
      rg
      rich-minority
      rust-mode
      sbt-mode
      scala-mode
      smart-mode-line
      org-present
      undo-tree
      ws-butler
      yaml-mode

      expand-region
      highlight-thing
    ]))

    ( vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.Nix
      ] ++ vscode-utils.extensionsFromVscodeMarketplace [
        { name = "language-haskell";
          publisher = "justusadam";
          version = "2.4.0";
          sha256 = "1xgxs0s3w5kf356nslf020svn2hr6dq216ndwjk23v6mqs1xfxgv";
        }
        { name = "scala";
          publisher = "daltonjorge";
          version = "0.0.5";
          sha256 = "0hvrc6qh0731j0vg9crxr0g8ada726c9r76bb6qz8iv8cnng0vgx";
        }
        { name = "rest-client";
          publisher = "humao";
          version = "0.17.0";
          sha256 = "0snjly1k22hpdk8c7dncrxnpykjhja3qi38hcsv7znpwi7325hpg";
        }
        { name = "edit-with-shell";
          publisher = "ryu1kn";
          version = "0.3.0";
          sha256 = "1lvnlnykvkjqbb0r3hlxzd0bvxm6j8kpq6sxdyw97hmvjwgy89dy";
        }
        { name = "shellcheck";
          publisher = "timonwong";
          version = "0.3.0";
          sha256 = "09l69d6fh5wd8r1phxffn56r10jhmgqpsbwn5d9g2ndj4idqd629";
        }
        { name = "bookmarks";
          publisher = "alefragnani";
          version = "0.18.2";
          sha256 = "11fayp0qwvrvh0i86km1dh2fphp58g4j69h04xw3i1qr54c30wiv";
        }
        { name = "git-project-manager";
          publisher = "felipecaputo";
          version = "1.4.0";
          sha256 = "0xb3pgf59279il0y1jxsdwy02sdyfzw6y88gvalfnml399w7brps";
        }
      ];
    })

    gitAndTools.hub

    pv jq ripgrep tree fasd
    ncdu htop cloc units
    haskellPackages.lentil
    haskellPackages.pandoc
    curl wget

    hexedit docker_compose

    mtr nmap

    cmatrix

    awscli

    cabal2nix stack
    gcc gnumake openjdk8 nodejs
    (sbt.override { jre = jre8; })
    haskellPackages.ShellCheck
    python2 python3
    python3Packages.virtualenv
    swiProlog

    nix-repl nix-prefetch-scripts
    (let src = pkgs.fetchFromGitHub {
      owner = "expipiplus1"; repo = "update-nix-fetchgit";
      rev = "c820f7bfad87ba9dc54fdcb61ad0ca19ce355c94";
      sha256 = "1f7d7ldw3awgp8q1dqb36l9v0clyygx0vffcsf49w4pq9n1z5z89"; };
     in haskell.lib.doJailbreak (haskellPackages.callPackage "${src}/default.nix" {})
    )

    autorandr
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
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  xsession = {
    enable = true;
    windowManager.command = "${pkgs.i3}/bin/i3";
    profileExtra = ''
    export SBT_OPTS="-Xms512M -Xmx1024M -Xss2M -XX:MaxMetaspaceSize=1024M"
    '';
  };

  services.keybase.enable = true;
  services.kbfs.enable = true;

  home.file.".stack/config.yaml".source = ./dotfiles/stack;
  
  home.file.".config/i3/config".source = ./dotfiles/i3/config;
  home.file.".config/i3/autostart.sh".source = ./dotfiles/i3/autostart.sh;
  home.file.".config/i3status/config".source = ./dotfiles/i3/i3status;
  home.file.".config/i3/wallpaper.png".source = ./dotfiles/i3/wallpaper.png;

  home.file.".Xdefaults".source = ./dotfiles/Xdefaults;
  
  home.file.".zshrc".source = ./dotfiles/zshrc;
  home.file.".zsh_custom/utdemir.zsh-theme".source = ./dotfiles/zsh_custom/utdemir.zsh-theme;

  home.file.".emacs.el".source = ./dotfiles/emacs.el;
  home.file.".config/.autorandr/postswitch" = {
    executable = true;
    text = ''
      #!/usr/bin/env sh
      feh --bg-fill ~/.config/i3/wallpaper.png
    '';
  };
}
