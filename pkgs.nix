let
nixpkgs = (import <nixpkgs> {}).fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs";
  rev = "21f20b5f7b837b15d6918405a48586c31328c270";
  sha256 = "0v36lqfqvq71xlw3x4n3xrzsimx18sh2w6dm30v88lf9a9yk21az";
};
in
import nixpkgs { config.allowUnfree = true; }
