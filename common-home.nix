{ pkgs, ... }:

{
  home.packages = with pkgs; [
    arandr rxvt_unicode spotify qutebrowser scrot
    qiv zathura xclip networkmanagerapplet i3status dmenu
    unclutter i3lock feh dia xsel parcellite ncdu
    ranger imagemagick pdftk file dos2unix bashmount
    workrave
    
    smplayer mplayer audacity gimp

    lxappearance xfontsel
    ubuntu_font_family

    zip unzip atool
    
    neovim nload siege
    lastpass-cli 

    oh-my-zsh
    
    zsh findutils gnugrep coreutils gnused
    watch graphviz rsync parallel ascii

    gitAndTools.hub
    haskellPackages.darcs

    pv jq ripgrep tree fasd
    ncdu htop cloc units
    haskellPackages.lentil
    haskellPackages.pandoc
    curl wget

    mtr nmap

    cmatrix

    awscli

    cabal2nix stack
    gcc gnumake openjdk8 nodejs
    (sbt.override { jre = jre8; })
    haskellPackages.ShellCheck
    python2 python3
    python3Packages.virtualenv

    nix-repl nix-prefetch-scripts
    (let src = pkgs.fetchFromGitHub {
      owner = "expipiplus1"; repo = "update-nix-fetchgit";
      rev = "c820f7bfad87ba9dc54fdcb61ad0ca19ce355c94";
      sha256 = "1f7d7ldw3awgp8q1dqb36l9v0clyygx0vffcsf49w4pq9n1z5z89"; };
     in haskellPackages.callPackage "${src}/default.nix" {}
    )
  ];

  programs.firefox = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Utku Demir";
    userEmail = "me@utdemir.com";
  };

  home.file.".stack/config.yaml".source = ./dotfiles/stack;
  
  home.file.".config/i3/config".source = ./dotfiles/i3/config;
  home.file.".config/i3/autostart.sh".source = ./dotfiles/i3/autostart.sh;
  home.file.".config/i3status/config".source = ./dotfiles/i3/i3status;
  home.file.".config/i3/wallpaper.png".source = ./dotfiles/i3/wallpaper.png;

  home.file.".Xdefaults".source = ./dotfiles/Xdefaults;
  
  home.file.".zshrc".source = ./dotfiles/zshrc;
  home.file.".zsh_custom/utdemir.zsh-theme".source = ./dotfiles/zsh_custom/utdemir.zsh-theme;

  home.file.".emacs".source = ./dotfiles/emacs;
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      monokai-theme
      nix-mode
      counsel
      magit
      ws-butler
      projectile
      counsel
      counsel-projectile
      undo-tree
      rg
      haskell-mode
      intero
      ace-jump-mode
      nix-mode
      protobuf-mode
      git-gutter
      highlight-symbol
      diminish
      scala-mode
      sbt-mode
      restclient
    ];
  };
}
