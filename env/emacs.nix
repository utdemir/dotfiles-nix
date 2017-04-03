{ pkgs 
}:

let configuration = [
      {
        package = [  ];
        pre = "";
        post = "";
      }
    ];

    emacsPackages = pkgs.emacsPackagesNg.override (super: self: {
      emacs = pkgs.emacs25Macport;
    });

    emacs = emacsPackages.emacsWithPackages (epkgs: with epkgs; [
      nix-mode
    ]);
in  emacs
