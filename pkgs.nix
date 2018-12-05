let
nixpkgs = (import <nixpkgs> {}).fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs";
  rev = "e42d10957d87a5837085cd3273f97e50b67e987d";
  sha256 = "1ggq8jwwgmspwsrarvnii078db0jw6jrkj0k98s1lk9il4464zyi";
};
in
import nixpkgs { config.allowUnfree = true; }
