#!/usr/bin/env sh

set -ex

ln -sf $PWD/emacs.el  $HOME/.emacs.el
ln -sf $PWD/gitconfig $HOME/.gitconfig
ln -sf $PWD/Brewfile  $HOME/.Brewfile

mkdir -p $HOME/.emacs.d
touch $HOME/.emacs.d/custom.el

brew bundle --global
