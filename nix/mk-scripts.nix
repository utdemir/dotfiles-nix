{ pkgs }: path:

pkgs.runCommand "scripts" { src = path; } ''
  mkdir -p $out/bin
  cp $src/* $out/bin
  chmod +x $out/bin/*
''
