{ config, pkgs, ... }:

{
  options = with pkgs.lib; {
    dotfiles.vscode.enabled = mkEnableOption "vscode";
  };
  config = {
    programs.vscode = {
      enable = true;
      userSettings = {
        "window.zoomLevel" = -3;
        "window.menuBarVisibility" = "hidden";
        "haskell.plugin.hlint.codeActionsOn" = false;
        "haskell.plugin.hlint.diagnosticsOn" = false;
      };
      extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
         # haskell
         { publisher = "justusadam"; name = "language-haskell";
           version = "3.3.0";
           sha256 = "1285bs89d7hqn8h8jyxww7712070zw2ccrgy6aswd39arscniffs"; }
         { publisher = "haskell"; name = "haskell";
           version = "1.7.1";
           sha256 = "11myrk3hcc2hdw2n07w092s78aa6igpm7rgvn7ac9rbkkvc66rsi"; }

         # nix
         { publisher = "arrterian"; name = "nix-env-selector";
           version = "1.0.7";
           sha256 = "0mralimyzhyp4x9q98x3ck64ifbjqdp8cxcami7clvdvkmf8hxhf"; }
         { publisher = "jnoortheen"; name = "nix-ide";
           version = "0.1.16";
           sha256 = "04ky1mzyjjr1mrwv3sxz4mgjcq5ylh6n01lvhb19h3fmwafkdxbp"; }

         # lisp
         { publisher = "jeandeaual"; name = "scheme";
           version = "0.1.0";
           sha256 = "1sd7vy9qi65lz2lar5qsliqq70j3n6vhaj3bfwhjs5hf748dddnh"; }

         # ui
         { publisher = "vincaslt"; name = "highlight-matching-tag";
           version = "0.10.0";
           sha256 = "1albwz3lc9i20if77inm1ipwws8apigvx24rbag3d1h3p4vwda49"; }
         { publisher = "2gua"; name = "rainbow-brackets";
           version = "0.0.6";
           sha256 = "1m5c7jjxphawh7dmbzmrwf60dz4swn8c31svbzb5nhaazqbnyl2d"; }

         # remote
         { publisher = "ms-vscode-remote"; name = "remote-ssh";
           version = "0.65.8";
           sha256 = "0csi4mj2j00irjaw6vjmyadfbpmxxcx73idlhab6d9y0042mpr0g"; }
         { publisher = "ms-vscode-remote"; name = "remote-ssh-edit";
           version = "0.65.8";
           sha256 = "07w085crhvp8wh3n1gyfhfailfq940rffpahsp5pv8j200v2s0js"; }

         # terraform
         { publisher = "hashicorp"; name = "terraform";
           version = "2.15.0";
           sha256 = "0bqf9ry0idqw61714dc6y1rh5js35mi14q19yqhiwayyfakwraq9"; }

       ];
    };
  };
}
