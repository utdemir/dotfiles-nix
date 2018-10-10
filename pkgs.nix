let
nixpkgs = (import <nixpkgs> {}).fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs";
  rev = "10a41bc1aff047df9da0991f67c7ada3b88e2f43";
  sha256 = "0f1ql5pnrv482i6ldzlaypn5m28yk2q8jm7slzfhfhfs2j85gl62";
};
in
import nixpkgs { config.allowUnfree = true; }
