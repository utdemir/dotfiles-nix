(setq gc-cons-threshold (* 50 1000 1000))

(require 'use-package)

;; LOOKS

(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(global-font-lock-mode 1)
(show-paren-mode 1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode t)

(use-package color-theme-sanityinc-tomorrow
  :init
  (color-theme-sanityinc-tomorrow-eighties))

(use-package git-gutter-fringe
  :defer 2
  :config
  (global-git-gutter-mode))

(use-package which-key
  :defer 2
  :config
  (which-key-mode))

(use-package feebleline
  :init
  (defvar ad-do-it)
  :config
  (feebleline-mode 1)
  ;; Add horizontal seperators below windows
  ;; don't know how this works, see https://github.com/tautologyclub/feebleline/issues/24
  (add-hook 'window-configuration-change-hook
    (lambda ()
      (when (and (bound-and-true-p feebleline-mode) (not (display-graphic-p)))
        (walk-windows (lambda (window) ; reset the mode line of each buffer
                        (with-current-buffer (window-buffer window)
                          (setq mode-line-format nil)))
                      0) ; don't include minibuffer
        (walk-windows (lambda (window) ; and set the mode line when necessary
                        (with-current-buffer (window-buffer window)
                          ;; {frame,window}-edges functions return (x1 y1 x2 y2)
                          ;; then check if the current buffer (which may be displayed on mutltiple windows)
                          ;; doesn't sit on top of the minibuffer
                          ;; this isn't perfect but unfortunately, the mode-line-format is buffer-local
                          (when (/= (nth 1 (window-edges (minibuffer-window)))
                                    (nth 3 (window-edges window)))
                            (setq mode-line-format "%-"))))
                      0)))) ; don't include minibuffer
  )

;; EDITING

(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq js-indent-level 2)
(setq make-backup-files nil)
(setq create-lockfiles nil)
(setq custom-safe-themes t)
(setq default-frame-alist '((font . "Source Code Pro-10")))

(winner-mode 1)
(windmove-default-keybindings)

(use-package exec-path-from-shell
  :defer 1
  :config
  (exec-path-from-shell-initialize))

(use-package smooth-scrolling
  :init
  (setq smooth-scroll-margin 5)
  :config
  (smooth-scrolling-mode 1))

(use-package undo-tree
  :defer 2
  :init
  (setq undo-tree-visualizer-timestamps t)
  :config
  (global-undo-tree-mode))

(use-package vlf
  :defer 2)

(use-package ivy
  :demand
  :config
  (ivy-mode 1)
  :bind
  ("M-x" . counsel-M-x))

(use-package counsel-projectile
  :config
  (counsel-projectile-mode)
  (defun ud-refresh-projectile-projects ()
    (when (require 'magit nil t)
      (projectile-cleanup-known-projects)
      (mapc #'projectile-add-known-project
        (mapcar #'file-name-as-directory (magit-list-repos)))))
  (advice-add #'counsel-projectile-switch-project :before #'ud-refresh-projectile-projects))

(use-package ws-butler
  :config
  (ws-butler-global-mode))

(use-package highlight-symbol
  :init
  (setq highlight-symbol-idle-delay 0.5)
  :config
  (highlight-symbol-mode))

(use-package company
  :defer 2
  :init
  (setq company-dabbrev-ignore-case nil)
  (setq company-dabbrev-downcase nil)
  (setq company-backends '(company-dabbrev))
  :config
  (global-company-mode))

(use-package dimmer
  :defer 1
  :config
  (dimmer-mode))

(use-package magit
  :init
  (setq magit-repository-directories
          '(("~/workspace/" . 2)))
  :bind
  ("C-x m" . magit-status))

(use-package visual-regexp-steroids
  :defer 2
  :bind
  ("C-c r" . vr/replace))

(use-package git-link
  :defer 2)

;; INTEGRATIONS

; This package is not actually disabled, this is just to
; introduce a dependency to the package while not loading
; it via use-package.
(use-package emacs-libvterm
  :disabled)

;; LANGUAGES

(use-package direnv
  :config
  (direnv-mode))

(use-package lsp-mode
  :commands lsp
  :config
  (setq lsp-enable-snippet 'f)
  :hook
  (sh-mode . lsp)
  (rust-mode . lsp))

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

(use-package haskell-mode
  :init
  (setq haskell-process-type 'cabal-new-repl)
  (setq haskell-process-args-ghci
        '("-ferror-spans" "-fshow-loaded-modules"))
  (setq haskell-process-args-cabal-repl
        '("--ghc-option=-ferror-spans" "--ghc-option=-fshow-loaded-modules"))
  :config
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode))

(use-package git-auto-commit-mode
  :init
  (setq gac-automatically-push-p 't))

(use-package rg)
(use-package go-mode
  :mode ("\\.go\\'" . go-mode))
(use-package nix-mode
  :mode ("\\.nix\\'" . nix-mode))
(use-package rust-mode
  :mode ("\\.rs\\'" . rust-mode))
(use-package yaml-mode
  :mode ("\\.yaml\\'" . yaml-mode))
(use-package restclient
  :mode ("\\.rest\\'" . restclient-mode))
(use-package agda2-mode
  :mode ("\\.agda\\'" . agda2-mode)
        ("\\.lagda\\'" . agda2-mode))

(use-package dumb-jump
  :defer 2
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

;; Use a hook so the message doesn't get clobbered by other messages.
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

(setq gc-cons-threshold (* 2 1000 1000))
