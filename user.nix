{ nixpkgs ? builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/release-17.03.zip";
  }
}:
let
  pkgs = import nixpkgs {};
  env = pkgs.buildEnv {
    name = "utdemir-env";
    paths = with pkgs; [
      pv
      jq
      git
      silver-searcher
          
      awscli
      
      gnumake
#      kubernetes.override {
#        components = [ "cmd/kubectl" ];
#      }
    ];
  };
in  env
