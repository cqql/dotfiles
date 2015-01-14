;; Put this at the top, so that themes will be treated as safe, when they are
;; loaded
(custom-set-variables)

;; Load/install packages
(require 'cask "~/.cask/cask.el")
(cask-initialize)

(push "~/.emacs.d/lisp" load-path)

(require 'cqql-utils)

;; Set global/emacs-wide settings
(require 'globals)

;; Global requires
(require 'dash)
(require 's)

(require 'use-package)
(use-package ag
  :config
  (progn
    ;; Search in hidden files
    (add-to-list 'ag-arguments "--hidden")

    ;; Highlight matches
    (setf ag-highlight-search t)))

(use-package yasnippet
  :config
  (progn
    (setq yas-fallback-behavior 'call-other-command)

    ;; Don't append newlines to snippet files
    (add-hook 'snippet-mode (lambda () (setq require-final-newline nil)))

    ;; Don't remove whitespace in yasnippets
    (add-to-list 'cqql/no-trimming-modes 'snippet-mode)

    (setf yas-snippet-dirs '("~/.emacs.d/snippets"))

    (yas-global-mode t)))

(use-package uniquify
  :config (setf uniquify-buffer-name-style 'forward
                uniquify-strip-common-suffix t))

(use-package smex
  :config (smex-initialize))

(use-package wrap-region
  :config (wrap-region-global-mode t))

(use-package expand-region
  :config
  (progn
    (cqql/after-load 'ruby-mode
      (require 'ruby-mode-expansions))

    (cqql/after-load 'latex-mode
      (require 'latex-mode-expansions))))

(use-package helm
  :config (helm-mode t))

(use-package clojure-mode
  :config
  (progn
    (require 'cider-eldoc)

    (add-hook 'clojure-mode-hook 'cider-mode)
    (add-hook 'clojure-mode-hook 'cider-turn-on-eldoc-mode)
    (add-hook 'clojure-mode-hook 'smartparens-strict-mode)))

(use-package company
  :config
  (progn
    (add-to-list 'company-backends 'company-robe)

    (global-company-mode t)))

(use-package color-identifiers-mode
  :config (setf color-identifiers:num-colors 6))

(use-package projectile
  :config
  (progn
    (require 'helm-projectile)

    (projectile-global-mode)))

(use-package popwin
  :config
  (progn
    (push '(ag-mode) popwin:special-display-config)
    (push '("\*.+compilation\*" :regexp t) popwin:special-display-config)

    (popwin-mode t)))

(use-package rainbow-mode
  :config (add-hook 'after-change-major-mode-hook 'rainbow-mode))

(use-package rainbow-delimiters
  :config
  (progn
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

    (setf rainbow-delimiters-max-face-count 6)))

(use-package js2-mode
  :mode (("\\.js\\'" . js2-mode) ("\\.jsx\\'" . js2-mode))
  :interpreter "node"
  :config
  (progn
    (require 'js2-refactor)

    (setq-default js2-basic-offset 2)
    (setf js2-highlight-level 3
          js2-include-node-externs t)

    (js2r-add-keybindings-with-prefix "C-c r")

    (add-hook 'js2-mode-hook 'subword-mode)))

(use-package scss-mode
  :config (setq scss-compile-at-save nil))

(use-package c++-mode
  :mode "\\.h\\'")

(use-package coffee-mode
  :config (add-hook 'coffee-mode-hook 'subword-mode))

(use-package lisp-mode
  :mode ("Cask\\'" . emacs-lisp-mode)
  :config
  (progn
    (add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
    (add-hook 'emacs-lisp-mode-hook 'flycheck-mode)
    (add-hook 'emacs-lisp-mode-hook 'smartparens-strict-mode)))

(use-package haskell-mode
  :config (add-hook 'haskell-mode-hook 'structured-haskell-mode))

(use-package highlight-symbol
  :config
  (progn
    (add-hook 'prog-mode-hook 'highlight-symbol-mode)

    (setf highlight-symbol-idle-delay 0)))

(use-package hippie-exp
  :config (setf hippie-expand-try-functions-list
                '(try-expand-dabbrev-visible
                  try-expand-dabbrev
                  try-expand-dabbrev-all-buffers
                  try-expand-line
                  try-complete-lisp-symbol)))

(use-package sh-mode
  :mode "PKGBUILD\\'")

(use-package flx-ido
  :disabled t
  :config (flx-ido-mode t))

(defun cqql/disable-ruby-lint-checker ()
  (cqql/after-load 'flycheck
    (let* ((checkers (flycheck-checker-next-checkers 'ruby-rubocop))
           (filtered (-filter (lambda (e) (not (eq 'ruby-rubylint (cdr e)))) checkers)))
      (put 'ruby-rubocop 'flycheck-next-checkers filtered))))

(use-package ruby-mode
  :mode (("Rakefile\\'" . ruby-mode) ("Capfile\\'" . ruby-rubocop)
         ("Vagrantfile\\'" . ruby-mode) ("Berksfile\\'" . ruby-mode)
         (".gemspec\\'" . ruby-mode) (".json_builder\\'" . ruby-mode)
         ("Gemfile\\'" . ruby-mode))
  :config
  (progn
    (setf ruby-insert-encoding-magic-comment nil)

    (add-hook 'ruby-mode-hook 'robe-mode)
    (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
    (add-hook 'ruby-mode-hook 'yard-mode)
    (add-hook 'ruby-mode-hook 'eldoc-mode)
    (add-hook 'ruby-mode-hook 'subword-mode)
    (add-hook 'ruby-mode-hook 'flycheck-mode)
    (add-hook 'ruby-mode-hook 'cqql/disable-ruby-lint-checker)))

(use-package rspec-mode
  :config
  (progn
    (cqql/after-load 'ruby-mode
      (require 'rspec-mode)

      (setq rspec-use-rake-when-possible nil))))

(defun cqql/dired-jump-to-first-file ()
  (interactive)
  (beginning-of-buffer)
  (dired-next-line 4))

(defun cqql/dired-jump-to-last-file ()
  (interactive)
  (end-of-buffer)
  (dired-next-line -1))

(use-package dired
  :config
  (progn
    (define-key dired-mode-map
      [remap beginning-of-buffer] 'cqql/dired-jump-to-first-file)

    (define-key dired-mode-map
      [remap end-of-buffer] 'cqql/dired-jump-to-last-file)))

(use-package org
  :config (setf org-enforce-todo-dependencies t
                org-enforce-todo-checkbox-dependencies t
                org-agenda-start-on-weekday nil
                org-capture-templates '(("g" "General work" entry (file+headline "work.org" "General") "* TODO %?")
                                        ("q" "Qualify EU" entry (file+headline "work.org" "Qualify") "* TODO %?")
                                        ("s" "Server Administration" entry (file+headline "work.org" "Server Administration") "* TODO %?"))))

(use-package smart-mode-line
  :config
  (progn
    (setq sml/theme 'dark)
    (sml/setup)))

(use-package smartparens
  :config
  (progn
    (require 'smartparens-config)
    (require 'smartparens-ruby)

    (smartparens-global-mode t)
    (smartparens-strict-mode t)
    (show-smartparens-global-mode t)))

(use-package tex-mode
  :mode ("\\.tex\\'" . LaTeX-mode)
  :config
  (progn
    ;; Workaround for smartparens overwriting `
    (require 'smartparens-latex)

    (require 'latex)
    (require 'tex-site)
    (require 'preview)

    (add-hook 'LaTeX-mode-hook 'ax-latex-mode-setup)
    (add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
    (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
    (add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)

    (add-hook 'LaTeX-mode-hook (lambda ()
                                 (setq TeX-electric-sub-and-superscript t
                                       TeX-save-query nil
                                       TeX-view-program-selection '((output-pdf "Okular"))
                                       ;; Otherwise minted can't find pygments
                                       TeX-command-extra-options "-shell-escape")))))

(require 'bindings)
