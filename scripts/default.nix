{ runCommand
, stdenv
, lib
, resholve
, coreutils
, yad
, bash
, gawk
, libnotify
, ranger
, dnsutils
, whois
, gnugrep
, pv
, findutils
, gnused
, ncurses
, pass
, rofi
, maim
, zbar
}:

let
  # TODO delete after https://github.com/abathur/resholve/issues/24
  pass_ = runCommand "pass-hack" { } ''
    mkdir -p $out/bin/
    ln -s ${pass}/bin/pass $out/bin/pass_
  '';
in

stdenv.mkDerivation {
  name = "scripts";
  buildInputs = [ resholve yad bash ];
  src = builtins.filterSource (p: ty: builtins.baseNameOf p != "default.nix") ./.;
  preferLocalBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp * $out/bin
  '';
  fixupPhase = ''
    for i in $out/bin/*; do
      set -x
      resholve $i \
         --interpreter ${bash}/bin/bash \
         --path "${lib.makeBinPath [ coreutils yad gawk libnotify dnsutils whois
                                     gnugrep pv findutils gnused ncurses pass_ rofi
                                     maim zbar ]}" \
         --keep '$EDITOR' \
         --overwrite
      set +x
    done
  '';
}
