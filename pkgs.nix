let
nixpkgs = (import <nixpkgs> {}).fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs";
  rev = "46b03cd5b2ed13cd9534192cefa1396ca861a835";
  sha256 = "0irpwg5w1ipnhqibkc1dr15nvnyr93k15x42hrwjba9vqli8kgka";
};
in
import nixpkgs { config.allowUnfree = true; }
