# Configuration for my workstation

## Features

* Lightweight, fast, up-to-date
* Keyboard and command line oriented
* i3, kakoune, qutebrowser and tons of shell utilities
* (Mostly) hardware agnostic

## Installation

* Install NixOS as usual.
* Fork and clone this repository.
* Update `user.nix` with your information.
* Update `hardware.nix` based on your hardware.
* Run `./make.sh switch` and wait for a few hours.

**Warning**: The installed system is configured to use a
binary cache(`https://utdemir.cachix.org`) populated
by me. It should reduce the amount of things you build
on updates; however, theoretically, I could publish
malicious binaries to that server without you knowing.
So, remove the parts referring to `utdemir.cachix.org`
from `nix.binaryCaches` field on `configuration.nix` if
you do not trust me.
