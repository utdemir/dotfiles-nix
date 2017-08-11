#!/usr/bin/env sh

set -o errexit

cd "$( dirname "${BASH_SOURCE[0]}" )"

echo
echo "# Applying system configuration."
echo

sudo cp /etc/nixos/configuration.nix{,-$(date +%s).bac}
cat <<EOF | sudo tee /etc/nixos/configuration.nix > /dev/null
{
  imports =
    [ $(realpath ./configuration-$(hostname).nix)
      ./hardware-configuration.nix
    ];
}
EOF

sudo nixos-rebuild switch

echo
echo "# Applying home configuration."
echo

home-manager -f ./home-$(hostname).nix switch
