(require 'package)
(setq
 package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                    ("org" . "http://orgmode.org/elpa/")
                    ("melpa" . "http://melpa.org/packages/")
                    ("melpa-stable" . "http://stable.melpa.org/packages/"))
 package-archive-priorities '(("melpa-stable" . 1)))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'exec-path "/usr/local/bin")

(setq
 inhibit-startup-screen t)

(setq-default indent-tabs-mode nil)

(tool-bar-mode -1)
(menu-bar-mode -1)
(winner-mode 1)
(windmove-default-keybindings)
(global-font-lock-mode 1)
(show-paren-mode 1)
(scroll-bar-mode -1)

(setq js-indent-level 2)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package sbt-mode
  :ensure t)

(use-package scala-mode
  :ensure t
  :init
  (global-set-key (kbd "C-c C-l") (lambda() (interactive) (sbt-command "compile")))
  (global-set-key (kbd "C-c C-t") (lambda() (interactive) (sbt-command "test")))
  (global-set-key (kbd "C-c C-s") (lambda() (interactive)))
  )

(use-package monokai-theme
  :ensure t
  :config
  (load-theme 'monokai t))

(use-package counsel
  :ensure t
  :init
  (ivy-mode 1))

(use-package counsel-projectile
  :ensure t
  :init
  (counsel-projectile-on))

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode))

(use-package magit
  :ensure t)

(use-package magithub
  :ensure t
  :after magit
  :config (magithub-feature-autoinject t))

(use-package projectile
  :ensure t
  :config
  (projectile-mode 1))

(use-package ace-jump-mode
  :ensure t
  :config
  (define-key global-map (kbd "C-c SPC") 'ace-jump-mode))

(use-package rainbow-delimiters
  :ensure t)

(use-package intero
  :ensure t)
  
(use-package haskell-mode
  :ensure t
  :config
  (add-hook 'haskell-mode-hook 'intero-mode))

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

(use-package focus
  :ensure t)

(use-package browse-kill-ring
  :ensure t
  :config
  (require 'browse-kill-ring))

(use-package google-this
  :ensure t
  :config
  (google-this-mode 1))

(use-package flycheck-flow
  :ensure t)

; (use-package company-flow
;   :ensure t
;   :init
;   (eval-after-load 'company
;     (add-to-list 'company-backends 'company-flow)))

(use-package restclient
  :ensure t)

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package coffee-mode
  :ensure t)

(use-package ag
  :ensure t)

(use-package ranger
  :ensure t)

(use-package apidoc-checker
  :ensure t)
