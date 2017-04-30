{ pkgs }:

with import ./lib/emacs.nix { inherit pkgs; };

let
   emacsPackages = pkgs.emacsPackagesNg.override (super: self: {
     emacs = pkgs.emacs25Macport;

     dante = self.melpaBuild {
       pname = "dante";
       version = "0.0.1";
       src = pkgs.fetchFromGitHub {
         owner = "jyp";
         repo = "dante";
         rev = "03afbbd5029339c6a4fa3fe4ff79b4818f062295";
         sha256 = "03x8p8rjfipgxgy6mjg6r2ss4x565m2d0cai7i6ghk7mf8i7ipl4";
       };
       packageRequires = [ self.flycheck ];
     };
     
     kubernetes = self.melpaBuild {
       pname = "kubernetes";
       version = "0.0.1";
       src = pkgs.fetchFromGitHub {
         owner = "chrisbarrett";
         repo = "kubernetes-el";
         rev = "68dd3c2184e72b7a669e5706d1a3d95a220276d1";
         sha256 = "163kx407jj08ifbpvvw1cp24qb4rm6l89ikgzqha01lc0bjglax5";
       };
       packageRequires = [ self.dash self.magit ];
     };

     apidoc-checker = self.melpaBuild {
       pname = "apidoc-checker";
       version = "0.0.1";
       src = pkgs.runCommand "apidoc-checker-el" {} "ln -s ${apidoc-checker-src}/elisp $out";
       packageRequires = [ self.flycheck self.js2-mode ];
     };
   });

   apidoc-checker-src = pkgs.fetchFromGitHub {
     owner = "chrisbarrett";
     repo = "apidoc-checker";
     rev = "3d4325964c40301f7ba6e032aca44034a01afe75";
     sha256 = "0i96xcvi2qpxqff03w9z90x6c848sq9ahg0naa4l9d9wm01f0yd7";
   };

   apidoc-checker-hs = pkgs.haskellPackages.haskellSrc2nix {
     name = "apidoc-checker";
     src = apidoc-checker-src;
   };

   mySnippets = mkYaSnippetsDir {
     haskell-mode = {
       fun = ''
         ''\${1:function-name} :: ''\${2:type}
         $1 = $0error "Not implemented: $1"
         '';
     };
   };
in mkEmacs emacsPackages {
  config = ''
    (setq inhibit-startup-screen t)
    (tool-bar-mode -1)
    (menu-bar-mode -1)
    (winner-mode 1)
    (windmove-default-keybindings)
    (global-font-lock-mode 1)
    (show-paren-mode 1)
    (scroll-bar-mode -1)
    (diminish 'auto-revert-mode)
    (setq column-number-mode t)
    (setq-default indent-tabs-mode nil)
    (setq tab-width 2)
  '';
  packages = 
    (map (i: { package = i; }) [
      "nix-mode"
    ]) ++ [
      {
        package = "scala-mode";
        modes = {
          ${ext "scala"} = "scala-mode";
          ${ext "sbt"}   = "sbt-mode";
        };
      }
      {
        package = "sbt-mode";
        init = ''
          (defun sbt-compile ()
            "runs 'sbt-command compile'" (interactive)
            (sbt-command "compile"))
          (defun sbt-test ()
            "runs 'sbt-command test'" (interactive)
            (sbt-command "test"))
          '';
        binds = {
          "C-c C-l" = "sbt-compile";
          "C-c C-t" = "sbt-test";
        };
      }
      {
        package = "rg";
        systemPackages = [ pkgs.ripgrep ];
        commands = [ "rg" "rg-project" "rg-dwim" ];
      }
      {
        package  = "undo-tree";
        init     = "(setq undo-tree-visualizer-timestamps t)";
        config   = "(global-undo-tree-mode)";
        diminish = "'undo-tree-mode";
      }
      {
        package = "monokai-theme";
        config  = "(load-theme 'monokai t)";
      }
      {
        package  = "counsel";
        init     = "(ivy-mode 1)";
        diminish = "'ivy-mode";
      }
      {
        package = "counsel-projectile";
        init    = "(counsel-projectile-on)";
        binds   = {
          "C-c p f" = "counsel-projectile-find-file";
        };
      }
      {
        package = "projectile";
        config  = "(projectile-mode 1)";
      }
      {
        package  = "flycheck";
        config   = "(global-flycheck-mode)";
        diminish = "'flycheck-mode";
      }
      {
        package = "ace-jump-mode";
        binds   = {
          "C-c SPC" = "ace-jump-mode";
        };
      }
      {
        package  = "ws-butler";
        config   = "(ws-butler-global-mode)";
        diminish = "'ws-butler-mode";
      }
      {
        package  = "yasnippet";
        init     = "(setq yas-snippet-dirs '(\"${mySnippets}\"))";
        config   = "(yas-global-mode 1)";
        diminish = "'yas-minor-mode";
      }
      {
        package  = "kubernetes";
        commands = [ "kubernetes-overview" ];
      }
      {
        package = "haskell-mode";
        modes   = {
          ${ext ".hs"} = "haskell-mode";
          ${ext ".lhs"} = "haskell-mode";
          ${ext ".hsc"} = "haskell-mode";
          ${ext ".cabal"} = "haskell-cabal-mode";
        };
#        config = ''
#          (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
#
#          (setq haskell-process-wrapper-function
#            (lambda (argv) (
#              append (list "nix-shell" "-I" "." "--command")
#                     (list (mapconcat 'identity argv " "))
#            ))
#          )
#          (setq haskell-process-type 'ghci)
#        '';
      }
      {
        package = "dante";
        config  = ''
          (add-hook 'haskell-mode-hook 'dante-mode)
          (add-hook 'haskell-mode-hook 'flycheck-mode)
        '';
      }
      {
        package = "perspective";
        config  = ''
          (persp-mode 1)
          (persp-mode-set-prefix-key (kbd "C-x C-x"))
        '';
      }
      {
        package        = "apidoc-checker";
        systemPackages = [ apidoc-checker-hs ];
      }
      {
        package  = "magit";
        commands = [ "magit-status" ];
      }
      {
        package = "restclient";
        modes   = {
          ${ext ".rest"} = "restclient-mode";
        };
      }
      {
        package = "go-mode";
        modes   = {
          ${ext ".go"} = "go-mode";
        };
      }
      {
        package = "js2-mode";
        modes = {
          ${ext ".js"} = "js2-mode";
          ${ext ".json"} = "js2-mode";
        };
        init = ''(setq js2-basic-offset 2)'';
      }
      {
        package = "simpleclip";
        config  = "(simpleclip-mode 1)";
      }
      {
        package = "markdown-mode";
        modes = {
          "README.md" = "gfm-mode";
          ${ext ".md"} = "markdown-mode";
          ${ext ".markdown"} = "markdown-mode";
        };
	init = "(setq markdown-command \"multimarkdown\")";
	systemPackages = [ pkgs.multimarkdown ];
      }
      {
        package  = "yaml-mode";
        modes = {
          ${ext ".yaml"} = "yaml-mode";
          ${ext ".yml"} = "yaml-mode";
        };
      }
      {
        package = "graphviz-dot-mode";
        modes = {
          ${ext ".dot"} = "graphviz-dot-mode";
        };
      }
    ];
}
