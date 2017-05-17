{ pkgs }:

{
  mkDotfiles = files:
    pkgs.writeScript "dotfiles" ''
      function trace() {
        echo "! $@"; $@
      }

      set -o errexit
      set -o nounset

      ${ pkgs.lib.concatMapStringsSep "\n" ({path, target}: ''
           mkdir -p "$HOME/$(dirname ${path})";
         trace ln -sfn "${target}" "$HOME/${path}"
           '')
         files }
    '';
}
