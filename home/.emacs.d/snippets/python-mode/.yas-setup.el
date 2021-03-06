;;; yas-setup --- Setup for python snippets

;;; Commentary:

;;; Code:

(eval-when-compile
  (package-initialize))

(require 'python)
(require 's)

(defun isnip-python-maybe-prepend-comma (text)
  "Prepend ', ' if TEXT is not empty"
  (if (or (string= text "") (s-starts-with? "," text))
      (if (string-match "^, *$" text)
          ""
        text)
    (concat ", " text)))

(defun isnip-python-maybe-prepend-comma-in-class (text)
  "Maybe prepend a comma, if the def is inside a class."
  (if (isnip-python-inside-class?)
      (isnip-python-maybe-prepend-comma text)
    text))

(defun isnip-python-args-to-assignments (text)
  "Convert a string of arguments to a string of self assignments."
  (if (string= text "")
      ""
    (cl-flet ((strip-decorations (spec) (string-trim-left (nth 0 (split-string spec ":\\|=")) "\\**"))
              (make-assignment (arg) (format "self.%s = %s" arg arg))
              (indent (line) (concat (s-repeat (current-indentation) " ")
                                     line)))
      (let* ((specs (split-string text ", *" t))
             (args (mapcar #'strip-decorations specs))
             (assignments (mapcar #'make-assignment args))
             (indented (cons (car assignments)
                             (mapcar #'indent (cdr assignments)))))
        (s-join "\n" indented)))))

(defun isnip-python-inside-class? ()
  "Returns t if point is inside a class."
  (save-excursion
    (let ((indentation (current-indentation))
          (in-class? (looking-at "class")))
      (while (and (> indentation 0) (not in-class?))
        (python-nav-beginning-of-defun)
        (setq indentation (current-indentation)
              in-class? (looking-at "class")))
      in-class?)))

(defun isnip-python-self-if-in-class ()
  "Returns 'self' if point is inside a class."
  (if (isnip-python-inside-class?) "self" ""))
