{ config, pkgs, ... }:

let
  extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
    name = "remote-ssh-edit";
    publisher = "ms-vscode-remote";
    version = "0.47.2";
    sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
  }];

  wrappedCodium = pkgs.runCommand "vscodium-wrapped" {} ''
    mkdir -p $out/bin
    ln -s ${pkgs.vscodium}/bin/codium $out/bin/code
  '';

  vscode = pkgs.vscode-utils.vscodeWithConfiguration {
    vscode = wrappedCodium;
    nixExtensions = [
      { publisher = "justusadam"; name = "language-haskell";
        version = "3.3.0";
        sha256 = "sha256-2rlomc4qjca1Mv5lxgT/4AARzuG8e4kgshielpBeBYk="; }
      { publisher = "haskell"; name = "haskell";
        version = "1.1.0";
        sha256 = "sha256-6wFa+LBJw0haIkT0g/lDP32wz9MHgPhMk8liMD014PE="; }
      { publisher = "arrterian"; name = "nix-env-selector";
        version = "0.1.2";
        sha256 = "sha256-aTNxr1saUaN9I82UYCDsQvH9UBWjue/BSnUmMQOnsdg="; }
    ];
  };
in {
  config = {
    home.packages = [
      vscode
    ];
    #  files.".config/Code/User/settings.json".text = ''

    #  '';
  };
}
