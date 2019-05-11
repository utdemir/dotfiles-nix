let
nixpkgs = builtins.fetchGit {
  url = "https://github.com/NixOS/nixpkgs";
  rev = "ecf59492c75220e37caf533d09087349ab7e5577";
};
in
import nixpkgs { config.allowUnfree = true; }
