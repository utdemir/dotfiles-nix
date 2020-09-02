let
flake-compat = builtins.fetchTarball {
  url = https://github.com/edolstra/flake-compat/archive/c5c3c5b56b0afad0cb79b9a6f958a4a513b46721.tar.gz;
  sha256 = "0vnbhqf0lc4mf2zmzqbfv6kqj9raijxz8xfaimxihz3c6s5gma2x";
};
in
(import flake-compat { src = ../.; }).defaultNix.
  nixosConfigurations.${(import ../user.nix).hostname}.
  config.system.build.toplevel
