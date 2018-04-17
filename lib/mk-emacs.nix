{ pkgs }: el:

let
  packages = import (pkgs.runCommand "mk-emacs" {
    buildInputs = [ (pkgs.emacs26WithPackages (epkgs: [])) ];
  } "emacs --script ${./use-package-to-nix.el} ${el} > $out");
in
  pkgs.emacs26WithPackages (epkgs:
    let s = epkgs.melpaPackages // epkgs.elpaPackages;
    in  builtins.map (i: s.${i}) (packages ++ ["use-package"])
  )
