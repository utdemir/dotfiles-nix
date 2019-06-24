#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

function trace() {
    echo "! $@" >&2; $@
}

function usage() {
cat << EOF
Usage:
  $0 build
  $0 switch
  $0 update
  $0 help
EOF
}

function invalid_syntax() {
    echo "Invalid syntax." 2>&1
    usage 2>&1
    return 1
}

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

[[ $# -lt 1 ]] && invalid_syntax

mode="$1"
shift

case "$mode" in
    "build")
        trace nix build --no-link -f "$DIR/default.nix" system $*
        ;;
    "switch") 
        tmp="$(mktemp -u)"
        trace "$0" build -o "$tmp/result"
        trap "rm $tmp/result" EXIT
        drv="$(readlink $tmp/result)"
        
        trace sudo nix-env -p /nix/var/nix/profiles/system --set $drv
        NIXOS_INSTALL_BOOTLOADER=1 trace sudo --preserve-env=NIXOS_INSTALL_BOOTLOADER "$drv/bin/switch-to-configuration" switch
        ;;
    "update")
        pkgs_rev="$(trace git ls-remote https://github.com/nixos/nixpkgs | grep 'refs/heads/master' | cut -f 1)"
        trace sed -ri "s/(rev.*\").*(\")/\1$pkgs_rev\2/g" "$DIR/pkgs.nix"
        hm_rev="$(trace git ls-remote https://github.com/rycee/home-manager | grep 'refs/heads/master' | cut -f 1)"
        trace sed -ri "s/(rev.*\").*(\")/\1$hm_rev\2/g" "$DIR/home-manager.nix"
        trace $0 build
        ;;
    "help")
        [[ $# -gt 0 ]] && invalid_syntax
        usage
        ;;
    *)
        invalid_syntax
        ;;
esac
