self: super:
{
  jaro = self.callPackage ./nix/packages/jaro.nix { xdgRedirect = true; };

  naersk = self.callPackage self.dotfiles-inputs.naersk {};
}
