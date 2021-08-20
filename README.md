# Configuration for my workstation and servers

This repository forms my home network; including services, applications
and configurations for my workstations (one desktop and one laptop), and
the home server I use mainly for the backups.

The overall setup is specific to my home network; however, feel free to
steal any parts that look useful to you.

## Features

### Network

* Uses [Tailscale][tailscale] for connectivity.
* Configurations are deployed via [morph][].

[morph]: https://github.com/DBCDK/morph
[tailscale]: https://tailscale.com/

### Workstation(s)

* Keyboard and command line oriented
    * i3, kakoune, qutebrowser and lots of shell utilities
* Lightweight, fast, simple
    * No bloated DE's or "fully-featured" applications.
    * JavaScript disabled by default.
    * Single codebase describing the whole system.
* Bleeding-edge
    * Closely follows `nixpkgs` and `home-manager` HEAD
* (Almost) Free as in freedom
    * Explicitly allow non-free packages in 'system.nix' (look for
      'allowUnfreePredicate')

## Motivation

I follow the philosophy of "things should do one thing and do it well",
so I try to avoid complex tools.  I found a few rule-of-thumbs which
helps me decide if a tool is sufficiently complex or not. I try not to
use something if it:

* .. does window-management, but is not a window manager. (editors with
frames, terminals with splits, browsers with tabs etc.)
* .. has an integrated editor. (usually GUI applications and curses
TUI's.)
* .. does not have a form of text-based configuration.
* .. requires a lot of configuration/customisation to use.
* .. not free (as in freedom).

It's pretty hard to find applications fitting all of those criteria; so
sometimes I resort to disabling features, preferably with a configuration
flag, or simply by disabling the relevant keybindings.

## Docs

Below are some tips for the tools I'm using, and my rationale for using them.
They are not comprehensive, so consult their own documentation to use them
effectively.

---

### Operating System: NixOS

All this configuration revolves around using [NixOS](https://nixos.org/)
operating system and the [Nix](https://nixos.org/nix) programming language.

Nix provides a declarative way to declare your system, and has enough theory
behind to have purity and rollbacks trivial.

The way I use Nix/NixOS sometimes slightly differs from the common usage:

* I use [home-manager](https://github.com/rycee/home-manager) to manage
my dotfiles. This gives me a fully-reproducible and programmable system.
* I do not use `/etc/nixos/configuration.nix`. The system activation scripts
are built and deployed via [morph][].
* I don't use channels and `NIX_PATH`. I understand the rationale behind
them, but I think they make things less obviously deterministic (action
at a distance).  So I prefer to always pin `nixpkgs` and don't use
`< ... >` syntax at all.
* I follow the `nixpkgs-unstable` branch of `nixpkgs`. The main reason
is that I like to have the latest & greatest packages on my system. I
found it quite stable, and I can just reboot the system to a previous
generation if there is a major issue.

---

### Window Manager: i3

I use [i3][] as the window manager. It is fast and does
its jobs well.

[i3]: https://i3wm.org

`i3` is my *only* window manager. So; I do not use terminal-multiplexers,
applications with tabs/panes/frames/buffers etc.

---

### Shell: fish

I use `fish`. I have some amount of customisation, but nothing unusual. Comes
with a handful of useful plugins.

I might switch back to `zsh` or `bash` because I am more used to their syntax.

---

### Terminal Emulator: kitty

I use [kitty](https://github.com/kovidgoyal/kitty), with minimal
features. I find it sufficiently simple, easy to configure, and it has a
`hints` feature I use quite frequently. However its main developer is
a bit mean, so I am keen to switch to a new terminal emulator; however
I couldn't figure out a easy way to get hints without using `tmux`.

---

### Editor: kakoune

I spend a lot of time editing text, so it took me quite a long time to
settle on using [kakoune](https://github.com/mawww/kakoune). I think
it's the only usable editor adhering to the UNIX philosophy.

Surprisingly, I only have about 30 lines of configuration for it, they
just add a few keybindings, make it always use the system clipboard,
and change a few visuals.

Even if I am a software developer using multiple programming ecosystems
daily; I do not much programming-specific configuration on my editor. I
use `kakoune` solely for editing code, and have an another terminal
window open which runs/typechecks the project continuously. It does
support LSP for some languages, but I rarely rely on it.

---

### Web Browser: qutebrowser

I use [qutebrowser](https://qutebrowser.org/) as my web browser. It is
a keyboard-oriented minimal web browser using QtWebEngine (WebKit). The
only customisation I make makes it use separate windows as tabs and
makes it use `kakoune` as editor. Also, **javascript is disabled by
default**, see the keybindings to disable it per-host basis (or just
modify the configuration).

Actually, I would prefer to use Firefox with some addons & customisation
to make it keyboard-oriented & disabling tabs. However currently there
is no easy way to configure Firefox easily & install addons without using
the GUI. There are some ongoing work adding this functionality to nixpkgs,
I will consider switching when they are merged.

---

### Password Manager: pass

I use [password-store](https://www.passwordstore.org/) to manage my
passwords and OTP's, and use its git integration to sync them to a
private Git repository.

Checkout its documentation for the usage, I don't have any special
configuration for it. However, there are a few helpers:

* `super+p` keybinding open a menu with your passwords, and you can
choose to copy either the password or the OTP token (if available)
to your clipboard.
* There is a `qr2pass` script on this repo which will take a screenshot
of your screen containing a barcode for an OTP and adds it to the given
password file; so you can use it to generate OTP tokens.
* There is an additional `pass rotate` command which shows you the oldest
password you have.

---

### Other tools

I also use tons of other tools for various purposes.

Checkout [./home-modules/workstation.nix]() to see them all.

