{ pkgs }:

with import ./lib.nix { inherit pkgs; };

let
   emacsPackages = pkgs.emacsPackagesNg.override (super: self: {
     emacs = pkgs.emacs25Macport;
     
     kubernetes = self.melpaBuild {
       pname = "kubernetes";
       version = "0.0.1";
       src = pkgs.fetchFromGitHub {
         owner = "chrisbarrett";
         repo = "kubernetes-el";
         rev = "f53ce6f6ddda5efef165c2642dd13518025543c7";
         sha256 = "1ljp7yllx6g5iyj17y2dqx0k4zbfa7qy54fj1j32kz4ka9j228z4";
       };
       packageRequires = [ self.dash self.magit ];
     };

     intero = self.melpaBuild {
       pname = "intero";
       version = "0.0.1";
       src =
         let repo = pkgs.fetchFromGitHub {
           owner = "commercialhaskell";
           repo = "intero";
           rev = "04265e68647bbf27772df7b71c9927d451e6256f";
           sha256 = "0zax01dmrk1zbqw8j8css1w6qynbavfdjfgfxs34pb37gp4v8mgg";
         };
	 in pkgs.runCommand "intero-el" {} "ln -s ${repo}/elisp $out";
       packageRequires = [ self.flycheck self.company self.haskell-mode ];
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
  '';
  packages = 
    (map (i: { package = i; }) [
      "scala-mode"
      "nix-mode"
      "magit"
      "restclient"
      "go-mode"
      "apidoc-checker"
    ]) ++ [
      {
        package = "sbt-mode";
        init    = ''
          (global-set-key (kbd "C-c C-l") (lambda() (interactive) (sbt-command "compile")))
          (global-set-key (kbd "C-c C-t") (lambda() (interactive) (sbt-command "test")))
          (global-set-key (kbd "C-c C-z") (lambda() (interactive) (sbt-command "!!")))
          '';
      }
      {
        package = "ag";
	systemPackages = [ pkgs.silver-searcher ];
      }
      {
        package = "undo-tree";
        init    = "(setq undo-tree-visualizer-timestamps t)";
        config  = "(global-undo-tree-mode)";
      }
      {
        package = "monokai-theme";
        config  = "(load-theme 'monokai t)";
      }
      {
        package = "counsel";
        init    = "(ivy-mode 1)";
      }
      {
        package = "counsel-projectile";
        init    = "(counsel-projectile-on)";
        bind    = "(\"C-c p f\" . counsel-projectile-find-file)";
      }
      {
        package = "projectile";
        config  = "(projectile-mode 1)";
      }
      {
        package = "flycheck";
        config  = "(global-flycheck-mode)";
      }
      {
        package = "ace-jump-mode";
        bind    = "(\"C-c SPC\" . ace-jump-mode)";
      }
      {
        package = "ws-butler";
        config  = "(ws-butler-global-mode)";
      }
      {
        package = "yasnippet";
        init    = "(setq yas-snippet-dirs '(\"${mySnippets}\"))";
        config  = "(yas-global-mode 1)";
      }
      {
        package  = "kubernetes";
	commands = "kubernetes-overview";
      }
      {
        package = "intero";
        config  = "(add-hook 'haskell-mode-hook 'intero-mode)";
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
    ];
}
