{ pkgs }: el:

let
  packages = import (pkgs.runCommand "mk-emacs" {
    buildInputs = [ (pkgs.emacsWithPackages (epkgs: [])) ];
  } "emacs --script ${./use-package-to-nix.el} ${el} > $out");
  emacs = pkgs.emacsWithPackages (epkgs:
    let s = epkgs.elpaPackages // epkgs.melpaPackages // epkgs;
    in  builtins.map (i: s.${i}) (packages ++ ["use-package"])
  );
in 
  pkgs.runCommand "emacs-custom" { buildInputs = [ pkgs.makeWrapper ]; } ''\
    mkdir -p $out/bin
    makeWrapper ${emacs}/bin/emacs $out/bin/emacs \
      --add-flags "-l ${el}"
  ''
