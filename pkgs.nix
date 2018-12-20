let
nixpkgs = (import <nixpkgs> {}).fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs";
  rev = "65dfc2b272819760f7c7adf848ccff36390c0425";
  sha256 = "1wyc2m9nvdmj5kflgg5y2ravaih49wkc00xvzjcyz54ich3gyk92";
};
in
import nixpkgs { config.allowUnfree = true; }
