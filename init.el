;;; init.el --- Emacs initialization file

;;; Commentary:
;; This is the main Emacs initialization file.
;; Contains configurations for package management, macOS specific settings,
;; and general Emacs settings for enhanced functionality and user experience.

;;; Code:

;; Initialize package sources
(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("org" . "https://orgmode.org/elpa/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package if not installed
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; Setup quelpa for advanced package management
(unless (package-installed-p 'quelpa)
  (package-refresh-contents)
  (package-install 'quelpa))
(require 'quelpa)
(unless (package-installed-p 'quelpa-use-package)
  (quelpa
    '(quelpa-use-package
      :fetcher git
      :url "https://github.com/quelpa/quelpa-use-package.git")))
(require 'quelpa-use-package)

;; macOS specific settings
(setq mac-command-modifier 'meta)  ;; Assign Command key to Meta
(setq mac-option-modifier 'none)   ;; Set Option key to normal key
(setq select-enable-clipboard t)   ;; Share clipboard between Emacs and macOS
(setq select-enable-primary t)     ;; Enable primary selection

;; exec-path-from-shell configuration
(use-package exec-path-from-shell
  :ensure t
  :init
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-env "PATH")
    (exec-path-from-shell-copy-env "MANPATH")
    (exec-path-from-shell-copy-env "SHELL")))

;; Package configurations
(use-package async :ensure t)
(use-package auctex :ensure t)
(use-package auto-complete
  :ensure t
  :config
  (ac-config-default)
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete))
(use-package bind-key :ensure t)
(use-package dash :ensure t)
(use-package diminish :ensure t)
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))
(use-package flycheck-pos-tip
  :ensure t
  :after flycheck
  :config (flycheck-pos-tip-mode))
(use-package ggtags :ensure t)
(use-package htmlize :ensure t)
(use-package js2-mode :ensure t)
(use-package julia-mode :ensure t)
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch))
  :config
  (setq magit-diff-refine-hunk 'all)  ;; Visually highlight refined changes
  (setq magit-log-arguments '("--graph" "--decorate" "--color"))) ;; Log options

(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))
(use-package projectile
  :ensure t
  :diminish projectile-mode
  :config (projectile-mode +1))
(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :config (smartparens-global-mode t))
(use-package smex :ensure t)
(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :config (yas-global-mode 1))
(use-package visual-regexp
  :ensure t
  :bind (("C-c r" . vr/replace)
         ("C-c q" . vr/query-replace)))

;; diff-hl for highlighting changes
(use-package diff-hl
  :ensure t
  :hook ((prog-mode . diff-hl-mode)
         (dired-mode . diff-hl-dired-mode)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (diff-hl-flydiff-mode))

(use-package ivy
  :ensure t
  :diminish (ivy-mode)
  :bind (("C-s" . swiper)  ; Forward search using Swiper
         ("C-r" . swiper)  ; Backward search using Swiper
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))
(use-package swiper
  :ensure t
  :after ivy
  :bind (:map swiper-map
	      ("C-r" . ivy-previous-line-or-history)))
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode))

;; General Emacs configurations
(setq inhibit-startup-screen t)            ;; Disable startup screen
(menu-bar-mode -1)                         ;; Disable menu bar
(tool-bar-mode -1)                         ;; Disable tool bar
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))                    ;; Disable scroll bar if available
(column-number-mode t)                     ;; Show column number
(line-number-mode t)                       ;; Show line number
(size-indication-mode t)                   ;; Show buffer size
(global-set-key (kbd "C-x C-b") 'ibuffer)  ;; Use ibuffer by default
(global-set-key (kbd "M-/") 'hippie-expand) ;; Improve autocomplete experience

;; Custom mode-line format
(setq-default mode-line-format
              '("%e"
                mode-line-front-space
                mode-line-mule-info
                mode-line-client
                mode-line-modified
                mode-line-remote
                mode-line-frame-identification
                mode-line-buffer-identification
                " "
                mode-line-position
                (vc-mode vc-mode)
                " "
                mode-line-modes
                mode-line-misc-info))

;; Disable time display
(display-time-mode -1)

;; Specific macOS key settings
(when (eq system-type 'darwin)
  (setq mac-option-key-is-meta t)
  (setq mac-command-key-is-meta nil)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super)
  (setq mac-control-modifier 'control)
  (setq mac-pass-control-to-system nil)
  (setq mac-pass-command-to-system nil)
  (setq mac-pass-option-to-system nil))

;; Enable visual line mode globally
(global-visual-line-mode t)

;; Remove trailing whitespace before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Disable VC (Version Control) backend to prioritize Magit
(setq vc-handled-backends nil)

;; Enable debug on error to trace detailed error messages
(setq debug-on-error t)

;; Set the frame's background mode to dark globally
(setq frame-background-mode 'dark)

;; Add the emacs-color-theme-solarized directory to the custom theme load path
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/emacs-color-theme-solarized")

;; Load Solarized theme
(load-theme 'solarized t)

;;; init.el ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("833ddce3314a4e28411edf3c6efde468f6f2616fc31e17a62587d6a9255f4633" "fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c" "5dbdb4a71a0e834318ae868143bb4329be492dd04bdf8b398fb103ba1b8c681a" default))
 '(package-selected-packages
   '(solarized-theme taxy-magit-section org-starter swiper ivy yasnippet which-key visual-regexp smex smartparens quelpa-use-package projectile multiple-cursors magit julia-mode js2-mode htmlize ggtags flycheck-pos-tip exec-path-from-shell diminish auto-complete auctex async)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
