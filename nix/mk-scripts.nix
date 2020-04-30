{ runCommand, makeWrapper }:

{ path, postBuild ? "" }:

runCommand "scripts" {
  buildInputs = [ makeWrapper ];
  preferLocalBuild = true;
} ''
  mkdir -p $out/bin
  cp -v ${path}/* $out/bin
  chmod +x $out/bin/*
  ${postBuild}
''
