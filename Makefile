define default-conf =
{
  imports =
    [ $(realpath ./$(hostname)-configuration.nix)
      ./hardware-configuration.nix
    ];
}
endef

HOSTNAME = $(shell hostname)

all: system home

system:
	@echo "# Applying system configuration."
	sudo cp /etc/nixos/configuration.nix{,-$$(date +%s).bac}
	echo "{ imports = [ $$(realpath ./${HOSTNAME}-configuration.nix) ./hardware-configuration.nix ]; }" \
	  | sudo tee /etc/nixos/configuration.nix > /dev/null
	sudo nixos-rebuild --upgrade switch

home:
	@echo "# Applying home configuration."
	home-manager -f ./${HOSTNAME}-home.nix switch
