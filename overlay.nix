self: super:
{
  sources = import ./nix/sources.nix;

  jaro = self.callPackage ./nix/packages/jaro.nix { xdgRedirect = true; };

  kakoune-surround = self.callPackage ./nix/packages/kakoune-surround.nix { };
  kakoune-rainbow = self.callPackage ./nix/packages/kakoune-rainbow.nix { };
}
