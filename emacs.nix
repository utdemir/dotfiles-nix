{ pkgs }:

with import ./lib/emacs.nix { inherit pkgs; };

let
   emacsPackages = pkgs.emacsPackagesNg.overrideScope (super: self: {
     emacs = pkgs.emacs25Macport;

     kubernetes = self.melpaBuild {
       pname = "kubernetes";
       version = "0.0.1";
       src = pkgs.fetchFromGitHub {
         owner = "chrisbarrett";
         repo = "kubernetes-el";
         rev = "c0e581dc7977f8d7482307cfd9884faabfb1bddb";
         sha256 = "0f7b3lxrj1wn0w0xhsvxq0cg4pl26npir572nj21kpg5367rv0v7";
       };
       packageRequires = [ self.dash self.magit ];
     };

     apidoc-checker = self.melpaBuild {
       pname = "apidoc-checker";
       version = "0.0.1";
       src = pkgs.runCommand "apidoc-checker-el" {} "ln -s ${apidoc-checker-src}/elisp $out";
       packageRequires = [ self.flycheck self.js2-mode ];
     };

     goflymake = self.melpaBuild {
       pname = "goflymake";
       version = "0.0.1";
       src = goflymake-src;
       packageRequires = [ self.flycheck ];
     };

     company-go = self.melpaBuild {
       pname = "company-go";
       version = "0.0.1";
       src = pkgs.runCommand "gocode-src-emacs" {} ''
         ln -s ${gocode-src}/emacs-company $out
       '';
       packageRequires = [ self.company ];
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

   goflymake-src = pkgs.fetchFromGitHub {
     owner = "dougm"; repo = "goflymake";
     rev = "3b9634ef394a5ec125c6847195b1101ec1f47708";
     sha256 = "0fy6frljzwz4y07yk602jiyk0xp83snwdsjmhk7y8akrv18vd9r3";
   };

   goflymake-bin = pkgs.buildGoPackage rec {
     name = "goflymake-${version}";
     version = "2014-07-31";
     src = goflymake-src;
     goPackagePath = "github.com/dougm/goflymake";
   };

   gocode-src = pkgs.fetchFromGitHub {
     owner = "nsf"; repo = "gocode";
     rev = "v.20150303";
     sha256 = "03snnra31b5j6iy94gql240vhkynbjql9b4b5j8bsqp9inmbsia3";
   };

   gocode-bin = pkgs.buildGoPackage rec {
     name = "gocode";
     version = "0.0.1-dev";
     src = gocode-src;
     goPackagePath = "github.com/nsf/gocode";
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
        config = ''
          (add-hook 'haskell-mode-hook 'interactive-haskell-mode)

          (setq haskell-process-wrapper-function
            (lambda (argv) (
              append (list "nix-shell" "-I" "." "--command")
                     (list (mapconcat 'identity argv " "))
            ))
          )
          (setq haskell-process-type 'ghci)
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
      {
        package = "protobuf-mode";
        modes = {
          ${ext ".proto"} = "protobuf-mode";
        };
      }
      {
        package = "nix-mode";
        modes = {
          ${ext ".nix"} = "nix-mode";
        };
      }
      {
        package = "goflymake";
        init = ''
          (require 'go-flycheck)
        '';
        systemPackages = [
          goflymake-bin
        ];
      }
      {
        package = "hindent";
        config = ''
          (add-hook 'haskell-mode-hook #'hindent-mode)
        '';
      }
        package = "git-gutter";
        init = "(global-git-gutter-mode +1)";
      }
      {
        package = "go-mode";
        modes   = {
          ${ext ".go"} = "go-mode";
        };
        init = ''
          (add-hook 'before-save-hook 'gofmt-before-save)
        '';
      }
      {
        package = "company";
        init = ''
          (global-company-mode)
        '';
      }
      {
        package = "company-go";
        systemPackages = [
          gocode-bin
        ];
      }
      {
        package = "highlight-symbol";
        config = "(highlight-symbol-mode)";
      }
    ];
}
