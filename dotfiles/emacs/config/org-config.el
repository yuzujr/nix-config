;;; org-config.el -*- lexical-binding: t; -*-

(defconst rc/org-babel-languages
  '((shell . t)
    (python . t)
    (C . t))
  "Languages enabled for Org Babel.")

(use-package org
  :ensure nil
  :defer t
  :custom
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-src-preserve-indentation t)
  (org-edit-src-content-indentation 0)
  (org-confirm-babel-evaluate nil)
  (org-babel-python-command "python3")
  (org-babel-C-compiler "gcc")
  (org-babel-C++-compiler "g++")
  :config
  (setq org-babel-default-header-args:python
        '((:results . "output")))
  (add-hook 'org-babel-before-execute-hook
            (defun rc/org-babel-load-languages-once ()
              (org-babel-do-load-languages
               'org-babel-load-languages rc/org-babel-languages)
              (remove-hook 'org-babel-before-execute-hook
                           #'rc/org-babel-load-languages-once))))

(provide 'org-config)

;;; org-config.el ends here
