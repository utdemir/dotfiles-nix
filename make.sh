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
        trace nix build --no-link -f "$DIR/lib/default.nix" system -o "$tmp/result" $*
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
        repos="$(cat "$DIR/versions.nix" | grep url | grep -Po '".*"' | tr -d '"')"
        for repo in $repos; do
            short="$(basename "$repo")"
            curr_rev="$(cat "$DIR/versions.nix" | grep "$repo" -A 1 | grep 'rev =' | grep -Po '".*"' | tr -d '"')"
            new_rev="$(git ls-remote "$repo" | grep 'refs/heads/master' | cut -f 1)"
            if [[ "$curr_rev" = "$new_rev" ]]; then
                echo "$short is up to date."
            else
                echo "$short - New commits found:"
                if [[ "$repo" =~ https://github.com/* ]]; then
                    echo "$repo/compare/$curr_rev...$new_rev"
                else
                    echo "$repo: $curr_rev...$new_rev"
                fi
                
                sed "s/$curr_rev/$new_rev/" -i "$DIR/versions.nix"
            fi
        done
        trace "$0" build
        ;;
    "info")
        drv="$(trace "$0" build)"

        echo "> Derivation:"
        echo "$drv"
        echo

        echo "> Biggest dependencies:"
        du -shc $(nix-store -qR "$drv") | sort -hr | head -n 21 || true
        echo

        echo "> Auto GC roots:"
        roots=""
        for i in /nix/var/nix/gcroots/auto/*; do
          p="$(readlink "$i")"
          if [[ -e "$p" ]]; then
            s="$(du -sch $(nix-store -qR "$p") | tail -n 1 | grep -Po "^[^\t]*")"
            roots="$roots$s $p\n"
          fi
        done
        if [[ -n "$roots" ]];
        then echo -e "$roots" | sort -hr
        else echo "None."
        fi
        ;;
    "cleanup")
        nix-collect-garbage --delete-older-than 7d
        nix optimise-store
        ;;
    "help")
        [[ $# -gt 0 ]] && invalid_syntax
        usage
        ;;
    *)
        invalid_syntax
esac
