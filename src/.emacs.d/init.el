(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(defvar my-packages
  '(; UI
    color-theme-solarized

    ; Editing
    evil
    ace-jump-mode
    key-chord

    ; Git wrapper
    magit

    ; Autocomplete
    icicles

    ; Markdown
    markdown-mode

    ; Lisp stuff
    clojure-mode
    clojure-test-mode
    nrepl
    paredit
    rainbow-delimiters))

(defun ensure-package-installed (package)
  (when (not (package-installed-p package))
    (package-install package)))

(when (null package-archive-contents)
	(package-refresh-contents))

(mapc 'ensure-package-installed my-packages)

;; UI

(load-theme 'solarized-dark t)

; Color nested parens rainbow-like
(global-rainbow-delimiters-mode)

; Disable menu bar
(menu-bar-mode -1)

; Show line numbers
(setq linum-format "%3d ")
(global-linum-mode t)


;; Enhancing emacs

(icicle-mode)
(evil-mode)
(key-chord-mode t)


;; Evil

(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)


;; Backups

; Disable backups and autosaves
(setq backup-inhibited t)
(setq auto-save-default nil)


;; Enable lisp mode hooks
(autoload 'enable-paredit-mode "paredit" "Slurp those parens" t)
(defun my-indent-on-enter ()
  (local-set-key (kbd "RET") 'newline-and-indent))

(defvar my-lisp-mode-hooks
  '(emacs-lisp-mode-hook
    clojure-mode-hook
    nrepl-mode-hook))
(mapc (lambda (hook) (add-hook hook 'enable-paredit-mode)) my-lisp-mode-hooks)
(mapc (lambda (hook) (add-hook hook 'turn-on-eldoc-mode)) my-lisp-mode-hooks)
(mapc (lambda (hook) (add-hook hook 'my-indent-on-enter)) my-lisp-mode-hooks)
