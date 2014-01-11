;; Workaround for smartparens overwriting `
(require 'smartparens-latex)

(require 'latex)
(require 'tex-site)
(require 'ac-math)

(add-hook 'LaTeX-mode-hook 'auto-complete-mode)
(add-hook 'LaTeX-mode-hook 'ax-latex-mode-setup)
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(setq TeX-electric-sub-and-superscript t
      TeX-PDF-mode t
      TeX-save-query nil)

(add-to-list 'auto-mode-alist '("\\.tex\\'" . LaTeX-mode))

(setq ac-sources
      (append '(ac-source-math-unicode ac-source-math-latex ac-source-latex-commands)
              ac-sources))

(add-to-list 'ac-modes 'LaTeX-mode)
