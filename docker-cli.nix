{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "docker-cli";
  src = pkgs.fetchFromGitHub {
    owner = "moby"; repo = "moby";
    rev = "3c5f3fd42bfb449ca56df03250096b3bd1bd22de";
    sha256 = "078k0yy7h5jia6hs6xra0ik8wb392isbc8mk5r4d4ydv627vlzdi";
  };
  buildInputs = [ pkgs.go ];
  phases = "unpackPhase buildPhase";
  buildPhase = ''
    export AUTO_GOPATH=1
    export DOCKER_GITCOMMIT="DEV"
    ./hack/make.sh binary-client
    mkdir -p $out/bin
    cp bundles/latest/binary-client/docker $out/bin/
  '';
}
