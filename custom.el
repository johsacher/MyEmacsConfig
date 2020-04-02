(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("b9e9ba5aeedcc5ba8be99f1cc9301f6679912910ff92fdf7980929c2fc83ab4d" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "bd7b7c5df1174796deefce5debc2d976b264585d51852c962362be83932873d9" "26d49386a2036df7ccbe802a06a759031e4455f07bda559dcf221f53e8850e69" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "fa2af0c40576f3bde32290d7f4e7aa865eb6bf7ebe31eb9e37c32aa6f4ae8d10" "04232a0bfc50eac64c12471607090ecac9d7fd2d79e388f8543d1c5439ed81f5" "170bb47b35baa3d2439f0fd26b49f4278e9a8decf611aa33a0dad1397620ddc3" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default)))
 '(indent-tabs-mode nil)
 '(org-agenda-files
   (quote
    ("~/Dropbox/MyFiles/Privat/Behoerden/Arbeitslos2019/ExistenzGruendung/Businessplan/.businessplan.org/businessplan.org")))
 '(package-selected-packages
   (quote
    (async-await magit git-auto-commit-mode org-ref flycheck flymake-python-pyflakes pylint org-bullets ack evil-mc multiple-cursors rainbow-delimiters evil-textobj-line realgud matlab-mode pacmacs nyan-mode parrot evil-visualstar evil-collection helm-rg spacemacs-theme moe-theme monokai-theme solarized-theme zenburn-theme ag helm-ag smart-mode-line default-text-scale zoom key-chord latex-preview-pane pdf-tools org-download which-key org-evil openwith leuven-theme evil-org helm-projectile projectile rtags evil-numbers shackle helm comment-dwim-2 evil-leader xclip sudo-ext smart-mode-line-powerline-theme lorem-ipsum evil-nerd-commenter evil elpy ein dired-toggle-sudo dired-ranger dired-narrow color-theme-buffer-local anaconda-mode ace-window)))
 '(sml/mode-width
   (if
       (eq
        (powerline-current-separator)
        (quote arrow))
       (quote right)
     (quote full)))
 '(sml/pos-id-separator
   (quote
    (""
     (:propertize " " face powerline-active1)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (car powerline-default-separator-dir)))
                   (quote powerline-active1)
                   (quote powerline-active2))))
     (:propertize " " face powerline-active2))))
 '(sml/pos-minor-modes-separator
   (quote
    (""
     (:propertize " " face powerline-active1)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (cdr powerline-default-separator-dir)))
                   (quote powerline-active1)
                   (quote sml/global))))
     (:propertize " " face sml/global))))
 '(sml/pre-id-separator
   (quote
    (""
     (:propertize " " face sml/global)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (car powerline-default-separator-dir)))
                   (quote sml/global)
                   (quote powerline-active1))))
     (:propertize " " face powerline-active1))))
 '(sml/pre-minor-modes-separator
   (quote
    (""
     (:propertize " " face powerline-active2)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (cdr powerline-default-separator-dir)))
                   (quote powerline-active2)
                   (quote powerline-active1))))
     (:propertize " " face powerline-active1))))
 '(sml/pre-modes-separator (propertize " " (quote face) (quote sml/modes))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-selection-face ((t (:background "deep sky blue" :foreground "black"))))
 '(font-lock-comment-face ((t (:foreground "light green"))))
 '(font-lock-keyword-face ((t (:foreground "SkyBlue1" :weight bold))))
 '(font-lock-string-face ((t (:foreground "hot pink"))))
 '(matlab-unterminated-string-face ((t (:foreground "dark blue" :underline t))))
 '(popup-menu-selection-face ((t (:inherit default :background "cyan" :foreground "black"))))
 '(popup-scroll-bar-foreground-face ((t (:background "deep sky blue"))))
 '(term ((t (:background "black" :foreground "white"))))
 '(term-color-blue ((((class color) (min-colors 89)) (:background "#5fafd7" :foreground "#5fafd7"))))
 '(term-color-green ((((class color) (min-colors 89)) (:background "#a1db00" :foreground "#a1db00")))))
