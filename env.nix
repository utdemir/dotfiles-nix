{ nixpkgs ?
    let rev = "afec912d81e08339868e0e1e84234e6ed7f6b3fd";
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
#      (import ./docker-cli.nix { inherit pkgs; })
      scripts

      zsh findutils gnugrep coreutils gnused
      watch graphviz rsync parallel protobuf3_2

      gitMinimal gitAndTools.hub
      haskellPackages.darcs

      pv jq ripgrep tree fasd
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

      (pkgs.haskellPackages.ghcWithPackages (p: with p; [
        aeson cassava
        pipes foldl lens lens-aeson split
        attoparsec trifecta parsers
        async turtle
        wreq http-client http-client-tls
        wai warp servant
        servant-server servant-client
      ]))
    ];
  };

  scripts = pkgs.runCommand "scripts" {} ''
    mkdir -p "$out"
    cp -r ${./scripts} "$out/bin" #*/
  '';

  dotfiles = import ./dotfiles.nix { inherit pkgs; };
in pkgs.writeScript "apply.sh" ''
  set -o errexit
  set -o xtrace
  nix-env -i ${env}
  ${dotfiles}
  echo "Done!"
''
# $(nix-build env.nix)
