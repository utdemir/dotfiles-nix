{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "kakoune-rainbow";
  version = "unstable";
  src = fetchFromGitHub {
    owner = "JJK96";
    repo = "kakoune-rainbow";
    rev = "34caf77ce14da52a4d8af6b8893a404605dda62a";
    sha256 = "1fmic508842161zzwmzilljz8p0fanjb15ycqb8hbsjpdy3fwvwi";
  };
  installPhase = ''
    mkdir -p $out/share/kak/autoload
    cp * $out/share/kak/autoload
  '';
}
