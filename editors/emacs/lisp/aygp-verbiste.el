;; aygp-verbiste.el --- Setup for verbiste French/Italian conjugation

;;; Commentary:
;; This library provides a setup for verbiste, a French and Italian verb
;; conjugation tool. It configures keybindings and convenient functions
;; for working with verbiste in Emacs.
;;
;; verbiste-el is available from Debian/FreeBSD as elpa-verbiste

;;; Code:

(require 'cl-lib)

(defgroup aygp-verbiste nil
  "Settings for verbiste French/Italian conjugation."
  :group 'applications)

;; Check if verbiste is available
(defvar aygp-verbiste-available 
  (or (featurep 'verbiste)
      (locate-library "verbiste")
      (executable-find "verbiste"))
  "Whether verbiste is available.")

(defun aygp-verbiste-ensure ()
  "Ensure verbiste is installed and available."
  (interactive)
  (if aygp-verbiste-available
      (message "Verbiste is available.")
    (if (y-or-n-p "Verbiste not found. Install it? ")
        (progn
          (cond
           ;; FreeBSD method
           ((eq system-type 'berkeley-unix)
            (message "For FreeBSD: Run 'pkg install verbiste'")
            (async-shell-command "pkg install verbiste"))
           
           ;; Debian method
           ((and (eq system-type 'gnu/linux)
                 (executable-find "apt-get"))
            (message "Installing verbiste via apt...")
            (async-shell-command "sudo apt-get install -y elpa-verbiste verbiste"))
           
           ;; macOS method
           ((eq system-type 'darwin)
            (if (executable-find "brew")
                (progn 
                  (message "Installing verbiste via Homebrew...")
                  (async-shell-command "brew install verbiste"))
              (message "Please install Homebrew, then run 'brew install verbiste'")))
           
           ;; Default case
           (t
            (message "Please install verbiste manually for your system.")))
          ;; Set to true so we don't keep prompting
          (setq aygp-verbiste-available t))
      (message "Verbiste installation skipped."))))

(defun aygp-verbiste-setup ()
  "Setup verbiste if available."
  (when aygp-verbiste-available
    (condition-case nil
        (progn
          (require 'verbiste)
          ;; Custom configuration here
          (message "Verbiste loaded successfully"))
      (error
       (message "Could not load verbiste package. Is it installed?"))))
  
  ;; Create commands even if verbiste isn't loaded yet
  (defun aygp-verbiste-conjugate-french (verb)
    "Conjugate a French VERB using verbiste."
    (interactive "sFrench verb to conjugate: ")
    (if (fboundp 'verbiste-french-conjugation)
        (verbiste-french-conjugation verb)
      (aygp-verbiste-ensure)))
  
  (defun aygp-verbiste-conjugate-italian (verb)
    "Conjugate an Italian VERB using verbiste."
    (interactive "sItalian verb to conjugate: ")
    (if (fboundp 'verbiste-italian-conjugation)
        (verbiste-italian-conjugation verb)
      (aygp-verbiste-ensure)))
  
  ;; Global keybindings if available
  (when (fboundp 'verbiste-french-conjugation)
    (global-set-key (kbd "C-c v f") 'aygp-verbiste-conjugate-french)
    (global-set-key (kbd "C-c v i") 'aygp-verbiste-conjugate-italian)))

;; Setup verbiste when this file is loaded
(aygp-verbiste-setup)

;; Define keybindings for verbiste functions
(defvar aygp-verbiste-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "f") 'aygp-verbiste-conjugate-french)
    (define-key map (kbd "i") 'aygp-verbiste-conjugate-italian)
    (define-key map (kbd "e") 'aygp-verbiste-ensure)
    map)
  "Keymap for verbiste commands.")

;; Create a global key binding prefix
(global-set-key (kbd "C-c v") aygp-verbiste-map)

(provide 'aygp-verbiste)
;;; aygp-verbiste.el ends here