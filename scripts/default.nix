{ runCommand
, resholveScriptBin
, symlinkJoin
, stdenv
, lib
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
sc =
  resholveScriptBin
    "sc"
    { interpreter = "${bash}/bin/bash"; inputs = [ coreutils ]; keep = { "$EDITOR" = true; }; }
    (builtins.readFile ./sc);

ergo =
  resholveScriptBin
    "ergo"
    { interpreter = "${bash}/bin/bash"; inputs = [ coreutils pv yad ]; execer = [ "cannot:${yad}/bin/yad" ]; }
    (builtins.readFile ./ergo);

battery-notification =
  resholveScriptBin
    "battery-notification"
    { interpreter = "${bash}/bin/bash"; inputs = [ coreutils gawk libnotify ]; }
    (builtins.readFile ./battery-notification.sh);

domain-lookup =
  resholveScriptBin
    "domain-lookup"
    { interpreter = "${bash}/bin/bash"; inputs = [ coreutils dnsutils whois gnugrep ]; }
    (builtins.readFile ./domain-lookup);

hr =
  resholveScriptBin
    "hr"
    { interpreter = "${bash}/bin/bash"; inputs = [ coreutils ncurses ]; execer = [ "cannot:${ncurses}/bin/tput" ]; }
    (builtins.readFile ./hr);

pass-rotate =
  resholveScriptBin
    "pass-rotate"
    { interpreter = "${bash}/bin/bash"; inputs = [ coreutils gnused findutils ncurses ]; execer = [ "cannot:${ncurses}/bin/tput" ]; }
    (builtins.readFile ./pass-rotate);

qr2pass =
  resholveScriptBin
    "qr2pass"
    { interpreter = "${bash}/bin/bash"; inputs = [ maim zbar ]; fake = { function = [ "pass" ]; }; } # https://github.com/abathur/binlore/issues/3
    (builtins.readFile ./qr2pass);

rofi-pass =
  resholveScriptBin
    "qr2pass"
    { interpreter = "${bash}/bin/bash"; inputs = [ coreutils findutils rofi gnugrep ]; fake = { function = [ "pass" "rofi" ]; }; } # https://github.com/abathur/binlore/issues/3
    (builtins.readFile ./rofi-pass);

in
symlinkJoin {
  name = "scripts";
  paths = [ sc ergo battery-notification domain-lookup hr pass-rotate qr2pass rofi-pass ];
}

# resholvePackage rec {
#   pname = "scripts";
#   version = "dev";
#   src = builtins.filterSource (p: ty: builtins.baseNameOf p != "default.nix") ./.;
#   solutions = {
#     profile = {
#       scripts = [ "battery-notification.sh" "ergo" "domain-lookup" "hr" "pass-rotate" "qr2pass" "rofi-pass" "sc" ];
#       interpreter = "${bash}/bin/bash";
#       inputs = [ coreutils yad gawk libnotify dnsutils whois
#                  gnugrep pv findutils gnused ncurses pass rofi
#                  maim zbar ];
#     };
#   };
#   phases = "buildPhase";
#   buildPhase = ''
#     mkdir $out
#     cp -v * $out
#   '';
# }

# stdenv.mkDerivation {
#   name = "scripts";
#   buildInputs = [ resholve yad bash ];
#   src = builtins.filterSource (p: ty: builtins.baseNameOf p != "default.nix") ./.;
#   preferLocalBuild = true;
#   installPhase = ''
#     mkdir -p $out/bin
#     cp * $out/bin
#   '';
#   fixupPhase = ''
#     for i in $out/bin/*; do
#       set -x
#       resholve $i \
#          --interpreter ${bash}/bin/bash \
#          --path "${lib.makeBinPath [ coreutils yad gawk libnotify dnsutils whois
#                                      gnugrep pv findutils gnused ncurses pass_ rofi
#                                      maim zbar ]}" \
#          --keep '$EDITOR' \
#          --overwrite
#       set +x
#     done
#   '';
# }
