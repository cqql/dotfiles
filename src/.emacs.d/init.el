;;; init.el --- My configuration

;;; Commentary:

;;; Code:

;; Load/install packages
(require 'cask "~/.cask/cask.el")

(eval-and-compile
  (cask-initialize)

  (push "~/.emacs.d/lisp" load-path))

;; Set global/emacs-wide settings
(require 'globals)

;; Global requires
(require 'dash)
(require 's)

(require 'use-package)

(use-package savehist
  :config
  (setf history-length 200)
  (savehist-mode))

(use-package eldoc
  :config (setf eldoc-idle-delay 0.2))

(use-package whitespace
  :config
  (setf whitespace-line-column 80
        ;; I also like the other styles, but they are too performance heavy
        whitespace-style '(face lines))

  (add-hook 'prog-mode-hook #'whitespace-mode))

(use-package ibuffer
  :bind ("C-x C-b" . ibuffer))

(use-package cqql
  :bind (("C-a" . cqql-go-to-beginning-of-line-dwim)
         ("M-D" . cqql-duplicate-text)
         ("C-S-k" . cqql-kill-line)
         ("C-o" . cqql-open-line)
         ("C-S-o" . cqql-open-line-above)))

(use-package discover-my-major
  :bind ("C-h C-m" . discover-my-major))

(use-package visual-regexp
  :bind (("M-3" . vr/replace)
         ("M-#" . vr/query-replace)))

(use-package ag
  :bind (("C-x C-a" . ag-project-regexp)
         ("C-x M-a" . ag-regexp))
  :config
  ;; Search in hidden files
  (add-to-list 'ag-arguments "--hidden")

  ;; Highlight matches
  (setf ag-highlight-search t))

(use-package move-text
  :bind (("C-S-p" . move-text-up)
         ("C-S-n" . move-text-down)))

(use-package avy
  :bind (("M-s" . avy-goto-word-or-subword-1)
         ("M-S" . avy-goto-char-2)))

(use-package ace-window
  :bind ("M-i" . ace-window))

(use-package yasnippet
  :config
  (bind-key ";" 'yas-expand yas-minor-mode-map)
  (bind-key "<tab>" nil yas-minor-mode-map)
  (bind-key "TAB" nil yas-minor-mode-map)

  (setq yas-fallback-behavior 'call-other-command)

  ;; Don't append newlines to snippet files
  (add-hook 'snippet-mode (lambda () (setq require-final-newline nil)))

  (setf yas-snippet-dirs '("~/.emacs.d/snippets"))

  (yas-global-mode t))

(use-package uniquify
  :config (setf uniquify-buffer-name-style 'forward
                uniquify-strip-common-suffix t))

(use-package wrap-region
  :config (wrap-region-global-mode t))

(use-package expand-region
  :bind (("M-m" . er/expand-region)
         ("M-M" . er/contract-region))
  :config
  (cqql-after-load 'ruby-mode
    (require 'ruby-mode-expansions))

  (cqql-after-load 'latex-mode
    (require 'latex-mode-expansions)))

(use-package helm
  :bind (("M-y" . helm-show-kill-ring)
         ("C-x b" . helm-mini)
         ("C-x f" . helm-find-files)
         ("M-x" . helm-M-x))
  :config (helm-mode t))

(use-package helm-swoop
  :bind ("M-o" . helm-swoop)
  :config
  (bind-key "M-o" 'helm-multi-swoop-all-from-helm-swoop helm-swoop-map))

(use-package clojure-mode
  :config
  (require 'cider-eldoc)

  (add-hook 'clojure-mode-hook 'cider-mode)
  (add-hook 'clojure-mode-hook 'cider-turn-on-eldoc-mode)
  (add-hook 'clojure-mode-hook 'smartparens-strict-mode))

(use-package company
  :bind ("C-M-SPC" . company-complete)
  :init
  (setf company-idle-delay 0
        company-minimum-prefix-length 2
        company-show-numbers t
        company-selection-wrap-around t
        company-dabbrev-ignore-case 'keep-prefix
        company-dabbrev-ignore-invisible t
        company-dabbrev-downcase nil
        company-backends (list #'company-css
                               #'company-clang
                               #'company-capf
                               (list #'company-dabbrev-code
                                     #'company-keywords)
                               #'company-files
                               #'company-dabbrev))
  :config
  (global-company-mode t))

(use-package color-identifiers-mode
  :config (setf color-identifiers:num-colors 6))

(use-package projectile
  :bind ("C-x C-f" . helm-projectile)
  :config
  (require 'helm-projectile)

  (projectile-global-mode)

  (helm-projectile-toggle 1))

(use-package shackle
  :config
  (setq shackle-rules '(("*magit-commit*" :select nil)
                        ("\*Flycheck.+\*" :select nil :regexp t)
                        ("\*ag.+\*" :select t :regexp t)
                        (t :select t)))

  (shackle-mode))

(use-package rainbow-mode
  :config (add-hook 'after-change-major-mode-hook 'rainbow-mode))

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

  (setf rainbow-delimiters-max-face-count 6))

(use-package js2-mode
  :mode (("\\.js\\'" . js2-mode) ("\\.jsx\\'" . js2-mode))
  :interpreter "node"
  :config
  (require 'js2-refactor)

  (setq-default js2-basic-offset 2)
  (setf js2-highlight-level 3
        js2-include-node-externs t)

  (js2r-add-keybindings-with-prefix "C-c r")

  (add-hook 'js2-mode-hook 'subword-mode))

(use-package scss-mode
  :config (setq scss-compile-at-save nil))

(use-package c++-mode
  :mode "\\.h\\'")

(use-package coffee-mode
  :config (add-hook 'coffee-mode-hook 'subword-mode))

(use-package lisp-mode
  :mode ("Cask\\'" . emacs-lisp-mode)
  :config
  (bind-key "C-h C-f" 'find-function emacs-lisp-mode-map)

  (add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
  (add-hook 'emacs-lisp-mode-hook 'flycheck-mode)
  (add-hook 'emacs-lisp-mode-hook 'smartparens-strict-mode))

(use-package haskell-mode
  :config (add-hook 'haskell-mode-hook 'structured-haskell-mode))

(use-package magit
  :bind (("<f2>" . magit-status)
         ("C-c g b" . magit-blame-mode)
         ("C-c g l" . magit-file-log))
  :init
  (setq magit-last-seen-setup-instructions "1.4.0"))

(use-package git-timemachine
  :bind ("C-c g t" . git-timemachine))

(use-package highlight-symbol
  :config
  (add-hook 'prog-mode-hook 'highlight-symbol-mode)

  (setf highlight-symbol-idle-delay 0))

(use-package hippie-exp
  :bind ("M-/" . hippie-expand)
  :init
  (setf hippie-expand-try-functions-list
        '(try-expand-dabbrev-visible
          try-expand-dabbrev
          try-expand-dabbrev-all-buffers
          try-expand-line
          try-complete-lisp-symbol)))

(use-package sh-script
  :mode ("PKGBUILD\\'" . sh-mode)
  :config  (setq-default sh-basic-offset 2))

(use-package flx-ido
  :disabled t
  :config (flx-ido-mode t))

(use-package python
  :config
  (when (executable-find "ipython")
    (setq python-shell-interpreter "ipython"))

  (add-hook 'python-mode-hook 'eldoc-mode))

(use-package py-yapf
  :config
  (add-hook 'python-mode-hook 'py-yapf-enable-on-save))

(use-package company-jedi
  :config
  (add-hook 'python-mode-hook 'company-jedi--setup))

(defun cqql-disable-ruby-lint-checker ()
  "Disable the ruby-lint checker."
  (cqql-after-load 'flycheck
    (let* ((checkers (flycheck-checker-next-checkers 'ruby-rubocop))
           (filtered (-filter (lambda (e) (not (eq 'ruby-rubylint (cdr e)))) checkers)))
      (put 'ruby-rubocop 'flycheck-next-checkers filtered))))

(use-package ruby-mode
  :commands (rspec-verify-single rspec-rerun rspec-verify rspec-verify-all)
  :mode (("Rakefile\\'" . ruby-mode)
         ("Capfile\\'" . ruby-mode)
         ("Vagrantfile\\'" . ruby-mode)
         ("Berksfile\\'" . ruby-mode)
         (".gemspec\\'" . ruby-mode)
         (".json_builder\\'" . ruby-mode)
         ("Gemfile\\'" . ruby-mode))
  :config
  (cqql-define-keys ruby-mode-map
    ("C-c f" 'rspec-verify-single)
    ("C-c r r" 'rspec-rerun)
    ("C-c r f" 'rspec-verify)
    ("C-c r g" 'rspec-verify-all))

  (setf ruby-insert-encoding-magic-comment nil)

  (add-hook 'ruby-mode-hook 'robe-mode)
  (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
  (add-hook 'ruby-mode-hook 'yard-mode)
  (add-hook 'ruby-mode-hook 'eldoc-mode)
  (add-hook 'ruby-mode-hook 'subword-mode)
  (add-hook 'ruby-mode-hook 'flycheck-mode)
  (add-hook 'ruby-mode-hook 'cqql-disable-ruby-lint-checker))

(use-package rspec-mode
  :config
  (cqql-after-load 'ruby-mode
    (require 'rspec-mode)

    (setq rspec-use-rake-when-possible nil)))

(defun cqql-dired-jump-to-first-file ()
  (interactive)
  (goto-char (point-min))
  (dired-next-line 4))

(defun cqql-dired-jump-to-last-file ()
  (interactive)
  (goto-char (point-max))
  (dired-next-line -1))

(use-package dired
  :config
  (setf dired-listing-switches "-lahv")

  (define-key dired-mode-map
    [remap beginning-of-buffer] 'cqql-dired-jump-to-first-file)

  (define-key dired-mode-map
    [remap end-of-buffer] 'cqql-dired-jump-to-last-file))

(use-package org
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :init
  (setf org-directory "~/notes"
        org-agenda-files (list org-directory)
        org-default-notes-file "notes.org"
        org-crypt-key nil
        org-tags-exclude-from-inheritance (list "crypt")
        org-startup-indented t
        org-M-RET-may-split-line nil
        org-enforce-todo-dependencies t
        org-enforce-todo-checkbox-dependencies t
        org-agenda-start-on-weekday nil
        org-capture-templates
        '(("n" "Note" entry (file+olp "notes.org" "Inbox")
           "* %?")
          ("i" "Idea" entry (file+olp "notes.org" "Ideas")
           "* %?")
          ("v" "vitakid")
          ("vw" "Web" entry (file+olp "notes.org" "vitakid" "Web")
           "* %?")
          ("vs" "Servers" entry (file+olp "notes.org" "vitakid" "Servers")
           "* %?")
          ("va" "Apps" entry (file+olp "notes.org" "vitakid" "Apps")
           "* %?")
          ("vq" "QuaLiFY" entry (file+olp "notes.org" "vitakid" "QuaLiFY")
           "* %?")
          ("p" "Passwords")
          ("pp" "Personal Password" entry
           (file+olp "notes.org" "Passwords" "Personal")
           "* %^{Service Name (e.g. gmail)} :crypt:
User: %^{User}
Password: %^{Password}")
          ("pv" "vitakid Password" entry
           (file+olp "notes.org" "Passwords" "vitakid")
           "* %^{Service Name (e.g. gmail)} :crypt:
User: %^{User}
Password: %^{Password}")))

  :config
  (require 'org-crypt)
  (org-crypt-use-before-save-magic)

  ;; Configure org-babel
  (setf org-src-fontify-natively t
        org-babel-load-languages '((emacs-lisp . t)
                                   (python . t)))

  ;; Load language support
  (org-babel-do-load-languages
   'org-babel-load-languages
   org-babel-load-languages))

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook 'org-bullets-mode))

(use-package smart-mode-line
  :config
  (setf sml/theme 'dark
        sml/no-confirm-load-theme t)

  (sml/setup))

(use-package smartparens
  :config
  (require 'smartparens-config)

  (cqql-define-keys smartparens-mode-map
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

  (smartparens-global-mode t)
  (smartparens-strict-mode t)
  (show-smartparens-global-mode t))

(use-package web-mode
  :mode "\\.erb\\'")

(use-package tex-mode
  :mode ("\\.tex\\'" . LaTeX-mode)
  :config
  ;; Workaround for smartparens overwriting `
  (require 'smartparens-latex)

  (require 'latex)
  (require 'tex-site)
  (require 'preview)

  (cqql-define-keys LaTeX-mode-map
    ("C-c u" (lambda () (interactive) (insert "ü")))
    ("C-c U" (lambda () (interactive) (insert "Ü")))
    ("C-c a" (lambda () (interactive) (insert "ä")))
    ("C-c A" (lambda () (interactive) (insert "Ä")))
    ("C-c o" (lambda () (interactive) (insert "ö")))
    ("C-c O" (lambda () (interactive) (insert "Ö")))
    ("C-c s" (lambda () (interactive) (insert "ß"))))

  (add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)

  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (setq TeX-electric-sub-and-superscript t
                    TeX-save-query nil
                    TeX-view-program-selection '((output-pdf "Okular"))
                    ;; Otherwise minted can't find pygments
                    TeX-command-extra-options "-shell-escape"))))

(use-package key-chord
  :config (key-chord-mode t))

(use-package hydra)

(require 'bindings)

(provide 'init)
;;; init.el ends here
