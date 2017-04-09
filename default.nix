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

      awscli
      (kubernetes.override { components = [ "cmd/kubectl" ]; })

      gcc openjdk8
      (sbt.override { jre = jre8; })
      haskellPackages.ShellCheck
      python2 python3
      python3Packages.virtualenv
    ];
  };
in  env

# nix-env -f default.nix -i utdemir-env -j 4 --arg nixpkgs $HOME/Documents/workspace/github/nixos/nixpkgs
