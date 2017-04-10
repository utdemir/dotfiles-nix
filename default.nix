{ nixpkgs }:
let
  pkgs = import nixpkgs {};
  
  env = pkgs.buildEnv {
    name = "utdemir-env";
    paths = with pkgs; [
      (import ./emacs.nix { inherit pkgs; })
      (import ./dotfiles.nix { inherit pkgs; })

      findutils gnugrep coreutils gnused
      watch graphviz

      gitMinimal gitAndTools.hub
      haskellPackages.darcs

      pv jq silver-searcher tree
      kt ncdu htop cloc
      haskellPackages.lentil
      haskellPackages.pandoc

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
      haskellPackages.idris
      go
    ];
  };
in  env

# nix-env -f default.nix -i utdemir-env -j 4 --arg nixpkgs $HOME/Documents/workspace/github/nixos/nixpkgs
