;; the package manager
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

(menu-bar-mode -1)
(winner-mode 1)
(windmove-default-keybindings)
(global-font-lock-mode 1)
(show-paren-mode 1)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(use-package ensime
  :ensure t :pin melpa-stable)

(use-package monokai-theme
  :ensure t :pin melpa-stable
  :config
  (load-theme 'monokai t))

(use-package helm
  :ensure t :pin melpa-stable
  :init
  (setq helm-display-function 'pop-to-buffer)
  :config
  (require 'helm)
  (require 'helm-config)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "C-x b") 'helm-buffers-list)
  (global-set-key (kbd "C-x C-b") 'helm-buffers-list)
  (global-set-key (kbd "C-c h") 'helm-command-prefix)
  (global-unset-key (kbd "C-x c"))
  (helm-mode 1))

(use-package helm-flx
  :ensure t :pin melpa
  :config
  (helm-flx-mode 1))

(use-package undo-tree
  :ensure t :pin melpa
  :config
  (global-undo-tree-mode))

(use-package magit
  :ensure t :pin melpa)

(use-package dashboard
  :ensure t :pin melpa
  :init
  (setq dashboard-items '((recents  . 5)
			  (projects . 5)))
  :config
  (dashboard-setup-startup-hook))

(use-package projectile
  :ensure t :pin melpa
  :config
  (projectile-mode 1))

(use-package helm-projectile
  :ensure t :pin melpa
  :config
  (helm-projectile-on))

(use-package shackle
  :ensure t :pin melpa
  :config
  (shackle-mode 1)
  (setq shackle-rules '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :ratio 0.4))))

(use-package ace-jump-mode
  :ensure t :pin melpa
  :config
  (define-key global-map (kbd "C-c SPC") 'ace-jump-mode))

(use-package rainbow-delimiters
 :ensure t :pin melpa)

(use-package intero
  :ensure t :pin melpa)
  
(use-package haskell-mode
  :ensure t :pin melpa
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
