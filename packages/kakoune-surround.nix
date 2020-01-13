{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "kakoune-surround";
  version = "unstable";
  src = fetchFromGitHub {
    owner = "h-youhei";
    repo = "kakoune-surround";
    rev = "efe74c6f434d1e30eff70d4b0d737f55bf6c5022";
    sha256 = "09fd7qhlsazf4bcl3z7xh9z0fklw69c5j32hminphihq74qrry6h";
  };
  installPhase = ''
    mkdir -p $out/share/kak/autoload
    cp * $out/share/kak/autoload
  '';
}
