{ nixpkgs ?
    let rev = "a027f103a0022d4e77d199fc139bb65ab14e278f";
    in builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${rev}.zip";
    }
}:
let
  pkgs = import nixpkgs {};
  
  env = pkgs.buildEnv {
    name = "utdemir-env";
    paths = with pkgs; [
      (import ./emacs.nix { inherit pkgs; })
      (import ./dotfiles.nix { inherit pkgs; })
#      (import ./docker-cli.nix { inherit pkgs; })
      scripts

      zsh findutils gnugrep coreutils gnused
      watch graphviz rsync parallel protobuf3_2

      gitMinimal gitAndTools.hub
      haskellPackages.darcs

      pv jq ripgrep tree
      kt ncdu htop cloc clac
      haskellPackages.lentil
      haskellPackages.pandoc
      (pkgs.callPackage ./chart.nix {})

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
      rustc

      go
      (pkgs.callPackage ./protoc-gen-go.nix {})

      nix-repl nix-prefetch-scripts
      (let src = pkgs.fetchFromGitHub {
        owner = "expipiplus1"; repo = "update-nix-fetchgit";
        rev = "c820f7bfad87ba9dc54fdcb61ad0ca19ce355c94";
        sha256 = "1f7d7ldw3awgp8q1dqb36l9v0clyygx0vffcsf49w4pq9n1z5z89"; };
       in haskellPackages.callPackage "${src}/default.nix" {}
      )
    ];
  };

  scripts = pkgs.runCommand "scripts" {} ''
    mkdir -p "$out"
    cp -r ${./scripts} "$out/bin" #*/
  '';
in  env

# nix-env -f default.nix -i utdemir-env -j 4 --arg nixpkgs $HOME/Documents/workspace/github/nixos/nixpkgs
