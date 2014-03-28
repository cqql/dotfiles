(cqql/define-global-keys
 ("M-/" 'hippie-expand)
 ("C-M-SPC" 'company-complete)
 ("C-a" 'cqql/go-to-beginning-of-line-dwim)
 ("M-D" 'cqql/duplicate-line)
 ("C->" 'mc/mark-next-like-this)
 ("C-M->" 'mc/skip-to-next-like-this)
 ("C-<" 'mc/unmark-next-like-this)
 ("M-n" 'mc/mark-all-like-this)
 ("C-M-n" 'mc/edit-lines)
 ("M-m" 'er/expand-region)
 ("M-M" 'er/contract-region)
 ("C-S-k" 'cqql/kill-line)
 ("C-o" 'cqql/open-line)
 ("C-S-o" 'cqql/open-line-above)
 ("C-x C-a" 'ag-project-regexp)
 ("C-x M-a" 'ag-regexp)
 ("C-x C-f" 'helm-projectile)
 ("C-x f" 'find-file)
 ("M-s" 'ace-jump-word-mode)
 ("M-S" 'ace-jump-char-mode)
 ("<M-return>" 'magit-status)
 ("M-x" 'smex)
 ("C-z" popwin:keymap))

(cqql/define-keys emacs-lisp-mode-map
                  ("C-h C-f" 'find-function))

(cqql/define-keys smartparens-mode-map
                  ("C-M-f" 'sp-forward-sexp)
                  ("C-M-S-f" 'sp-next-sexp)
                  ("C-M-b" 'sp-backward-sexp)
                  ("C-M-S-b" 'sp-previous-sexp)
                  ("C-M-n" 'sp-down-sexp)
                  ("C-M-S-n" 'sp-backward-down-sexp)
                  ("C-M-p" 'sp-up-sexp)
                  ("C-M-S-p" 'sp-backward-up-sexp)
                  ("C-M-a" 'sp-beginning-of-sexp)
                  ("C-M-e" 'sp-end-of-sexp)
                  ("C-M-k" 'sp-kill-sexp)
                  ("C-M-S-k" 'sp-backward-kill-sexp)
                  ("C-M-w" 'sp-copy-sexp)
                  ("C-M-t" 'sp-transpose-sexp)
                  ("C-M-h" 'sp-backward-slurp-sexp)
                  ("C-M-S-h" 'sp-backward-barf-sexp)
                  ("C-M-l" 'sp-forward-slurp-sexp)
                  ("C-M-S-l" 'sp-forward-barf-sexp)
                  ("C-M-j" 'sp-splice-sexp)
                  ("C-M-S-j" 'sp-raise-sexp))

(cqql/define-keys ruby-mode-map
                  ("C-c f" 'rspec-verify-single)
                  ("C-c r r" 'rspec-rerun)
                  ("C-c r f" 'rspec-verify)
                  ("C-c r g" 'rspec-verify-all))

(cqql/define-keys yas-minor-mode-map
                  ("<tab>" nil)
                  ("TAB" nil)
                  (";" 'yas-expand))

(cqql/define-keys LaTeX-mode-map
                  ("C-c u" (lambda () (interactive) (insert "ü")))
                  ("C-c U" (lambda () (interactive) (insert "Ü")))
                  ("C-c a" (lambda () (interactive) (insert "ä")))
                  ("C-c A" (lambda () (interactive) (insert "Ä")))
                  ("C-c o" (lambda () (interactive) (insert "ö")))
                  ("C-c O" (lambda () (interactive) (insert "Ö")))
                  ("C-c s" (lambda () (interactive) (insert "ß"))))

(provide 'bindings)
