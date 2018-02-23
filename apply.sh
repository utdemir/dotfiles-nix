#!/usr/bin/env sh

set -o errexit
set -o pipefail

cd "$( dirname "${BASH_SOURCE[0]}" )"

echo
echo "# Applying system configuration."
echo

sudo cp /etc/nixos/configuration.nix{,-$(date +%s).bac}
cat <<EOF | sudo tee /etc/nixos/configuration.nix > /dev/null
{
  imports =
    [ $(realpath ./$(hostname)-configuration.nix)
      ./hardware-configuration.nix
    ];
}
EOF

sudo nixos-rebuild --upgrade switch

echo
echo "# Applying home configuration."
echo

home-manager -f ./$(hostname)-home.nix switch
