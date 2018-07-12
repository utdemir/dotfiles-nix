let
nixpkgs = (import <nixpkgs> {}).fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs";
  rev = "394ef8245153fceedf21928f6175ff8bc691b71b";
  sha256 = "0zmkrwzbbv1kf4f56pn20g1yyn6hih7w4ibdzv6gak783scrsbnb";
};
in
import nixpkgs { config.allowUnfree = true; }
