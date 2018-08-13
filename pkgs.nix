let
nixpkgs = (import <nixpkgs> {}).fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs";
  rev = "996c0d6e003e69b3683c9a2985bcba5aea0982cc";
  sha256 = "19wwl4dm5skggc9d4ybc8r4igqks707lh3xbqnqfylz67cl47kmm";
};
in
import nixpkgs { config.allowUnfree = true; }
