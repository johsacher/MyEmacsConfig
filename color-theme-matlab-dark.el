(defun color-theme-matlab-dark ()
  "Color theme by Jari Aalto, created 2001-03-08.
Black on light yellow.
Used for Win32 on a Nokia446Xpro monitor.
Includes cvs, font-lock, gnus, message, sgml, widget"
  (interactive)
  (color-theme-install
    (font-lock-comment-face ((t (:foreground "forest green")))) ;; comments
    (font-lock-function-name-face ((t (:foreground "Black")))) ;; function names
    (font-lock-keyword-face ((t (:foreground "Blue")))) ;; key words
    (font-lock-string-face ((t (:foreground "Purple")))) ;; string
    (font-lock-type-face ((t (:foreground "Black")))) ;; e.g. == (equal-operator)
    (font-lock-variable-name-face ((t (:foreground "black")))) ;; variables
)
