# Configuration for my workstation

## Features

* Lightweight, fast, up-to-date
* Keyboard and command line oriented
* i3, kakoune, qutebrowser and tons of shell utilities
* (Mostly) hardware agnostic
* Bleeding-edge

## Installation

* Install NixOS as usual.
* (Optional) Install cachix: `$(nix-build -A cachix https://cachix.org/api/v1/install)/bin/cachix use utdemir`
* Fork and clone this repository.
* Update `user.nix` with your information.
* Update `hardware.nix` based on your hardware.
* Run `./make.sh switch`.

**Warning**: The installed system is configured to use a
binary cache(`https://utdemir.cachix.org`) populated
by me. It should reduce the amount of things you build
on updates; however, theoretically, I could publish
malicious binaries to that server without you knowing.
So, remove the parts referring to `utdemir.cachix.org`
from `nix.binaryCaches` field on `configuration.nix` if
you do not trust me.
