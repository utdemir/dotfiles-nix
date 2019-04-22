let
nixpkgs = builtins.fetchGit {
  url = "https://github.com/NixOS/nixpkgs";
  rev = "54084dd821d201eb18bfa57ae329f8554da51a25";
};
in
import nixpkgs { config.allowUnfree = true; }
