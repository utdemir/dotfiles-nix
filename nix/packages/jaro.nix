{ stdenv, lib, fetchFromGitHub, guile, xdgRedirect ? false }:

stdenv.mkDerivation rec {
  pname = "jaro";
  version = "v0.5.5";
  src = fetchFromGitHub {
    owner = "isamert";
    repo = "jaro";
    rev = version;
    sha256 = "00klgpcszq2b9bqyj1p71yvxiq11qpm8nhf8knxnn6r3yzbjd6i4";
  };
  buildInputs = [ guile ];
  installPhase = ''
    install -Dm755 jaro $out/bin/jaro
    patchShebangs $out/bin

    install -Dm644 data/jaro.desktop "$out/share/applications/jaro.desktop"
    install -Dm644 data/mimeapps.list $out/share/jaro/mimeapps.list
    ${ lib.optionalString xdgRedirect ''
      mkdir -p $out/etc/xdg
      ln -s $out/share/jaro/mimeapps.list -t $out/etc/xdg/
    '' }
  '';
}
