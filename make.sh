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
  $0 info
  $0 cleanup
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
        tmp="$(mktemp -u)"
        trace nix build --no-link -f "$DIR/default.nix" system -o "$tmp/result" $*
        trap "rm '$tmp/result'" EXIT
        drv="$(readlink "$tmp/result")"
        echo "$drv"
        ;;
    "switch")
        drv="$(trace "$0" build)"
        trace sudo nix-env -p /nix/var/nix/profiles/system --set "$drv"
        NIXOS_INSTALL_BOOTLOADER=1 trace sudo --preserve-env=NIXOS_INSTALL_BOOTLOADER "$drv/bin/switch-to-configuration" switch
        ;;
    "update")
        pkgs_rev="$(trace git ls-remote https://github.com/nixos/nixpkgs | grep 'refs/heads/master' | cut -f 1)"
        trace sed -ri "s/(rev.*\").*(\")/\1$pkgs_rev\2/g" "$DIR/pkgs.nix"
        hm_rev="$(trace git ls-remote https://github.com/rycee/home-manager | grep 'refs/heads/master' | cut -f 1)"
        trace sed -ri "s/(rev.*\").*(\")/\1$hm_rev\2/g" "$DIR/home-manager.nix"
        trace "$0" build
        ;;
    "info")
        drv="$(trace "$0" build)"

        echo "> Derivation:"
        echo "$drv"
        echo

        echo "> Derivation size: "
        du -shc $(nix-store -qR "$drv") | tail -n 1 | grep -Po "^[^\t]*"
        echo

        echo "> Auto GC roots:"
        roots=""
        for i in /nix/var/nix/gcroots/auto/*; do
          p="$(readlink "$i")"
          if [[ -e "$p" ]]; then
            s="$(du -sch $(nix-store -qR "$p") | tail -n 1 | grep -Po "^[^\t]*")"
            roots="$roots\n$s $p"
          fi
        done
        if [[ -n "$roots" ]];
        then echo "$roots"
        else echo "None."
        fi

        ;;
    "cleanup")
        nix-collect-garbage --delete-older-than 30d
        nix optimise-store
        ;;
    "help")
        [[ $# -gt 0 ]] && invalid_syntax
        usage
        ;;
    *)
        invalid_syntax
        ;;
esac
