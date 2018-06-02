let
nixpkgs = (import <nixpkgs> {}).fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs";
  rev = "ea3769ec81a3a8e95ecd995d90165998a2d91938";
  sha256 = "09dclks5byrri5dn83jml06nnpqd8bc6pxdc67qdlzpd0vpqzzfp";
};
in
import nixpkgs { config.allowUnfree = true; }
