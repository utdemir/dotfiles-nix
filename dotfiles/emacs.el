(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(winner-mode 1)
(windmove-default-keybindings)
(global-font-lock-mode 1)
(show-paren-mode 1)
(scroll-bar-mode -1)
(setq column-number-mode t)
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq js-indent-level 2)
(setq make-backup-files nil)
(setq create-lockfiles nil)
(setq custom-safe-themes t)

(set-face-attribute 'default nil :font "Source Code Pro-10" )

(require 'use-package)

(use-package doom-themes
  :config
  (load-theme 'doom-molokai t))

(use-package git-gutter
  :config
  (global-git-gutter-mode +1))

(use-package rich-minority
  :init
  (setq rm-whitelist '("nothing"))
  :config
  (rich-minority-mode 1))

(use-package smart-mode-line
  :config
  (sml/setup))

(use-package undo-tree
  :init
  (setq undo-tree-visualizer-timestamps t)
  :config
  (global-undo-tree-mode))

(use-package ivy
  :demand
  :config
  (ivy-mode 1)
  :bind
  ("M-x" . counsel-M-x))

(use-package projectile
  :config
  (projectile-mode 1))

(use-package counsel-projectile
  :after (projectile ivy)
  :config
  (counsel-projectile-mode)
  :bind
  ("C-c p f" . counsel-projectile-find-file))

(use-package ws-butler
  :config
  (ws-butler-global-mode))

(use-package highlight-symbol
  :config
  (highlight-symbol-mode))

(use-package multiple-cursors
  :bind
  ("C-<" . mc/unmark-next-like-this)
  ("C->" . mc/mark-next-like-this))

(use-package company
  :init
  (setq company-dabbrev-ignore-case nil)
  (setq company-dabbrev-downcase nil))
  (setq company-backends '(company-dabbrev))
  :config
  (global-company-mode))

(use-package magit
  :bind
  ("C-c m" . magit-status))

(use-package scala-mode
  :mode
  ("\\.sc\\'" . scala-mode))

(use-package sbt-mode
  :after (scala-mode)
  :config
  (require 'dash)
  (defun rk-set-sbt-root ()
    "Sets sbt root for the given project."
    (interactive)
    (-when-let* ((root (locate-dominating-file (buffer-file-name) "build.sbt"))
                 (sbt-root (and root
                                (sbt:find-root-impl "build.sbt" root))))
      (setq-local sbt:buffer-project-root sbt-root)))
  (defun my-sbt-compile () (interactive) (sbt-command "compile"))
  (defun my-sbt-test () (interactive) (sbt-command "test"))
  (add-hook 'scala-mode-hook
            '(lambda ()
               (rk-set-sbt-root)
               (local-set-key (kbd "C-c C-l") 'my-sbt-compile)
               (local-set-key (kbd "C-c C-t") 'my-sbt-test)
               (local-set-key (kbd "C-c C-e") 'sbt-run-previous-command)
               ))
  )

(use-package haskell-mode
  :init
  (setq haskell-process-wrapper-function
        (lambda (argv) (
                        append (list "nix-shell" "-I" "." "--command")
                               (list (mapconcat 'identity argv " "))
                               )))
  ; workaround: https://github.com/haskell/haskell-mode/issues/1553
  (setq haskell-process-type 'cabal-repl)
  (setq haskell-process-args-ghci
        '("-ferror-spans" "-fshow-loaded-modules"))
  (setq haskell-process-args-cabal-repl
        '("--ghc-option=-ferror-spans" "--ghc-option=-fshow-loaded-modules"))
  :config
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode))

(use-package hindent
  :after (haskell-mode)
  :config
  (add-hook 'haskell-mode-hook #'hindent-mode))

(use-package go-mode)

(use-package org-present
  :no-require t
  :config
  (add-hook 'org-present-mode-hook
            (lambda ()
              (org-present-big)
              (org-display-inline-images)
              (org-present-hide-cursor)
              (org-present-read-only)
              (setq mode-line-format nil)
              (setq 'truncate-lines t)
              (setq 'word-wrap t)))
  (add-hook 'org-present-mode-quit-hook
            (lambda ()
              (org-present-small)
              (org-remove-inline-images)
              (org-present-show-cursor)
              (org-present-read-write))))

(use-package yasnippet
  :init
  (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
  (setq yas-indent-line nil)
  :config
  (yas-global-mode 1))

;; Custom

(defun yank-to-x-clipboard ()
  (interactive)
  (if (region-active-p)
      (progn
        (shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
        (message "Yanked region to clipboard!")
        (deactivate-mark))
    (message "No region active; can't yank to clipboard!")))
