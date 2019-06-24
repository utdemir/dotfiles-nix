let
nixpkgs = builtins.fetchGit {
  url = "https://github.com/NixOS/nixpkgs";
  rev = "852d81d6077df5e642bf41825ac7cb5c799a13b9";
};
in
import nixpkgs { config.allowUnfree = true; }
