{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "protoc-gen-go-${version}";
  version = "0.0.1-dev";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "protobuf";
    rev = "b50ceb1fa9818fa4d78b016c2d4ae025593a7ce3";
    sha256 = "1hfyhfn7wr8v71jqg6bl07rnghg6hx5y9fq0ks2nwihplkgn30qv";
  };

  goPackagePath = "github.com/golang/protobuf";

  meta = with stdenv.lib; {
    description = "Go support for Google's protocol buffers";
    homepage = https://github.com/golang/protobuf;
    maintainers = with maintainers; [ utdemir ];
    platforms = with platforms; unix;
  };
}
