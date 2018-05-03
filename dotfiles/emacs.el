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
(setq default-frame-alist '((font . "Source Code Pro-10")))
(setq-default mode-line-format nil)

(setq window-divider-default-places 't)
(window-divider-mode)
(setq window-divider-default-right-width 1)
(setq window-divider-default-bottom-width 1)

(require 'use-package)

(global-linum-mode)

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

(use-package doom-themes
  :config
  (load-theme 'doom-molokai t))

(use-package smooth-scrolling
  :init
  (setq smooth-scroll-margin 5)
  :config
  (smooth-scrolling-mode 1))

(use-package git-gutter-fringe
  :config
  (global-git-gutter-mode +1))

(use-package undo-tree
  :init
  (setq undo-tree-visualizer-timestamps t)
  :config
  (global-undo-tree-mode))

(use-package which-key
  :config
  (which-key-mode))

(use-package vlf)

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
  (setq company-dabbrev-downcase nil)
  (setq company-backends '(company-dabbrev))
  :config
  (global-company-mode))

(use-package dimmer
  :config
  (dimmer-mode))

(use-package magit
  :bind
  ("C-x m" . magit-status))

(use-package visual-regexp-steroids
  :bind
  ("C-c r" . vr/replace))

(use-package git-link)

(use-package scala-mode
  :mode
  ("\\.sc\\'" . scala-mode))

(use-package csv-mode
  :mode
  (("\\.csv\\'" . csv-mode)
   ("\\.tsv\\'" . csv-mode)))


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

(use-package haskell-mode)
(use-package intero
  :after (haskell-mode)
  :config
  (add-hook 'haskell-mode-hook 'intero-mode))

(use-package rg)
(use-package go-mode
  :mode ("\\.go\\'" . go-mode))
(use-package nix-mode
  :mode ("\\.nix\\'" . nix-mode))
(use-package yaml-mode
  :mode ("\\.yaml\\'" . yaml-mode))
(use-package restclient
  :mode ("\\.rest\\'" . yaml-mode))

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

(use-package dumb-jump
  :config
  (dumb-jump-mode))

;; Custom

(defun yank-to-x-clipboard ()
  (interactive)
  (if (region-active-p)
      (progn
        (shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
        (message "Yanked region to clipboard!")
        (deactivate-mark))
    (message "No region active; can't yank to clipboard!")))
