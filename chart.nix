{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "chart-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "marianogappa";
    repo = "chart";
    rev = "v${version}";
    sha256 = "0l1ncdnvdg1vaadp5jv707rl8dhkg5nryghkjcd5rjqgyjqfbxjr";
  };

  goPackagePath = "github.com/marianogappa/chart";

  meta = with stdenv.lib; {
    description = "Quick & smart charting for STDIN";
    homepage = https://github.com/marianogappa/chart;
    maintainers = with maintainers; [ utdemir ];
    platforms = with platforms; unix;
  };
}
