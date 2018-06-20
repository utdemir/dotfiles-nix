let
nixpkgs = (import <nixpkgs> {}).fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs";
  rev = "bf6974648ecb0ef7d81eed2a38766ba008996abb";
  sha256 = "0dn25cxczgdjay7scyaj8fjrdl92lknil0xpnwn6svi8i23li3s9";
};
in
import nixpkgs { config.allowUnfree = true; }
