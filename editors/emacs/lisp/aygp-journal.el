;; aygp-journal.el --- Functions for AYGP journal management

;;; Commentary:
;; This library provides functions for managing AYGP journal entries
;; in org-mode format.  Journal entries are stored in ~/.anthropic/journal/
;; with a YYYYMMDD.org naming convention.

;;; Code:
(require 'org)
(require 'cl-lib)

(defgroup aygp-journal nil
  "AYGP Journal management."
  :group 'applications)

(defcustom aygp-journal-directory "~/.anthropic/journal/"
  "Directory for storing journal entries."
  :type 'directory
  :group 'aygp-journal)

(defcustom aygp-journal-template
  "#+TITLE: Journal Entry - %s
#+AUTHOR: Aidan Pace
#+EMAIL: apace@defrecord.com

* Status
:PROPERTIES:
:VISIBILITY: all
:END:

** Current Projects
- 

** Active Tasks
- 

** Blockers
- 

* Tasks
:PROPERTIES:
:VISIBILITY: folded
:END:

** TODO 

* Notes
:PROPERTIES:
:VISIBILITY: folded
:END:

* Code Snippets
:PROPERTIES:
:VISIBILITY: folded
:END:

#+begin_src emacs-lisp
  
#+end_src

* References
:PROPERTIES:
:VISIBILITY: folded
:END:
"
  "Template for new journal entries."
  :type 'string
  :group 'aygp-journal)

(defun aygp-journal-date-to-filename (date)
  "Convert DATE to a journal filename."
  (expand-file-name (format "%s.org" date) aygp-journal-directory))

(defun aygp-journal-new-entry ()
  "Create a new journal entry for today."
  (interactive)
  (let* ((today (format-time-string "%Y%m%d"))
         (filename (aygp-journal-date-to-filename today)))
    (find-file filename)
    (when (= (buffer-size) 0)
      (insert (format aygp-journal-template 
                      (format-time-string "%Y-%m-%d")))
      (save-buffer))))

(defun aygp-journal-find-entry (date)
  "Find journal entry for DATE (YYYYMMDD format)."
  (interactive "sDate (YYYYMMDD): ")
  (find-file (aygp-journal-date-to-filename date)))

(defun aygp-journal-find-today ()
  "Find today's journal entry."
  (interactive)
  (find-file (aygp-journal-date-to-filename (format-time-string "%Y%m%d"))))

(defun aygp-journal-find-yesterday ()
  "Find yesterday's journal entry."
  (interactive)
  (let* ((time (time-subtract (current-time) (days-to-time 1)))
         (yesterday (format-time-string "%Y%m%d" time)))
    (find-file (aygp-journal-date-to-filename yesterday))))

(defun aygp-journal-list-entries ()
  "List all journal entries in a completion buffer."
  (interactive)
  (let* ((files (directory-files aygp-journal-directory nil "^[0-9]\\{8\\}\\.org$"))
         (dates (mapcar (lambda (file) (substring file 0 8)) files))
         (selected-date (completing-read "Select date: " dates nil t)))
    (when selected-date
      (find-file (aygp-journal-date-to-filename selected-date)))))

(defun aygp-journal-insert-template (template-name)
  "Insert a predefined template by TEMPLATE-NAME into current journal."
  (interactive 
   (list (completing-read "Template: " 
                          '("status-update" "project-update" "meeting-notes" "code-review")
                          nil t)))
  (cond
   ((string= template-name "status-update")
    (insert "** Status Update\n"
            "- Current focus: \n"
            "- Progress: \n"
            "- Next steps: \n"))
   
   ((string= template-name "project-update")
    (insert "** Project Update: [Project Name]\n"
            "- Status: \n"
            "- Key achievements: \n"
            "- Challenges: \n"
            "- Timeline updates: \n"))
   
   ((string= template-name "meeting-notes")
    (insert "** Meeting: [Topic]\n"
            "- Date: " (format-time-string "%Y-%m-%d") "\n"
            "- Attendees: \n"
            "- Agenda: \n"
            "- Discussion: \n"
            "- Action items: \n"))
   
   ((string= template-name "code-review")
    (insert "** Code Review: [PR/Branch]\n"
            "- Repository: \n"
            "- Changes: \n"
            "- Comments: \n"
            "- Suggestions: \n"))
   
   (t (message "Unknown template: %s" template-name))))

(defun aygp-journal-search ()
  "Search through all journal entries."
  (interactive)
  (counsel-rg nil aygp-journal-directory))

;; Define keybindings for journal functions
(defvar aygp-journal-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "n") 'aygp-journal-new-entry)
    (define-key map (kbd "f") 'aygp-journal-find-entry)
    (define-key map (kbd "t") 'aygp-journal-find-today)
    (define-key map (kbd "y") 'aygp-journal-find-yesterday)
    (define-key map (kbd "l") 'aygp-journal-list-entries)
    (define-key map (kbd "i") 'aygp-journal-insert-template)
    (define-key map (kbd "s") 'aygp-journal-search)
    map)
  "Keymap for AYGP journal commands.")

(defalias 'aygp-journal-map aygp-journal-map)

;; Create a global key binding prefix
(global-set-key (kbd "C-c j") aygp-journal-map)

(provide 'aygp-journal)
;;; aygp-journal.el ends here