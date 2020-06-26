{ config, pkgs, ... }:

let
myEmacs = pkgs.emacsWithPackagesFromUsePackage {
  config = builtins.readFile ../dotfiles/emacs.el;
};
in
{
  config = {
    home.packages = with pkgs; [ myEmacs ];
    home.file.".emacs.el".source = ../dotfiles/emacs.el;
  };
}
