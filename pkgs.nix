let
nixpkgs = (import <nixpkgs> {}).fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs";
  rev = "95ba4711105181b81c596b7914f9e6173f4ca3f2";
  sha256 = "17mr7n81gpsj3qgx934c3qx5qvw8i6p778vvqwspy0l17m68z2av";
};
in
import nixpkgs { config.allowUnfree = true; }
