self: super:
{
  jaro = self.callPackage ./packages/jaro.nix { xdgRedirect = true; };
}
