let
nixpkgs = (import <nixpkgs> {}).fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs";
  rev = "16b3217148b02ad5a2149b500dbfcfa08d7b46d7";
  sha256 = "0qymr506n3vk418is6c5rgdammkhiz603a0xv0bq6zh783hvncjq";
};
in
import nixpkgs { config.allowUnfree = true; }
