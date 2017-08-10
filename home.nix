{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # ui   

    arandr rxvt_unicode spotify qutebrowser scrot
    qiv zathura xclip networkmanagerapplet i3status dmenu
    unclutter i3lock feh slack deluge dia
    dropbox ranger imagemagick pdftk 

    # games
    hedgewars

    # multimedia
    smplayer mplayer audacity minidlna

    # looks
    lxappearance xfontsel
    ubuntu_font_family

    # console
    nixops

    unzip atool
    
    neovim nload siege
    oh-my-zsh lastpass-cli 

    zsh findutils gnugrep coreutils gnused
    watch graphviz rsync parallel ascii

    gitAndTools.hub
    haskellPackages.darcs

    pv jq ripgrep tree fasd
    ncdu htop cloc
    haskellPackages.lentil
    haskellPackages.pandoc
    curl wget

    mtr nmap

    cmatrix

    awscli
    (kubernetes.override { components = [ "cmd/kubectl" ]; })

    cabal2nix
    gcc openjdk8 nodejs
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

  home.file.".config/i3/config".source = ./dotfiles/i3/config;
  home.file.".config/i3/autostart.sh".source = ./dotfiles/i3/autostart.sh;
  home.file.".config/i3status/config".source = ./dotfiles/i3/i3status;
  home.file.".config/i3/wallpaper.png".source = ./dotfiles/i3/wallpaper.png;

  home.file.".Xdefaults".source = ./dotfiles/Xdefaults;
  
  home.file.".zshrc".source = ./dotfiles/zshrc;
  home.file.".zsh_custom/utdemir.zsh-theme".source = ./dotfiles/zsh_custom/utdemir.zsh-theme;

  home.file.".minidlna.conf".text = ''
    friendly_name=SerenityEntertainmentConsole
    media_dir=/home/utdemir/Downloads
    db_dir=/home/utdemir/.cache/minidlna
    '';

  home.file.".emacs".source = ./dotfiles/emacs;
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      use-package
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
    ];
  };
}
