let sources = import ./sources.nix;
    pkgs = import sources.nixpkgs {};
in pkgs.runCommand "home-manager-patched" {} ''
    mkdir -p $out
    cd $out/
    cp --no-preserve=mode -r ${sources.home-manager}/* .
    patch -p1 < ${./home-manager-dont-use-nix-path.patch}
  ''
