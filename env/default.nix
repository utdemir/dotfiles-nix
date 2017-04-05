{ nixpkgs }:
let
  pkgs = import nixpkgs {};
  
  env = pkgs.buildEnv {
    name = "utdemir-env";
    paths = with pkgs; [
      findutils gnugrep coreutils gnused
      watch

      gitMinimal gitAndTools.hub
      pv jq silver-searcher tree

      (import ./emacs.nix { inherit pkgs; })
      
      awscli     
      (kubernetes.override { components = [ "cmd/kubectl" ]; })
      gcc

      openjdk8      
      (sbt.override { jre = jre8; })
      haskellPackages.ShellCheck
      python2 python3
    ];
  };
in  env

# nix-env -f default.nix -i utdemir-env -j 4 --arg nixpkgs $HOME/Documents/workspace/github/nixos/nixpkgs
