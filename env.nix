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
      watch graphviz rsync parallel

      gitMinimal gitAndTools.hub
      haskellPackages.darcs

      pv jq ripgrep tree
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
      go
    ];
  };

  scripts = pkgs.runCommand "scripts" {} ''
    mkdir -p "$out"
    cp -r ${./scripts} "$out/bin" #*/
  '';
in  env

# nix-env -f default.nix -i utdemir-env -j 4 --arg nixpkgs $HOME/Documents/workspace/github/nixos/nixpkgs
