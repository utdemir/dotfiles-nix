{ pkgs }: el:

let
  packages = import (pkgs.runCommand "mk-emacs" {
    buildInputs = [ (pkgs.emacsWithPackages (epkgs: [])) ];
  } "emacs --script ${./use-package-to-nix.el} ${el} > $out");
in
  pkgs.emacsWithPackages (epkgs:
    let s = epkgs.melpaPackages // epkgs.elpaPackages;
    in  builtins.map (i: s.${i}) packages
  )
