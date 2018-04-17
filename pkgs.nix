import ((import <nixpkgs> {}).fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs";
  rev = "ad78e52357eb3df0f457c40185504567c7da524e";
  sha256 = "1gxynidpk23w7mabad5y35cmyhx1jsdfxl8r2xn4d0gnv39d090y";
}) {
  config.allowUnfree = true;
}
