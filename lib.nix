{ pkgs }:

{
  mkDotfiles = files:
    pkgs.writeScriptBin "dotfiles" ''
      function trace() {
        echo "! $@"; $@
      }

      set -o errexit
      set -o nounset

      ${ pkgs.lib.concatMapStringsSep "\n" ({path, target}: ''
           mkdir -p "$HOME/$(dirname ${path})";
    	 trace ln -sfn "${target}" "$HOME/${path}"
           '')
         files }
    '';

  mkEmacs = epkgs: conf:
    let emacs = epkgs.emacsWithPackages (epkgs:
          [ epkgs.use-package ] ++
            builtins.map (i: builtins.getAttr i.package epkgs) conf.packages
        );

        configuration = pkgs.writeText "emacs-el" ''
          (setq user-init-file (or load-file-name (buffer-file-name)))
          (setq user-emacs-directory (file-name-directory user-init-file))

          (package-initialize)

          (require 'use-package)

          ${conf.config}
          ${pkgs.lib.concatMapStringsSep "\n" renderItem conf.packages}
        '';

        # not for performance, mostly because i want to get
        # compile time errors on invalid syntax.
        compiledConfiguration = pkgs.runCommand "emacs-elc" {} ''
          cp ${configuration} emacs.el
          ${emacs}/bin/emacs -Q --batch -f batch-byte-compile emacs.el
          cp emacs.elc $out
        '';
        renderItem =
          { package
          , config   ? ""
          , init     ? ""
          , bind     ? ""
          , commands ? ""
          }: ''
          (use-package ${package}
            ${pkgs.lib.optionalString (init != "") ":init\n${init}"}
            ${pkgs.lib.optionalString (config != "") ":config\n${config}"}
            ${pkgs.lib.optionalString (bind != "") ":bind\n${bind}"}
            ${pkgs.lib.optionalString (commands != "") ":commands\n${commands}"}
          )
          '';
    in  pkgs.stdenv.lib.overrideDerivation emacs (super: {
          installPhase = super.installPhase + ''
            wrapProgram $out/bin/emacs \
              --add-flags "-q --load ${compiledConfiguration}"
          '';
        });

   mkYaSnippetsDir = snippets:
     let mapped = pkgs.lib.mapAttrsToList (mode: pkgs.lib.mapAttrsToList (name: snippet:
         let file = pkgs.writeText "snippet-${name}" ''
             # -*- mode: snippet -*-
             # name: ${name}
             # key: ${name}
             # --
             ${snippet}
             '';
         in  "mkdir -p $out/${mode}/; ln -s ${file} $out/${mode}/${name};"
       )) snippets;
     in pkgs.runCommand "snippets" {} (
          pkgs.lib.concatStringsSep "\n" (pkgs.lib.concatLists mapped)
        );
}
