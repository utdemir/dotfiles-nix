let
  sources = import ./nix/sources.nix { };
  pkgs = import sources.nixpkgs { };
in
pkgs.mkShell {
  name = "dotfiles-shell";
  buildInputs = [ pkgs.morph ];
}
