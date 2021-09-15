self: super:
{
  jaro = self.callPackage ./packages/jaro.nix { xdgRedirect = true; };
  pocket-add = self.stdenv.mkDerivation {
    name = "pocket-add";
    src = self.dotfiles-sources.pocket-add;
    installPhase = ''
      mkdir -p "$out/bin"
      install -D -m 555 --target-directory "$out/bin" pocket-add
    '';
  };
}
