;;; functions.el -*- lexical-binding: t; -*-
(provide 'functions)

(defun rc/duplicate-line ()
  "Duplicate current line."
  (interactive)
  (let ((column (current-column))
        (line (buffer-substring-no-properties
               (line-beginning-position)
               (line-end-position))))
    (end-of-line)
    (newline)
    (insert line)
    (move-to-column column)))

(defconst rc/cheatsheet-file
  (expand-file-name "CHEATSHEET.md" user-emacs-directory)
  "Path to the local Emacs keybinding cheatsheet.")

(defun rc/protect-cheatsheet-buffer ()
  "Open the cheatsheet buffer in read-only mode to avoid accidental edits."
  (when (and buffer-file-name
             (file-equal-p (file-truename buffer-file-name)
                           (file-truename rc/cheatsheet-file)))
    (read-only-mode 1)
    (view-mode 1)))

(defun rc/open-cheatsheet ()
  "Open the local Emacs keybinding cheatsheet."
  (interactive)
  (find-file rc/cheatsheet-file))

(add-hook 'find-file-hook #'rc/protect-cheatsheet-buffer)

;; ----------------------------
;; Yasnippet → Corfu integration
;; ----------------------------
(defun rc/yasnippet-capf ()
  "Completion-at-point function that exposes yasnippet triggers to corfu.
Each snippet candidate is tagged with kind `snippet' so kind-icon
can render a distinct icon.  Selecting a snippet expands it
immediately, similar to how LSP snippets behave."
  (when (and (bound-and-true-p yas-minor-mode)
             (not (and (fboundp 'yas--snippet-active-p)
                       (yas--snippet-active-p))))
    (when-let* ((tables (yas--get-snippet-tables))
                (templates (cl-remove-if-not
                            (lambda (tpl)
                              (yas--template-can-expand-p
                               (yas--template-condition tpl)
                               (yas--require-template-specific-condition-p)))
                            (yas--all-templates tables)))
                (bounds (bounds-of-thing-at-point 'symbol)))
      (list (car bounds) (cdr bounds)
            (lambda (str pred action)
              (if (eq action 'metadata)
                  '(metadata (category . snippet)
                             (display-sort-function . identity))
                (complete-with-action
                 action
                 (mapcar #'yas--template-key templates)
                 str pred)))
            :exclusive 'no
            :company-kind (lambda (_) 'snippet)
            :exit-function
            (lambda (_str status)
              (when (eq status 'finished)
                (yas-expand)))))))

(global-set-key (kbd "C-,") #'rc/duplicate-line)
(global-set-key (kbd "C-c ?") #'rc/open-cheatsheet)
