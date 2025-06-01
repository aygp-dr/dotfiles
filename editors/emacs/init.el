;; AYGP Emacs Configuration
;; FreeBSD-optimized for Lisp development

;; Setup package management
(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")
        ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Ensure use-package is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; System detection
(defconst *is-freebsd* (eq system-type 'berkeley-unix))
(defconst *is-linux* (eq system-type 'gnu/linux))
(defconst *is-macos* (eq system-type 'darwin))

;; Load custom configuration files from .emacs.d/lisp
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; ===== Core UI Settings =====
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(setq inhibit-startup-screen t)
(setq ring-bell-function 'ignore)
(column-number-mode t)
(global-display-line-numbers-mode t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

;; Theme
(use-package doom-themes
  :config
  (load-theme 'doom-nord t))

;; Modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; ===== Lisp Development =====
;; SLIME for Common Lisp
(use-package slime
  :config
  (setq inferior-lisp-program "sbcl")
  (slime-setup '(slime-fancy slime-company)))

;; Paredit for balanced parentheses
(use-package paredit
  :hook ((emacs-lisp-mode lisp-mode clojure-mode scheme-mode) . paredit-mode))

;; Rainbow delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Clojure support
(use-package clojure-mode)
(use-package cider)

;; Scheme support
(use-package geiser)

;; ===== Org-mode =====
(use-package org
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :config
  (setq org-directory "~/.anthropic/journal")
  (setq org-default-notes-file (concat org-directory "/notes.org"))
  (setq org-agenda-files (list org-directory))
  (setq org-log-done 'time)
  (setq org-src-fontify-natively t)
  (setq org-src-tab-acts-natively t))

;; Org-bullets for prettier headings
(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

;; ===== Version Control =====
(use-package magit
  :bind ("C-x g" . magit-status))

;; ===== Completion =====
(use-package company
  :hook (prog-mode . company-mode)
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 2))

;; ===== Project Navigation =====
(use-package projectile
  :config
  (projectile-mode +1)
  :bind-keymap ("C-c p" . projectile-command-map))

;; ===== Search =====
(use-package swiper
  :bind ("C-s" . swiper))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)))

;; ===== AYGP Specific Functions =====
;; Load custom modules
(when (file-exists-p (expand-file-name "lisp/aygp-journal.el" user-emacs-directory))
  (load-file (expand-file-name "lisp/aygp-journal.el" user-emacs-directory)))

(when (file-exists-p (expand-file-name "lisp/aygp-verbiste.el" user-emacs-directory))
  (load-file (expand-file-name "lisp/aygp-verbiste.el" user-emacs-directory)))

;; Create a new journal entry for today (fallback if aygp-journal not loaded)
(unless (fboundp 'aygp-journal-new-entry)
  (defun aygp-new-journal-entry ()
    "Create a new journal entry for today."
    (interactive)
    (let* ((today (format-time-string "%Y%m%d"))
           (filename (format "~/.anthropic/journal/%s.org" today)))
      (find-file filename)
      (when (= (buffer-size) 0)
        (insert (format "#+TITLE: Journal Entry - %s\n" (format-time-string "%Y-%m-%d")))
        (insert "#+AUTHOR: Aidan Pace\n")
        (insert "#+EMAIL: apace@defrecord.com\n\n")
        (insert "* Tasks\n\n")
        (insert "* Notes\n\n")
        (insert "* Code Snippets\n\n")
        (insert "* References\n\n")
        (save-buffer))))
  
  (global-set-key (kbd "C-c j") 'aygp-new-journal-entry))

;; FreeBSD-specific configuration
(when *is-freebsd*
  ;; Set TRAMP default method for FreeBSD
  (setq tramp-default-method "ssh")
  
  ;; Setup for dired to work well on FreeBSD
  (setq dired-listing-switches "-alh")
  
  ;; FreeBSD documentation lookup
  (defun freebsd-man (command)
    "Look up FreeBSD man page for COMMAND."
    (interactive "sMan page: ")
    (manual-entry command)))

;; Startup message
(add-hook 'after-init-hook
          (lambda ()
            (message "AYGP Emacs configuration loaded successfully for %s"
                     (cond (*is-freebsd* "FreeBSD")
                           (*is-linux* "Linux")
                           (*is-macos* "macOS")
                           (t "Unknown OS")))))

;; ===== Custom Variables =====
;; Store custom settings in a separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(provide 'init)
;;; init.el ends here