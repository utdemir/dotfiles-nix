let versions = import ../versions.nix;
    pkgs = import versions.nixpkgs {};
in pkgs.runCommand "home-manager-patched" {} ''
    mkdir -p $out
    cd $out/
    cp --no-preserve=mode -r ${versions.home-manager}/* .
    patch -p1 < ${./home-manager-dont-use-nix-path.patch}
  ''
