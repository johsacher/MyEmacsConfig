;;*TODOs
;;** combine org/headline with major-mode in programming-language --> fold/unfold capability sections / short-cuts new-heading / sub-heading etc.


; overlay an arrow where the mark is
  (defvar mp-overlay-arrow-position)
  (make-variable-buffer-local 'mp-overlay-arrow-position)
  (add-to-list 'overlay-arrow-variable-list  'mp-overlay-arrow-position)

 (defun mp-mark-hook ()
    ;; (make-local-variable 'mp-overlay-arrow-position)
    (unless (or (minibufferp (current-buffer)) (not (mark)))
      (set
       'mp-overlay-arrow-position
       (save-excursion
         (goto-char (mark))
         (forward-line 0)
         (point-marker)))))

;;; USER CONTROL

;; decide if want to use different themes for different files/modes
(setq color-theme-buffer-local-switch nil)

;;; END USER CONTROL

;;; TODOS


;;; copy/paste in terminal-mode, also remote
;; todo: first check if xclip is installed in system
;;(require 'xclip)
;;(xclip-mode 1)

;;;; customization go to specific file (in cloud)
(setq my_load_path (file-name-directory load-file-name)) ;; save custom file also to the same path
(setq custom-file-name "custom.el")
(setq custom-file (concat my_load_path custom-file-name)) ;; has to be name "custom-file" -> so emacs recognizes it and writes saved customization there (https://www.gnu.org/software/emacs/manual/html_node/emacs/Saving-Customizations.html)
(load custom-file)



;;; GENERAL STUFF ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; path of my init file loaded in .emacs init file --> all manually installed .el-files (packages) should be located there
;; add this path to load path
(setq my_load_path (file-name-directory load-file-name)) ;; the init file folder contains also all manual packages
(add-to-list 'load-path my_load_path)
;;(add-to-list 'image-load-path my_load_path)


;;; GENERAL SETTINGS

;; title (play around -> tribute to emacs)
(setq frame-title-format '("I ❤ Emacs I ❤ Emacs I ❤ Emacs I ❤ Emacs I ❤ Emacs ❤ I"))

;*) global line number mode on
(global-display-line-numbers-mode)
;*) scroll bar off
(if (display-graphic-p)
    (toggle-scroll-bar -1)
  )
;; tool bar off
(tool-bar-mode -1)

;;; *)  my packages ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-----------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;+) MELPA packages - make them available (some very good additional package list)
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line


;;;* evil - load/ general
;; necessary for evil-collection (before load evil first time):
(setq evil-want-integration t) ;; This is optional since it's already set to t by default.
(setq evil-want-keybinding nil)
(require 'evil)

(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  ;; (add-to-list 'evil-emacs-state-modes 'dired-mode) 
  (add-to-list 'evil-emacs-state-modes 'term-mode) ;; according to my emacs-policy -> only exception starting in emacs-state 
  ;;; quirk to allow to move beyond last character of line to evaluate lisp expressions
  (setq evil-move-beyond-eol t)
)

;;; evil-collection --> set for certain modes
(evil-collection-init
 'dired
 )

;;** search string under visual selection (commonly used also by vimmers) 
(require 'evil-visualstar)

;; quick search replace
(defun quick-evil-search-replace ()
  (interactive)
(let ((my-string "'<,'>s///g"))
  (minibuffer-with-setup-hook
   ;; (lambda () (backward-char  4))
    (lambda () (backward-char (/ 7 2)))
    (evil-ex my-string)))
)

;; quickly select pasted region
(defun evil-select-pasted ()
  "Visually select last pasted text."
  (interactive)
  (evil-goto-mark ?\[)
  (evil-visual-char)
  (evil-goto-mark ?\]))
;; ( -> mapped to evil leader v)

;; evil leader
(use-package evil-leader
  :ensure t
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>") ;; space is handy, no interference with other functionalities, ',' is not a good choice, conflicts with repeat motion
  (use-package comment-dwim-2 :ensure t) ;; toggles also single line, in contrast to comment-dwim

  (evil-leader/set-key "c" 'comment-dwim-2) ;
  (evil-leader/set-key "k" 'kill-this-buffer)
  (evil-leader/set-key "s" 'save-buffer) 
  (evil-leader/set-key "f" 'helm-find) 
  (evil-leader/set-key "d" 'dired-go-current-buffer) 
  (evil-leader/set-key "g" 'helm-rg) ;  ack / ag / rg --> ag did not work , rg works (if installed)
  (evil-leader/set-key "p" 'helm-projectile-find-file) 
  (evil-leader/set-key "d" 'dired-go-current-buffer) 
  (evil-leader/set-key "x" 'helm-M-x)
  (evil-leader/set-key "2" 'split-window-below) 
  (evil-leader/set-key "3" 'split-window-right) 
  (evil-leader/set-key "0" 'delete-window) 
  (evil-leader/set-key "1" 'delete-other-windows) 
  (evil-leader/set-key "b" 'helm-mini)  ; recent files (better than recentf-open-files and/or helm-buffers-list)
  (evil-leader/set-key "r" 'quick-evil-search-replace)  ; quick way to replace expression in region
  (evil-leader/set-key "v" 'evil-select-pasted)  ; quick way to replace expression in region
  (evil-leader/set-key "e" (lambda () (interactive) (revert-buffer t t) (message "buffer reverted" ))) ; quick way to replace expression in region
  (evil-leader/set-key "'" 'iresize-mode)
)                 

(require 'evil-numbers)
(global-set-key (kbd "C-c +") 'evil-numbers/inc-at-pt)
(global-set-key (kbd "C-c -") 'evil-numbers/dec-at-pt)


;;* planet-mode (my org extension)
(load (concat my_load_path "planet/planet.el"))
(add-hook 'org-mode-hook
         (lambda ()
           (planet-mode)
          ))
          
(add-hook 'planet-mode-hook
         (lambda ()
           (outline-show-all)
           ))



;;;* elisp mode
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (auto-complete-mode)))

;;;* bash (=shell-script-mode)
(add-hook 'shell-script-mode-hook
          (lambda ()
            (auto-complete-mode)))

;;;* c++
(add-hook 'c++-mode-hook
          (lambda ()
            (auto-complete-mode)))

;;;* python
(add-hook 'python-mode-hook
          (lambda ()
            (auto-complete-mode)))


;;;* ipython-calculator (my)
;; todo: if not exists --> create ansi-term (non-sticky), enter ipython, and rename *ipython-calculator*
(defvar ipython-calculator-buffer-name "*ipython-calculator*")
(defun ipython-calculator ()
  (interactive)
  (switch-to-buffer ipython-calculator-buffer-name)
  )
(evil-leader/set-key "a" 'ipython-calculator) 

;;;* org-mode

;;** org bullets
(require 'org-bullets)
(add-hook 'org-mode-hook
          (lambda nil (org-bullets-mode 1)))
(setq org-bullets-bullet-list
  '(;;; Large
    "◉"
    "○"
    "•"
    "★"
    "✸"
    "◆"
    "♣"
    "♠"
    "♥"
    "♦"
    ;; ◉ ○ ●  ★  ♥ ◇ ✚ ✜ ☯ ◆ ♠ ♣ ♦ ☢ ❀ ◆ ◖ ▶ ✿
    ;; ► • ★ ▸
    )
  )

;;** disable line-numbers
 (add-hook 'org-mode-hook
           (lambda nil (display-line-numbers-mode -1)))

 (add-hook 'org-mode-hook
           (lambda nil
             (org-bullets-mode 1)
             ))
(require 'org-install)

;;** evil org
(require 'evil-org)
(setq org-M-RET-may-split-line nil)


;;;*** make tab key work as org-cycle in terminal
(evil-define-key 'normal evil-jumper-mode-map (kbd "TAB") nil)

(add-hook 'org-mode-hook
          (lambda ()
            (org-indent-mode)
            (visual-line-mode)))


;; org-mode paste image from clipboard
(defun org-insert-clipboard-image () ;; --> insert image after screenshooting to clipboard
  (interactive)
  (setq filename
        (concat
                  "screenshot_"
                  (format-time-string "%Y%m%d_%H%M%S") ".png"))
  (setq command_string (concat "xclip -selection clipboard -t image/png -o > " filename))
  (shell-command command_string)
  ;; (message concat("executed command: "  command_string))
  (insert (concat "[[./" filename "]]"))
  ;; (insert command_string)
  (org-display-inline-images)
  )

(evil-leader/set-key "n" 'planet-open-quick-notes) 
;; paste image from clipboard
(evil-leader/set-key-for-mode 'org-mode "i" 'org-insert-clipboard-image) 


;; in dired -> create org mode file within hidden folder (of same name)
;; (we don t want all the "junk" to be seen, images, latex aux files, etc.)
;; (originally i wanted to additionally set a soft link to org file, but discarded that, because soft links are "mistreated/violated" by Dropbox)
(defun create-hidden-org-file-folder (&optional filebasename path)
   (interactive)
   ;;* determine filename
   (if (not filebasename)
       (setq filebasename (read-string "Org-file-name (without .org-extension):"))
     )

   ;;* path
   (if (not path) ;; default --> put to current path
        (setq path (get-current-path))
     )
   ;; create the hidden (dotted) folder with same name of org file
     (setq new-directory-full-name (concat (file-name-as-directory path) "." filebasename ".org"))
    (make-directory new-directory-full-name)
   ;; create the org file within that folder
   (setq new-org-file-full-name (concat (file-name-as-directory new-directory-full-name) filebasename ".org"))
   ;;* create file (2 options)
   ;;** option1: with-temp-buffer
   ;; (with-temp-buffer (write-file new-org-file-full-name)) ;; equivalent to >> echo "" > file
   ;;** option2: write-region
   (write-region "" nil new-org-file-full-name) ;; equivalent to >> echo "" >> file
   ;; option2 safer, in case dayfile exists, content is not deleted
)

(defun create-symlink-for-hidden-org-file-folder (&optional orgdotfolder-full)
   (interactive)
   (setq orgdotfolder (file-name-nondirectory orgdotfolder-full))
   ;; create softlink --> discarded, see above
   (when (string-match "^\.\\(.*\\)\.org$" orgdotfolder)
     (setq filebasename (match-string 1 file))
     (setq link-name (concat default-directory "/" filebasename ".org"))
     (setq target-name (concat "./." filebasename ".org/" filebasename ".org" )) ;; relative path to org file in hidden folder
     (when (not (file-exists-p link-name))
       (make-symbolic-link target-name link-name)
       )
     )
   )


(defun create-symlinks-for-all-hidden-org-file-folders (&optional path)
   (interactive)
   ;; process opt. arg
   (when (not path)
     (setq path (get-current-path))
     )

    ;; later restore default-directory (don t know if necessary...)
   (setq original-default-directory default-directory)
   (cd path)
   (setq files (directory-files default-directory))
   (setq N (length files))
   (setq i 0)
   (while (< i N)
     (setq file (nth i files))
     (when (file-directory-p file)
       (when (string-match "^\..*\.org$" file)
         (setq orgfilefolder-full (concat default-directory "/" file))
         (create-symlink-for-hidden-org-file-folder orgfilefolder-full)
         ;; (setq filebasename (match-string 1 file))
         ;; (setq link-name (concat default-directory "/" filebasename ".org"))
         ;; (setq target-name (concat "./." filebasename ".org/" filebasename ".org" )) ;; relative path to org file in hidden folder
         ;; (when (not (file-exists-p link-name))
         ;;   (make-symbolic-link target-name link-name)
         ;;   )
         )
       )
     (setq i (1+ i))
     )
   (cd original-default-directory)
)


(defun delete-all-symbolic-links (&optional path)
  (interactive)
   (when (not path)
     (setq path (get-current-path))
     )

    ;; later restore default-directory (don t know if necessary...)
   (setq original-default-directory default-directory)
   (cd path)
   (setq files (directory-files default-directory))
   (setq N (length files))
   (setq i 0)
   (while (< i N)
     (setq file (nth i files))
     (when (file-symlink-p file)
       (delete-file file)
       )
     (setq i (1+ i))
     )
   (cd original-default-directory)
   )

(defun create-hidden-org-file-folder-with-symlink (&optional filename)
   (interactive)
   (if (not filename)
       (setq filename (read-string "Org-file-name (without .org-extension):"))
     )
   ;; create dot-folder (above function)
   (dired-create-org-file-hidden-folder)
   ;; create softlink --> discarded, see above
   (setq target-name (concat "./." filename ".org/" filename ".org" )) ;; relative path to org file in hidden folder
   (setq link-name (concat currentpath "/" filename ".org"))
   (make-symbolic-link target-name link-name)
)

(defun get-current-path ()
  (interactive)
  (cond ( (equal major-mode 'dired-mode)
	      (setq currentpath (dired-current-directory))
	)
	( (equal major-mode 'term-mode)
	     (setq currentpath default-directory)
	)
	(t ;; else
	     (setq currentpath (file-name-directory buffer-file-name))
	)
   )
 currentpath)

(defun dired-create-new-empty-file ()
   (interactive)
   ;; create the hidden (dotted) folder with same name of org file
   (setq filename (read-string "file-name:"))
   (setq file-full-name (concat  (dired-current-directory) "/" filename))
   (with-temp-buffer (write-file file-full-name))
)
;; make sure emacs visits the target of a link (otherwise currentpath is wrong -> problem with pasting images)
(setq find-file-visit-truename t)

(setq org-image-actual-width 300) ;; --> makes images more readable, for closer look, just open in image viewer


;;** emphasis markers
;; (setq org-hide-emphasis-markers t)                            
(setq org-emphasis-alist   
(quote (("*" bold)
("/" italic)
("_" underline)
("=" (:foreground "white" :background "red"))
("~" org-verbatim verbatim)
("+"
(:strike-through t))
))) 

;;** add some new labels
(setq org-todo-keywords
  '((sequence "TODO"
      "CURRENT..."
      "WAITING"
      "QUESTION"
      "ANSWERED"
      "DONE"
      "DEFERRED"
      "CANCELLED")))

  (setq org-todo-keyword-faces
    '(("PROJ" :background "blue" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("TODO" :background "red1" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("QUESTION" :background "orange" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("NEXT" :background "red1" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("CURRENT..." :background "orange" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("WAITING" :background "yellow" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("DEFERRED" :background "gold" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("DELEGATED" :background "gold" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("MAYBE" :background "gray" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("APPT" :background "red1" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("DONE" :background "forest green" :weight bold :box (:line-width 2 :style released-button))
      ("ANSWERED" :background "forest green" :weight bold :box (:line-width 2 :style released-button))
      ("CANCELLED" :background "lime green" :foreground "black" :weight bold :box (:line-width 2 :style released-button))))


;; evil org-mode
;; (evil-leader/set-key-for-mode 'org-mode "l" 'org-preview-latex-fragment)
(evil-leader/set-key "l" 'org-preview-latex-fragment) 

;;** basic behaviour - new headings
(defun myorg-new-heading-enter-insert-state ()
  (interactive)
  (org-insert-heading-respect-content)
  (evil-insert-state)
  )

(setq org-blank-before-new-entry
      '((heading . nil)
       (plain-list-item . auto)))

(defun myorg-meta-return-enter-insert-state ()
  (interactive)
  (org-meta-return)
  (evil-insert-state)
  )

;;** basic navigation, consistent evil
(evil-define-key 'normal org-mode-map (kbd "L") 'org-shiftright)
(evil-define-key 'normal org-mode-map (kbd "RET") 'myorg-new-heading-enter-insert-state)
(evil-define-key 'insert org-mode-map (kbd "M-RET") 'myorg-meta-return-enter-insert-state)
(evil-define-key 'normal org-mode-map (kbd "M-RET") 'myorg-meta-return-enter-insert-state)
(evil-define-key 'normal org-mode-map (kbd "H") 'org-shiftleft)
(evil-define-key 'normal org-mode-map (kbd "K") 'org-shiftup)
(evil-define-key 'normal org-mode-map (kbd "J") 'org-shiftdown)

;;exception: M-h/j/k/l are reserved for window-management --> map to C-h/j/k/l
(evil-define-key 'normal org-mode-map (kbd "C-l") 'org-metaright)
(evil-define-key 'normal org-mode-map (kbd "C-h") 'org-metaleft)
(evil-define-key 'normal org-mode-map (kbd "C-k") 'org-metaup)
(evil-define-key 'normal org-mode-map (kbd "C-j") 'org-metadown)

(evil-define-key 'insert org-mode-map (kbd "C-l") 'org-metaright)
(evil-define-key 'insert org-mode-map (kbd "C-h") 'org-metaleft)
(evil-define-key 'insert org-mode-map (kbd "C-k") 'org-metaup)
(evil-define-key 'insert org-mode-map (kbd "C-j") 'org-metadown)

;; (evil-define-key 'normal org-mode-map (kbd "left") 'dummy-message)
(defun dummy-message ()
  (interactive)
  (message "this is a message from dummy-message")
  )

(evil-define-key 'normal org-mode-map (kbd "M-L") 'org-shiftmetaright)
(evil-define-key 'normal org-mode-map (kbd "M-H") 'org-shiftmetaleft)
(evil-define-key 'normal org-mode-map (kbd "M-K") 'org-shiftmetaup)
(evil-define-key 'normal org-mode-map (kbd "M-J") 'org-shiftmetadown)

(evil-leader/set-key-for-mode 'org-mode "*" 'org-toggle-heading)
(evil-leader/set-key-for-mode 'org-mode "8" 'org-toggle-heading) ;; lazy, 8 for *


;; new emphasis-markers
(setq org-hide-emphasis-markers t)
(add-to-list 'org-emphasis-alist
             '("^" (:foreground "red")
               ))


;;;* term / terminal / ansi-term
;;** use my own term version: stickyterm (slightly modified ansi-term)
(require 'term) ;; stickyterm builds on /requires term (variables etc. -> load term before
 (load "stickyterm.el")
 (global-set-key (kbd "<f12>") 'stickyterm-noninteractive)

(require 'term)
;; (if color-theme-buffer-local-switch
 (add-hook 'term-mode-hook
           (lambda nil (color-theme-buffer-local 'color-theme-dark-laptop (current-buffer))))
 ;; )

 (add-hook 'term-mode-hook
           (lambda nil (display-line-numbers-mode -1)))

;;** short cut for term-paste
 (evil-define-key 'normal term-raw-map (kbd "p") 'term-paste)
 (evil-define-key 'normal term-raw-map (kbd "C-p") 'term-paste)
 (evil-define-key 'emacs term-raw-map (kbd "C-p") 'term-paste)
 (evil-define-key 'instert term-raw-map (kbd "C-p") 'term-paste)

;;** switch only between (term char with emacs-state) and (term line with normal-state)
 (evil-define-key 'emacs term-raw-map (kbd "C-/") 'term-switch-line-mode-normal-state)
 (evil-define-key 'normal term-raw-map (kbd "C-/") 'term-switch-line-mode-normal-state) ;; this is just to not get undesired error messages when repeating

(evil-leader/set-key-for-mode 'term-mode "j" 'term-line-mode)
;; (evil-leader/set-key-for-mode 'term-mode "k" 'term-char-mode) 
(evil-leader/set-key-for-mode 'term-mode "k" 'term-switch-char-mode-emacs-state) 

(defun term-switch-line-mode-normal-state()
  (interactive)
  (evil-normal-state)
  (term-line-mode)
  )

(defun term-switch-char-mode-emacs-state()
  (interactive)
  (evil-emacs-state)
  (term-char-mode)
  )

;;** evil term
 (evil-define-key 'normal term-raw-map (kbd "RET") 'term-send-raw)
 (evil-define-key 'normal term-raw-map (kbd "h") 'term-send-left)
 (evil-define-key 'normal term-raw-map (kbd "l") 'term-send-right)
 (evil-define-key 'normal term-raw-map (kbd "k") 'term-send-up)
 (evil-define-key 'normal term-raw-map (kbd "j") 'term-send-down)
 (evil-define-key 'normal term-raw-map (kbd "x") 'term-send-del)

;;*** make initial state for term emacs-state
;; this did not work:
 ;; (add-hook 'term-mode-hook
           ;; (lambda nil (evil-emacs-state)))
;; this did work:
(evil-set-initial-state 'term-mode 'emacs)

;; +) tramp connection to hlrn (fast command)
(load "hlrn_tramp_connect.el")
;; --> includes hlrn_tramp_home / hlrn_tramp_work1 / hlrn_tramp_work2


;;; +) save minibuffer history for future sessions
(savehist-mode 1)

;; +) move buffers
(load "buffer-move.el")
;; To use it, simply put a (require 'buffer-move) in your ~/.emacs and
 (require 'buffer-move)
;; define some keybindings. For example, i use :

;; (global-set-key (kbd "<C-S-up>")     'buf-move-up)
;; (global-set-key (kbd "<C-S-down>")   'buf-move-down)
;; (global-set-key (kbd "<C-S-left>")   'buf-move-left)
;; (global-set-key (kbd "<C-S-right>")  'buf-move-right)

;; +) windows stuff

;;  -) undo-/ redo window configuration
(winner-mode 1)
;;  -) resize windows

;; VARI
(global-set-key (kbd "<C-S-up>")     'enlarge-window)
(global-set-key (kbd "<C-S-down>")   'shrink-window)
(global-set-key (kbd "<C-S-left>")   'shrink-window-horizontally)
(global-set-key (kbd "<C-S-right>")  'enlarge-window-horizontally)


(defvar iresize-mode-map
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "C-p") 'enlarge-window)
    (define-key m (kbd "p") 'enlarge-window)
    (define-key m (kbd "<up>") 'enlarge-window-horizontally)
    (define-key m (kbd "C-n") 'shrink-window)
    (define-key m (kbd "n") 'shrink-window)
    (define-key m (kbd "<down>") 'shrink-window)
    (define-key m (kbd "C-c C-c") 'iresize-mode)
    (define-key m (kbd "<right>") 'enlarge-window-horizontally)
    (define-key m (kbd "<left>") 'shrink-window-horizontally)     
    m))

(define-minor-mode iresize-mode
  :initial-value nil
  :lighter " IResize"
  :keymap iresize-mode-map
  :group 'iresize
  :global global)

;; iresize/evil
;; (evil-define-key 'normal iresize-mode-map (kbd "k") 'enlarge-window)
;; (evil-define-key 'normal iresize-mode-map (kbd "j") 'shrink-window)
;; (evil-define-key 'normal iresize-mode-map (kbd "l") 'enlarge-window-horizontally)
;; (vil-define-key 'normal iresize-mode-map (kbd "h") 'shrink-window-horizontally)

(evil-define-minor-mode-key 'normal 'iresize-mode (kbd "k") 'enlarge-window)
(evil-define-minor-mode-key 'normal 'iresize-mode (kbd "j") 'shrink-window)
(evil-define-minor-mode-key 'normal 'iresize-mode (kbd "l") 'enlarge-window-horizontally)
(evil-define-minor-mode-key 'normal 'iresize-mode (kbd "h") 'shrink-window-horizontally)

(provide 'iresize)

;;  -) create new big window (my-split- ... functions)
(defun my-split-root-window (size direction)
  (split-window (frame-root-window)
                (and size (prefix-numeric-value size))
                direction))

(defun my-split-root-window-below (&optional size)
  (interactive "P")
  (my-split-root-window size 'below))

(defun my-split-root-window-right (&optional size)
  (interactive "P")
  (my-split-root-window size 'right))

(defun my-split-root-window-left (&optional size)
  (interactive "P")
  (my-split-root-window size 'left))

;;;
;;(require 'ivy)
;;(load "recent_dirs.el")



;; +) copy under linux ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq x-select-enable-clipboard t)
;(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

;; +) keyboard
(require 'iso-transl)  ;; US-International auf Linux, sonst funzen dead keys nicht, fur quotes etc.


;;+) AUTOMATIC PACKAGE INSTALLATION ;; LIST ALL PACKAGES HERE ;;;
;-------------------------------------------------------------------
;;;;;;; DID NOT WORK ... ;;;;;;;;;;;;;;;;;;;;;
;; list the packages you want





;;;;;;;;;;;;;;;;;;;  adjust status bar appearance (mode line)
;;;;;;;;;
    ;; (setq mode-line-format
    ;;       (list
    ;;        ;; value of `mode-name'
    ;;        "%m: "
    ;;        ;; value of current buffer name
    ;;        "buffer %b, "
    ;;        ;; value of current line number
    ;;        "line %l \n"
    ;;        "-- user: "
    ;;        ;; value of user
    ;;        (getenv "USER")))
;;(require 'uniquify) ;; give buffer name part of path --> distinguish files with same names
;;(setq uniquify-buffer-name-style 'forward) ;;forward accomplishes this



;;;*) CHOOSE COLOR THEMES ;;;;;;;;;;;;;
(color-theme-initialize) ;;; must first initialize (otherwise color-theme-buffer-loccal --> not working)

(require 'color-theme)
(setq color-theme-is-global nil)
;; (color-theme-aalto-light)
;;(load-theme 'leuven)
(add-to-list 'custom-theme-load-path "emacs-leuven-theme")
(load-theme 'zenburn t)

;; instruction:
;; add mode hook with color theme
;; Tipp: find out mode name of a buffer with e.g.: (buffer-local-value 'major-mode (get-buffer "*ansi-term*"))
(require 'color-theme-buffer-local)
;; use the following as templates


(if color-theme-buffer-local-switch
    (add-hook 'text-mode-hook
              (lambda nil (color-theme-buffer-local 'color-theme-feng-shui (current-buffer))))
  )
;; (add-hook 'after-change-major-mode-hook  --> not working as default color --> produced mess in ansi-term
;;      (lambda nil (color-theme-buffer-local 'color-theme-aalto-light (current-buffer))))


;; strange arrow up/down error --> outcommented
(if color-theme-buffer-local-switch
    (add-hook 'c++-mode-hook
      (lambda nil (color-theme-buffer-local 'color-theme-aalto-light (current-buffer))))
)

(if color-theme-buffer-local-switch
(add-hook 'dired-mode-hook
          (lambda nil (color-theme-buffer-local 'color-theme-classic (current-buffer))))
)

(if color-theme-buffer-local-switch
(add-hook 'dired-mode-hook
   (lambda nil (color-theme-buffer-local 'color-theme-charcoal-black (current-buffer))))
)

(defun mydefault-buffer-local-theme () ;; 
   (interactive)
(color-theme-buffer-local 'color-theme-aalto-light (current-buffer))
)
;; (global-unset-key (kbd "<f10>") 'mydefault-buffer-local-theme) ;; work around because default color was strange in cygwin-emacs-nw --> just press f10 when color is strange

;;; END CHOOSE COLOR THEMES ;;;;;



;;; WINDOW / BUFFER NAVIGATION STUFF ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; *) copy/paste path between buffers (terminal/dired)
(load "copy-paste-paths.el")
(evil-add-hjkl-bindings dired-mode-map 'emacs) 
;; copy current path key bindings
(global-set-key (kbd "<f1>") 'copy-current-path)
(require 'dired)
(define-key dired-mode-map (kbd "<f1>") 'copy-current-path) 

(global-set-key (kbd "<f2>") 'change-dir-from-clipboard)
(define-key dired-mode-map (kbd "<f2>") 'change-dir-from-clipboard)

;; copy current filename (e.g. execute in matlab command window)
(global-set-key (kbd "<f9>") 'copy-current-file-name-no-extension)



                
(setq dired-recursive-copies 'always)
(setq dired-dwim-target t) ;; do what i mean --> automatic "inteligent" copy location etc.

;;; *) quickly move buffer to another window
(load "quickly-move-buffer-to-other-window.el")
;; copy current path key bindings
(global-set-key (kbd "<f3>") 'get-this-buffer-to-move)
(require 'dired)
(define-key dired-mode-map (kbd "<f3>") 'get-this-buffer-to-move) 

(global-set-key (kbd "<f4>") 'switch-to-buffer-to-move)
(define-key dired-mode-map (kbd "<f4>") 'switch-to-buffer-to-move) 


;; .) disable the "nerviges/sinnloses" automatic copy-path of other dired buffer (especially when renaming)
;;    (this was suppose to "help" when performing copy / rename etc. operations in mini-buffer, so you would not have to type the location manually but get some "intelligent guess" from clipboard, BUT:
;;    this is obsolete with dired-ranger --> much better copy/paste workflow)
(setq dired-dwim-target nil)


;;;* dired

;;** hide details by default
(add-hook 'dired-mode-hook
          (lambda ()
            (dired-hide-details-mode)
            (display-line-numbers-mode -1)
            (dired-sort-toggle-or-edit)))


;;** dired omit files
(require 'dired-x)
  (defun dired-dotfiles-toggle ()
    "Show/hide dot-files"
    (interactive)
    (when (equal major-mode 'dired-mode)
      (if (or (not (boundp 'dired-dotfiles-show-p)) dired-dotfiles-show-p) ; if currently showing
	  (progn 
	    (set (make-local-variable 'dired-dotfiles-show-p) nil)
	    (message "h")
	    (dired-mark-files-regexp "^\\\.")
	    (dired-do-kill-lines))
	(progn (revert-buffer) ; otherwise just revert to re-show
               (set (make-local-variable 'dired-dotfiles-show-p) t)))))
;;** add option to list directories first
;;(setq dired-listing-switches "-aBhl  --group-directories-first")

;; easy open with external applications
(require 'openwith)
(openwith-mode t)
(setq openwith-associations '(("\\.pdf\\'" "okular" (file))))

;; ;;; *) dired "options" (minor-modes)
;; ;;;--------------------------------------------
;; ;;    .) open recent directories
;; (global-set-key (kbd "C-x C-d") 'dired-recent-dirs-ivy-bjm) ;; see definition recent_dirs.el


;; DIRED+ STUFF -> no longer officially supported MELPA (security reasons) --> outcommented
;;  (https://emacs.stackexchange.com/questions/38553/dired-missing-from-melpa)
;; ;;    .) reuse buffer,  don't open always new buffer when 
;;(require 'dired+) ;; was "somehow" necessary, otherwise not "launched"
;; ;;;   .) reuse buffer when clicking on directory
;; (diredp-toggle-find-file-reuse-dir 1)
;; (define-key dired-mode-map (kbd "<mouse-2>") 'diredp-mouse-find-file) 


;; ;;   .) toggle sudo-rights
;; (require 'dired-toggle-sudo)
;; (define-key dired-mode-map (kbd "C-c C-s") 'dired-toggle-sudo)
;; (eval-after-load 'tramp
;;  '(progn
;;     ;; Allow to use: /sudo:user@host:/path/to/file
;;     (add-to-list 'tramp-default-proxies-alist
;; 		  '(".*" "\\`.+\\'" "/ssh:%h:"))))

;;** dired short cut -> "go home"
(defun dired-go-home ()
  (interactive)
  (dired "~")
  )

(evil-leader/set-key "h" 'dired-go-home)

;;    .) auto revert dired default
(add-hook 'dired-mode-hook 'auto-revert-mode)

;;    .) don't confirm deletion on every
      (setq dired-recursive-deletes 'always)

;; ;;;   .) add icons
;; ;;(require 'dired-icon)
;; ;;(add-hook 'dired-mode-hook 'dired-icon-mode)


;; ;; go up directory with backspace
(define-key dired-mode-map (kbd "<DEL>") 'dired-up-directory)

;; ;; quickly choose files by letters

;; dired-narrow was not so handy.. this was not soo effective...
;; todo -> better solution (maybe use / ? evil like to simply search)
;; (require 'dired-narrow)
;; (define-key dired-mode-map (kbd "<SPC>") 'dired-narrow)


;; ;;; dired ranger key's - nicely copy/paste files/dirs
(require 'dired-ranger)
 (define-key dired-mode-map (kbd "W") 'dired-ranger-copy)
 (define-key dired-mode-map (kbd "X") 'dired-ranger-move)
 (define-key dired-mode-map (kbd "Y") 'dired-ranger-paste)


;; function to quickly open a buffer's directory (or home if there is no meaningful directory like for *scratch*)
(defun dired-go-current-buffer ()
   (interactive)
       (dired default-directory)
  )

;;; evil dired - (results in mixture of evil and dired, evil: gg,G,/,?,yy,v  , dired, s,m,W,X,Y, etc.)
 (evil-define-key 'normal dired-mode-map (kbd "W") 'dired-ranger-copy)
 (evil-define-key 'normal dired-mode-map (kbd "X") 'dired-ranger-move)
 (evil-define-key 'normal dired-mode-map (kbd "Y") 'dired-ranger-paste)

  (evil-define-key 'normal dired-mode-map (kbd "<DEL>") 'dired-up-directory)
  ;; (evil-define-key 'normal dired-mode-map "l" 'dired-find-alternate-file)
 ;; (evil-define-key 'normal dired-mode-map "o" 'dired-sort-toggle-or-edit)
  (evil-define-key 'normal dired-mode-map "s" 'dired-sort-toggle-or-edit)
  (evil-define-key 'normal dired-mode-map "(" 'dired-hide-details-mode)
  (evil-define-key 'normal dired-mode-map "m" 'dired-mark)
  (evil-define-key 'normal dired-mode-map "o" 'dired-mark)
  (evil-define-key 'normal dired-mode-map "u" 'dired-unmark)
  (evil-define-key 'normal dired-mode-map "U" 'dired-unmark-all-marks)
  (evil-define-key 'normal dired-mode-map "+" 'dired-create-directory)
  (evil-define-key 'normal dired-mode-map "n" 'evil-search-next)
  (evil-define-key 'normal dired-mode-map "N" 'evil-search-previous)
  (evil-define-key 'normal dired-mode-map "q" 'kill-this-buffer)


;; *)  by hitting enter -> exit narrow-mode and enter file/dir
;; --------------------------------------------------------------------
;; ;;; (quick and dirty way)
;; ;; source: http://oremacs.com/2015/07/16/callback-quit/

;; ;;; adjust some stuff for dired-narrow work-flow:
;; ;;; this macro is necessary (don't understand but ok...)

;; (defmacro dired-narrow-quit-and-run (&rest body)
;;   "Quit the minibuffer and run BODY afterwards."
;;   `(progn
;;      (put 'quit 'error-message "")
;;      (run-at-time nil nil
;;                   (lambda ()
;;                     (put 'quit 'error-message "Quit")
;;                     ,@body))
;;      (minibuffer-keyboard-quit)))

;; ;;
;; (defun dired-narrow-quit-and-enter-file-or-dir ()
;;    (interactive)
;;        (dired-narrow-quit-and-run
;;           (dired-find-file)  ;; <--- put here what you wanna do after exiting from dired-narrow
;;         )
;;      (user-error
;;       "Not completing files currently")
;;   )

;; (define-key dired-narrow-map (kbd "<return>") 'dired-narrow-quit-and-enter-file-or-dir)
;; (define-key dired-narrow-map (kbd "RET") 'dired-narrow-quit-and-enter-file-or-dir)
;; (define-key dired-narrow-map (kbd "C-e") 'exit-minibuffer)

;; ;; however the RET key by default is used to actually: start operating on the filtered files
;; ;; --> define another key for that


;; (define-key dired-narrow-map (kbd "<SPC>") 'exit-minibuffer)






;; ;; (defun exit-minibuffer-and-diredp-find-file-reuse-dir-buffer ()
;; ;;   (interactive)
;; ;;   (exit-minibuffer)
;; ;;   (diredp-find-file-reuse-dir-buffer)
;; ;; )

;; (define-key dired-narrow-map (kbd "RET") 'dired-narrow-quit-and-enter-file-or-dir)


;;;; END DIRED STUFF ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; ;; open external application
;; ;; --> did work very badly / produced bugs
;; ;;   (require 'openwith)
;; ;;   (openwith-mode t)
;; ;;;*) save desktop sessions
;; ;;    (require 'session)
;; ;;    (add-hook 'after-init-hook 'session-initialize)
;; ;;(desktop-save-mode 1)


;;;*)  make possible for window to "stick" to its buffer
(define-minor-mode sticky-buffer-mode
  "Make the current window always display this buffer."
  nil " sticky" nil
  (set-window-dedicated-p (selected-window) sticky-buffer-mode))

;;; .) set ansi-term buffers sticky

;; ..) this did not work! because at this point no window still exists: see discussion:  https://stackoverflow.com/questions/24152863/how-do-i-configure-emacs-to-dedicate-the-calculator-window
;;(add-hook 'term-mode-hook 'sticky-buffer-mode)
;; OR
;;(add-hook 'term-mode-hook
;;     (lambda () (sticky-buffer-mode)))
;; ..) this also did not work! use advice function (see above thread and translate to modern elisp by seeing: https://www.gnu.org/software/emacs/manual/html_node/elisp/Porting-old-advice.html#Porting-old-advice
;; (defun ansi-term--after ()
;;   "Make the *ansi-term* window dedicated."
 ;;  (let ((win (get-buffer-window "*ansi-term*")))
 ;;    (when win
   ;;      (set-window-dedicated-p win t))))
 ;;  (set-window-dedicated-p  (get-buffer-window "*ansi-term*") t))
;;)
;;   (advice-add 'ansi-term :after 'ansi-term--after)

;;; .) this worked! :
;;       *  manipulated the ansi-term function in term.el
;;       * included a (sticky-buffer-mode) there
;;       * deleted the term.elc file (not sure if this was necessary)
;;       * renamed to mod_term.el and put to my load path (on dropbox)
;;       * --> this effectively overwrites the usual term.el
;;       * --> available for all my emacs computers



;;;*) copy current buffer path clipboard
(defun cp-fullpath-of-current-buffer ()
  "copy full path into clipboard"
  (interactive)
  (when buffer-file-name
    (setq filepath (file-name-directory buffer-file-name))
    (kill-new  filepath)
    (message (concat "copied current file path: " filepath   ))))

;;;*) ido-mode
;; (require 'ido)
    ;; (ido-mode t)


;; *) HELM
(require 'helm)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(setq helm-full-frame t)
;; (setq helm-display-function 'helm-display-buffer-in-own-frame
;;         helm-display-buffer-reuse-frame nil
;;         helm-use-undecorated-frame-option nil)

;; *) helm window --> formatting
(setq shackle-rules '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :ratio 0.4)))
;; file name column width
(setq helm-buffer-max-length 70)


;;; *) projectile
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)
(setq projectile-indexing-method 'native)  
(setq projectile-enable-caching t) 
(setq helm-exit-idle-delay 0)


;;;* matlab


;;;** Matlab matlab-emacs project;;
load-path
(setq path_to_matlab_emacs (concat my_load_path "matlab-emacs-src")) ;; the init file folder contains also all manual packages
(add-to-list 'load-path path_to_matlab_emacs)
(load-library "matlab-load")
(load-library "matlab")

(matlab-cedet-setup)

(add-hook 'matlab-mode-hook
 	     (lambda nil (auto-complete-mode)))

(add-hook 'M-shell-mode-hook
 	     (lambda nil (company-mode)))

;; ;; turn off auto-fill-mode
;; ;; (still does not work --> todo)

(add-hook 'matlab-mode-hook
 	     (lambda nil (auto-fill-mode -1)))


;; tweak matlab key map 
(define-key matlab-mode-map "\M-j" 'windmove-down)



;;; MATLAB comodity things
(defun send-string-to-matlab-shell-buffer-and-execute (sendstring)
  "execute region line by line in interactive shell (buffer *shell*)."
  (interactive)
    ; get region into string
    (save-excursion
      (set-buffer (get-buffer-create "*MATLAB*")) 
     (end-of-buffer)
     (insert (concat sendstring))
     (comint-send-input) ;; execute
     (end-of-buffer)
;;       (set-buffer (get-buffer-create "*MATLAB*")) 
;;      (end-of-buffer)
;;      (insert (concat scriptname))
;;      (comint-send-input) ;; execute
;;      (end-of-buffer)
    )
    ;; if executed within matlab-shell buffer --> move end of buffer
    (if (string-equal (buffer-name) "*MATLAB*")
        (end-of-buffer)
    )
)

(defun matlab-shell-end-of-buffer ()
  (interactive)
    ; get region into string
    ;; (save-excursion
      ;; (set-buffer (get-buffer-create "*MATLAB*")) 
      (switch-to-buffer "*MATLAB*")
     ;; (end-of-buffer)
    ;; )
)
;; alternative 1 --> but has to be launched from script 
;; (defun send-scriptname-to-shell-buffer-and-execute ()
;;   (interactive)
;;   (save-buffer)
;;     ; get script name (has to be done before save-excursion, since he then quits buffer)
;;     (setq scriptname (file-name-nondirectory (file-name-sans-extension (buffer-file-name))))
;;     (save-excursion
;;       (set-buffer (get-buffer-create "*MATLAB*")) 
;;      (end-of-buffer)
;;      (insert (concat scriptname))
;;      (comint-send-input) ;; execute
;;      (end-of-buffer)
;;     )
;;     ;; if executed within matlab-shell buffer --> move end of buffer
;;     (matlab-shell-end-of-buffer)
;;     ;; (if (string-equal (buffer-name) "*MATLAB*")
;;         ;; (end-of-buffer)
;;     ;; )
;; )

;; (alternative)
(defun send-scriptname-to-matlab-shell-buffer-and-execute ()
  "execute "
  (interactive)
  (setq this-buffer-filename-base (file-name-base (buffer-file-name)))
  (send-string-to-matlab-shell-buffer-and-execute this-buffer-filename-base)
)


(defun send-current-line-to-matlab-shell-buffer-and-execute ()
  (interactive)
  (move-beginning-of-line nil)
  (setq beginofline (point))
  (move-end-of-line nil)
  (setq endofline (point))
  (setq currentlinestring (buffer-substring beginofline endofline))

  (send-string-to-matlab-shell-buffer-and-execute currentlinestring)
)


(defun send-current-region-to-matlab-shell-buffer-and-execute ()
(interactive)
    (setq region_string (buffer-substring (mark) (point)))
    (send-string-to-matlab-shell-buffer-and-execute region_string)
)

(defun send-variable-at-cursor-matlab-shell-buffer-and-execute ()
(interactive)
    (setq variable_name (thing-at-point 'symbol))
    (send-string-to-matlab-shell-buffer-and-execute variable_name)
)

(defun send-current-region-line-by-line-to-matlab-shell-buffer-and-execute ()
(interactive)
   (save-excursion
     ; get line numbers of region beginning/end
     (setq beginning_line_number (line-number-at-pos (region-beginning)))
     (setq ending_line_number (line-number-at-pos (region-end)))
  
    ;; (message (format "%i" beginning_line_number) )
    ;; (message (format "%i" ending_line_number) )
    (setq current_line_number beginning_line_number)
    (goto-line beginning_line_number)
    ;(message (format "%i" current_line_number) )
      (while (< current_line_number (- ending_line_number 1))
          (send-current-line-to-matlab-shell-buffer-and-execute)
          ;; (message (format "%i" current_line_number) )
          (setq current_line_number (line-number-at-pos (point)))
          (forward-line)
      )
    )
)

(defun send-current-line-or-region-line-by-line-to-matlab-shell-buffer-and-execute ()
(interactive)
   (if (use-region-p)
     (send-current-region-line-by-line-to-matlab-shell-buffer-and-execute)
     (send-current-line-to-matlab-shell-buffer-and-execute)
   )
)


(defun matlab-dbstep()
  (interactive)
  (send-string-to-matlab-shell-buffer-and-execute "dbstep")
  ;; (matlab-jump-to-current-debug-position) ;; --> this was not working fluently
  ;; --> instead: assume were still in the same file and procede to new line
  ;; (sleep-for 10)
  ;; (message "sleeping ...")
  ;; (call-process "sleep" nil nil nil "1")
  ;; (message "finished ...")
  (matlab-get-jump-new-line-number-from-last-debug-output)
)

(defun matlab-dbcont()
  (interactive)
  (send-string-to-matlab-shell-buffer-and-execute "dbcont")
)

(defun matlab-set-breakpoint-current-line()
  (interactive)
  ; get line number
  (setq line-nr (number-to-string (line-number-at-pos)))
  ; get file name without ".m" extension
 (setq filename-base (file-name-base (buffer-file-name)))
  (send-string-to-matlab-shell-buffer-and-execute (concat "dbstop " filename-base " at " line-nr))
)


(defun matlab-dbclear-all()
  (interactive)
  (send-string-to-matlab-shell-buffer-and-execute "dbclear all")
)

(defun matlab-dbquit()
  (interactive)
  (send-string-to-matlab-shell-buffer-and-execute "dbquit")
)

(defun matlab-dbclear-current-file()
  (interactive)
  (setq filename-base (file-name-base (buffer-file-name)))
  (send-string-to-matlab-shell-buffer-and-execute (concat "dbclear " filename-base))
)

(defun matlab-get-jump-new-line-number-from-last-debug-output ()
  (interactive)
  (save-excursion
    ; go to matlab shell buffer
    (set-buffer (get-buffer-create "*MATLAB*")) 
    ; get last line of debug output
    (end-of-buffer)
    (forward-line -1) ; first move up one line
    (move-beginning-of-line nil)
    (setq beginofline (point))
    (move-end-of-line nil)
    (setq endofline (point))
    (setq line-string (buffer-substring beginofline endofline))
    (message line-string)
    ; extract the file-name and line-nr
    (string-match "\\([0-9][0-9]*\\) .*" line-string)
    (setq line-nr (match-string 1  line-string)) ; group 1
    )
    (goto-line (string-to-number line-nr))
  )


(defun matlab-jump-to-current-debug-position ()
  (interactive)
  ;; (sleep-for 0.1)
  ;; produce current debug position information
  (send-string-to-matlab-shell-buffer-and-execute "dbstack")
  ;; get the line nr and file name
  (save-excursion
    ; go to matlab shell buffer
    (set-buffer (get-buffer-create "*MATLAB*")) 
    ; get last line of debug output
    (forward-line -1) ; first move up one line
    (move-beginning-of-line nil)
    (setq beginofline (point))
    (move-end-of-line nil)
    (setq endofline (point))
    (setq line-string (buffer-substring beginofline endofline))
    ; extract the file-name and line-nr
    ;;       e.g. "> In script1 (line 99)" --> return "script1" (group 1) and "99" (group 2)
    (setq finished nil)
    (while (not finished)
           (forward-line -1) ;line up
           (move-beginning-of-line nil)
           (setq beginofline (point))
           (move-end-of-line nil)
           (setq endofline (point))
           (setq line-string (buffer-substring beginofline endofline))

           ;; could be something like this "> In transit/expand (line 82)" --> get "transit"
           (if (string-match "> In \\([^ /]*\\).* (line \\([0-9][0-9]*\\))" line-string)
               (setq finished t)
             )
           )
    (setq filename-base (match-string 1  line-string)) ; group 1
    (setq line-nr (match-string 2  line-string)) ; group 2
    )
  ;; now after exursion / retrieving the information
  ;; --> jump to the position in current buffer
  ;; first, if not already in current-debug-file --> open it in current buffer
  ; get file name base of current buffer
  (setq this-buffer-filename-base (file-name-base (buffer-file-name)))
  (if (not (string-equal this-buffer-filename-base filename-base))
      (find-file (concat filename-base ".m"))
    )
  ;; go to line
  (goto-line (string-to-number line-nr))
  (message (concat "going to current debug position: " filename-base " line: "line-nr))
)
;; MATLAB-DEBUG/RUN SHORT-CUTS (could serve generalistically for other languages)
;; SET BREAKPOINT <F12>
(define-key matlab-mode-map (kbd "<f12>") 'matlab-set-breakpoint-current-line)
;; DEBUG STEP <F10>
(define-key matlab-mode-map (kbd "<f10>") 'matlab-dbstep)
;; DEBUG CONTINUE <F6> (todo--> could be united with F5, detect if in debug process)
(define-key matlab-mode-map (kbd "<f6>") 'matlab-dbcont)
;; RUN script <F5>
(define-key matlab-mode-map (kbd "<f5>") 'send-scriptname-to-matlab-shell-buffer-and-execute)  

;; (define-key matlab-mode-map (kbd "<f9>") 'send-current-line-or-region-line-by-line-to-matlab-shell-buffer-and-execute)
;; DEBUG QUIT <F8>
(define-key matlab-mode-map (kbd "<f8>") 'matlab-dbquit)
;; CLEAR BREAK POINTS current file
(define-key matlab-mode-map (kbd "<f7>") 'matlab-dbclear-current-file)
;; EVALUATE/RUN SELECTION <F9>
(define-key matlab-mode-map (kbd "<f9>") 'send-current-region-to-matlab-shell-buffer-and-execute)
;; EVALUATE/RUN SELECTION <F9>
;; (define-key matlab-mode-map (kbd "<f7>") 'send-variable-at-cursor-matlab-shell-buffer-and-execute)
;; JUMP TO CURRENT DEBUG POS <F11> (todo --> just for now because automatic not working flawlessly)
(define-key matlab-mode-map (kbd "<f11>") 'matlab-jump-to-current-debug-position)
;;; END MATLAB COMODITIES

;; matlab shell key bindings (--> have to be implemented as hooks, since matlab-shell-mode-map does not exist before opening a matlab-shell()
(add-hook 'matlab-shell-mode-hook
          (lambda ()
            (define-key matlab-shell-mode-map (kbd "<f10>") 'matlab-dbstep)
            (define-key matlab-shell-mode-map (kbd "<f8>") 'matlab-dbquit)
            (define-key matlab-shell-mode-map (kbd "<f6>") 'matlab-dbcont)
            ;; set Alt-p for "go up" --> my own 'convenient convention' for all types of command shells
            (define-key matlab-shell-mode-map (kbd "M-p") 'matlab-shell-previous-matching-input-from-input)
            (define-key matlab-shell-mode-map (kbd "M-n") 'matlab-shell-next-matching-input-from-input)
            ))

;; ;; color theme for matlab, defined by my own
;; (load "color-theme-matlab.el")

;; (if color-theme-buffer-local-switch
;;     (add-hook 'matlab-mode-hook
;;       (lambda nil (color-theme-buffer-local 'color-theme-matlab (current-buffer))))
;;   )


;; END GENREAL STUFF ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;* recentf (recent files) 
(require 'recentf)
; Enable recentf mode
(recentf-mode t)
; Show last 10 files
(setq recentf-max-menu-items 10)
; Reset C-x C-r to display recently opened files
(global-set-key "\C-x\ \C-r" 'recentf-open-files)


;;;* latex (auctex) 
;; somehow auctex does not load with (require 'auctex) (i don t like that and think the guys should do loading consistent with standard like other packages, but whatever..)
;; but auctex-manual instructs like this
(load "auctex.el" nil t t)
(load "latex.el" nil t t)
;;(load "preview-latex.el" nil t t)


;;** F5 -> run pdflatex / F6 -> bibtex
(defun run-pdflatex-on-master-file ()
"This function just runs LaTeX (pdflatex in case of TeX-PDF-mode), without asking what command to run everytime."
(interactive)
;;save buffer
(save-buffer)
;;*option1:
(TeX-command "LaTeX" 'TeX-master-file nil)
;;*option2: (discarded)
;; (save-buffer)
;; (shell-command (format "pdflatex %s.tex" (TeX-master-file)))
)

(define-key LaTeX-mode-map (kbd "<f5>") 'run-pdflatex-on-master-file)  
(define-key LaTeX-mode-map (kbd "<f6>") 'run-bibtex-on-master-file)  

(defun run-bibtex-on-master-file ()
"This function just runs LaTeX (pdflatex in case of TeX-PDF-mode), without asking what command to run everytime."
(interactive)
(TeX-command "BibTeX" 'TeX-master-file nil)
)



;;;** how to view pdf (setq TeX-view-program-list '(("Okular" "okular --unique %u")))
(add-hook 'LaTeX-mode-hook '(lambda ()
                  (add-to-list 'TeX-expand-list
                       '("%u" Okular-make-url))))

(defun Okular-make-url () (concat
               "file://"
               (expand-file-name (funcall file (TeX-output-extension) t)
                         (file-name-directory (TeX-master-file)))
               "#src:"
               (TeX-current-line)
               (expand-file-name (TeX-master-directory))
               "./"
               (TeX-current-file-name-master-relative)))

(setq TeX-view-program-selection '((output-pdf "Okular")))

;;;*** setup viewer (okular) with synref
(server-start)
(setq TeX-view-program-selection '((output-pdf "Okular")))
(setq TeX-source-correlate-mode t)


;;;** reftex
     (add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
(setq reftex-plug-into-AUCTeX t)
;;
(setq reftex-cite-format 'natbib)

;;;** aspell
(setq-default ispell-program-name "aspell")
;(setq ispell-program-name "aspell") 
     ; could be ispell as well, depending on your preferences ;
(setq ispell-dictionary "english") ;
     ; this can obviously be set to any language your spell-checking program supports

;; (add-hook 'LaTeX-mode-hook 'flyspell-mode) 
;; (add-hook 'LaTeX-mode-hook 'flyspell-buffer)


;;; flymake
;(require 'flymake)
;
;(defun flymake-get-tex-args (file-name) (list "pdflatex" 
;    (list "-file-line-error" "-draftmode" "-interaction=nonstopmode" file-name)))
;(add-hook 'LaTeX-mode-hook 'flymake-mode)


;;; My personal redefinition of menu-item appearance (before i could not see
  ; the filenames since the path s were so long)
(defsubst recentf-make-default-menu-element (file)
  "Make a new default menu element with FILE.
This a menu element (FILE . FILE)."
  (setq menu-item-string (format "%s" (file-name-nondirectory file)))
  (recentf-make-menu-element menu-item-string file))

;;** misc settings
     (setq TeX-parse-self t) ; Enable parse on load.
     (setq TeX-auto-save t) ; Enable parse on save.
     (setq TeX-save-query nil) ; Dont ask if to save every time, just save and run LaTeX

;;(require 'tex-mik)
(setq TeX-PDF-mode t) ; pdf mode (for preview latex would need to be true, but preview latex currently not used)
	
(setq-default TeX-master nil) ; Query for master file.

;;;** my latex-editing functions
(defun include-input-toggle ()
"This function toggles between include and input"
(interactive)
      (let ((occured) 
                      )
         (save-excursion
              (beginning-of-buffer)
              (while (search-forward "\include{"  nil t)
                     (replace-match "\input{" nil t)
		     (setq occured t)
              )
              (if (eq occured nil)
               (while (search-forward "\input{"  nil t)
                     (replace-match "\include{" nil t)
		     (setq occured t)
                )		 
              )		  
         )
      occured
      )
)
(defun view-with-texworks ()
"This function opens the main pdf file of the LaTeX-project with texworks."
(interactive)
(shell-command "texworks c:/Users/Joe/Documents/Beruf/PUC/'Trabajo de investigacion'/Studienarbeit/Alembic_Final_Report.pdf"))
;; 



(defun eps-convert-all-in-folder ()
  (interactive)
  (setq pnglist (directory-files (file-name-directory buffer-file-name) nil "\\.png"))
  (dolist (pngfile pnglist)
    (setq filename (file-name-sans-extension pngfile))
    (shell-command (format "sam2p %s.png %s.eps" filename filename))
    ;; sam2p image.png image.eps
    )

  (setq jpglist (directory-files (file-name-directory buffer-file-name) nil "\\.jpg"))
  (dolist (jpgfile jpglist)
    (setq filename (file-name-sans-extension jpgfile))
    (shell-command (format "sam2p %s.jpg %s.eps" filename filename))
    ;; sam2p image.jpg image.eps
    )

  (setq pdflist (directory-files (file-name-directory buffer-file-name) nil "\\.pdf"))
  (dolist (pdffile pdflist)
    (setq filename (file-name-sans-extension pdffile))
    (if (not (string-match "eps-converted-to" filename)) ;;unless is conversion of latex's "pdftoeps"-package
	(shell-command (format "sam2p %s.pdf %s.eps" filename filename))
      ;; sam2p image.pdf image.eps
      )
    )
)

(defun eps-convert-file (file)  ;;requires installation and path-variable-entry for "nircmd" program
  (interactive)
  (shell-command (format "sam2p %s %s.eps" file (file-name-sans-extension file)))
)

(defun paste-image-latex ()
(interactive)
(setq label (read-string "Image label and file name: "))
(shell-command (format "nircmd clipboard saveimage %s.png" label))
(eps-convert-file (format "%s.png" label))
(setq caption (read-string "Caption: "))
(setq begin (point)) ;; save beginning
(insert "\\" "begin{figure}[H]\n"
 	"\\" "centering\n"
	"\\" "includegraphics[keepaspectratio, height=150pt]{" label "}\n"
	"\\" "caption{" caption "}\n"
	"\\" "label{fig:" label "}\n"
	"\\" "end{figure}\n" )
(setq end (point)) ;; save end
(preview-region begin end)
)

(global-set-key (kbd "<f9>") 'paste-image-latex)

;;;*** Insert quickly most popular environments by easy short cuts (ctrl-shift-<...>)
(defun insert-latex-environment-align ()
(interactive)
(LaTeX-environment-menu "align")
)
(global-set-key (kbd "C-S-a") 'insert-latex-environment-align)

(defun insert-latex-environment-equation ()
(interactive)
(LaTeX-environment-menu "equation")
)
(global-set-key (kbd "C-S-e") 'insert-latex-environment-equation)

(defun insert-latex-environment-alignstar ()
(interactive)
(LaTeX-environment-menu "align*")
)
(global-set-key (kbd "C-c a") 'insert-latex-environment-alignstar)


(defun insert-latex-environment-alignstar ()
(interactive)
(LaTeX-environment-menu "flalign*")
)
(global-set-key (kbd "C-c f") 'insert-latex-environment-alignstar)


(defun insert-latex-environment-equationstar ()
(interactive)
(LaTeX-environment-menu "equation*")
)
(global-set-key (kbd "C-c e") 'insert-latex-environment-equationstar)



(defun insert-latex-environment-figure ()
(interactive)
   (setq full-image-file-name (read-file-name "Select image file: "))
   (setq bare-image-file-name (file-name-nondirectory (file-name-sans-extension full-image-file-name)))
(setq image-file-name (file-name-nondirectory full-image-file-name))
(setq image-rel-file-name (file-relative-name full-image-file-name default-directory)) 
(eps-convert-file image-file-name);; convert to eps for preview
;;(setq caption (read-string "Caption: "))
(setq begin (point)) ;; save beginning
(insert "\\" "begin{figure}[H]\n"
 	"\\" "centering\n"
	"\\" "includegraphics[keepaspectratio,height=150pt]{" image-rel-file-name "}\n"
	"\\" "caption{ }\n"
	"\\" "label{fig:" bare-image-file-name "}\n"
	"\\" "end{figure}\n" )
(setq end (point)) ;; save end
(reftex-parse-all)  ;; parse reftex so that it can be referred to directly
;(preview-region begin end)
)
(global-set-key (kbd "C-S-f") 'insert-latex-environment-figure)

(defun insert-latex-environment-table ()
(interactive)
(LaTeX-environment-menu "table")
)
(global-set-key (kbd "C-S-t") 'insert-latex-environment-table)

;;* misc

;; quickly add relative path of some file
(defun find-file-insert-relative-path ()
(interactive)
 (setq file-name (read-file-name "Select file: "))
(setq rel-path (file-relative-name file-name))
(insert rel-path)
)



;;;* openfoam 
(defun openfoam-dired-tutorials ()
   (interactive)
   (dired "/opt/OpenFOAM-6/tutorials")
)
(defun openfoam-dired-applications ()
   (interactive)
   (dired "/opt/OpenFOAM-6/applications")
)
(defun openfoam-dired-src ()
   (interactive)
   (dired "/opt/OpenFOAM-6/src")
)

;;Grosses Fazit:
; konnte nicht shell-environment (bash_profile oder bashrc) in emacs-shell-prozess ausfuehren
; hab s nicht hinbekommen login-option mitauszufuehren
; --> Umweg ueber Emacs-interactive *shell*, eigene funktionen kopieren zeilen dort rein und fuehren sie aus
; der ganze andere kram wird nicht mehr gebraucht


; purpose: execute shell-script in emacs line by line with <f3>
; or execute region in script with <f4>
; with emacs invoked shell "knowing" the openfoam environment
; change openfoam version specific environment by changing value of variable ofvers 
; 
; prerequesite: the value of ofvers has to be implemented in ./bashrc as a function that sources the openfoam-version-environment
; e.g. of240() { source /opt/openfoam240/etc/bashrc ; }  
; the alias-method does not work in executed scripts (effectively happening here) and is supposed to be outdated by shell-functions anyway, so better use function
;
; explanation of implementation:
; the function sh-execute-region (defined in the sh-mode) has been modified, in order to not only execute region, but additionally source the openfoam-environment, see below.
; 
; what i learned as background:
" sh-command-on-region          is implemented in sh-mode, uses shell-command-on-region, 
                                with some extra stuff, did not understand this extra stuff
                                but probably is usefull, so i decided to use/modify this function

  shell-command-on-region       uses effectively call-process-region
                                also has some additional stuff, i did not really understand,
                                but prob. usefull, defined in lisp/simple.el

  call-process-region          uses call-process, before creates some temporary file, where all the
                                region is loaded and given as input to call-process

  call-process                  is C-written elementary function, launching a shell-program, executing
                                an input file

  FAZIT: i only had a chance to add sth to the region, because luckily shell-command-on-region can interpret alternatively the first argument start in (start end) as a string, so end will be ignored.
this way i could pack my string together (with concat) and pass it.
so no need to modify the shell-command-on-region or write my own temporary file (write my own call-process-region, ooh my gosh...!)"

(setq ofvers "of240")

(defun sh-execute-region-openfoam (start end &optional flag)
  "Pass optional header and region to a subshell for noninteractive execution.
The working directory is that of the buffer, and only environment variables
are already set which is why you can mark a header within the script.

With a positive prefix ARG, instead of sending region, define header from
beginning of buffer to point.  With a negative prefix ARG, instead of sending
region, clear header."
  (interactive "r\nP")
  (if flag
      (setq sh-header-marker (if (> (prefix-numeric-value flag) 0)
				 (point-marker)))
    (if sh-header-marker
	(save-excursion
	  (let (buffer-undo-list)
	    (goto-char sh-header-marker)
	    (append-to-buffer (current-buffer) start end)
	    (shell-command-on-region (point-min)
				     (setq end (+ sh-header-marker
						  (- end start)))
				     sh-shell-file)
	    (delete-region sh-header-marker end)))
     (setq regionstring (buffer-substring start end)) 
     (setq start (concat ofvers "\n" regionstring) )
     (shell-command-on-region start end "bash -l" ))) ;; If start is a string, then write-region writes or appends that string, rather than text from the buffer. end is ignored in this case. 
)                                      ;;  bash with -l option --> login --> so it will read .bash_profile (--> includes bashrc) --> so the openfoam-environment sourcing functions are known

;;;** shell workflow openfoam
;;; send to noninteractive shell (not "so" usefull, only for whole loops 
(defun sh-execute-line-openfoam ()
(interactive)
(move-beginning-of-line nil)
(setq beginofline (point))
(move-end-of-line nil)
(setq endofline (point))
(sh-execute-region-openfoam beginofline endofline)
)

(defun sh-send-region-to-shell ()
(interactive)
(setq regionstring (buffer-substring (region-beginning) (region-end)))
(setq sendstring (concat regionstring "\n"))
;(message sendstring)
(setq start sendstring)
(append-to-buffer "*shell*" start end)
)


;; modified function from append-to-buffer

(defun send-string-to-shell-buffer-and-execute (sendstring)
  "execute region line by line in interactive shell (buffer *shell*)."
  (interactive)
    ; get region into string
    (save-excursion
      (set-buffer (get-buffer-create "*shell*")) 
     (end-of-buffer)
     (insert sendstring)
     (comint-send-input) ;; execute
     (end-of-buffer)
    )
)

(defun send-scriptname-to-shell-buffer-and-execute ()
  "execute region line by line in interactive shell (buffer *shell*)."
  (interactive)
  (save-buffer)
    ; get script name (has to be done before save-excursion, since he then quits buffer)
    (setq scriptname (file-name-nondirectory (file-name-sans-extension (buffer-file-name))))
    (save-excursion
      (set-buffer (get-buffer-create "*shell*")) 
     (end-of-buffer)
     (insert (concat "./" scriptname))
     (comint-send-input) ;; execute
    )
)

(defun send-current-line-to-shell-buffer-and-execute ()
(interactive)
(move-beginning-of-line nil)
(setq beginofline (point))
(move-end-of-line nil)
(setq endofline (point))
(setq currentlinestring (buffer-substring beginofline endofline))

(send-string-to-shell-buffer-and-execute currentlinestring)
)

(defun send-current-region-line-by-line-to-shell-buffer-and-execute ()
(interactive)
   (save-excursion
     ; get line numbers of region beginning/end
     (setq beginning_line_number (line-number-at-pos (region-beginning)))
     (setq ending_line_number (line-number-at-pos (region-end)))
  
    (setq current_line_number beginning_line_number)
    (goto-line beginning_line_number)
    ;(message (format "%i" current_line_number) )
      (while (< current_line_number ending_line_number)
          (setq current_line_number (line-number-at-pos (point)))
          (message (format "%i" current_line_number) )
          (forward-line)
          (send-current-line-to-shell-buffer-and-execute)
      )
    )
)

(defun send-current-line-or-region-line-by-line-to-shell-buffer-and-execute ()
(interactive)
   (if (use-region-p)
     (send-current-region-line-by-line-to-shell-buffer-and-execute)
     (send-current-line-to-shell-buffer-and-execute)
   )
)

(defun openfoam-shell-keys ()
  (local-set-key (kbd "<f4>") 'send-current-line-or-region-line-by-line-to-shell-buffer-and-execute)
  (local-set-key (kbd "<f5>") 'send-scriptname-to-shell-buffer-and-execute)  
)

(add-hook 'sh-mode-hook 'openfoam-shell-keys)

;; original function (  http://repo.or.cz/w/emacs.git/blob/HEAD:/lisp/progmodes/sh-script.el )
;; (defun sh-execute-region (start end &optional flag)
;;   "Pass optional header and region to  subshell for noninteractive execution.
;; The working directory is that of the buffer, and only environment variables
;; are already set which is why you can mark a header within the script.

;; With a positive prefix ARG, instead of sending region, define header from
;; beginning of buffer to point.  With a negative prefix ARG, instead of sending
;; region, clear header."
;;   (interactive "r\nP")
;;   (if flag
;;       (setq sh-header-marker (if (> (prefix-numeric-value flag) 0)
;; 				 (point-marker)))
;;     (if sh-header-marker
;; 	(save-excursion
;; 	  (let (buffer-undo-list)
;; 	    (goto-char sh-header-marker)
;; 	    (append-to-buffer (current-buffer) start end)
;; 	    (shell-command-on-region (point-min)
;; 				     (setq end (+ sh-header-marker
;; 						  (- end start)))
;; 				     sh-shell-file)
;; 	    (delete-region sh-header-marker end)))
;;       (shell-command-on-region start end (concat sh-shell-file " -")))))

;;** open-foam-workflow tipps 

;;;* zoom frame on smaller monitor
;;;    status: no working solution, but no priority
;; (require 'zoom-frm)


;;;* move buffers - key bindings
(require 'windmove)
(require 'framemove)
(setq framemove-hook-into-windmove t)
(global-set-key (kbd "<C-up>")     'windmove-up)
(global-set-key (kbd "<C-down>")   'windmove-down)
(global-set-key (kbd "<C-left>")   'windmove-left)
(global-set-key (kbd "<C-right>")  'windmove-right)

(global-set-key (kbd "M-k")     'windmove-up)
(global-set-key (kbd "M-j")   'windmove-down)
(global-set-key (kbd "M-h")   'windmove-left)
(global-set-key (kbd "M-l")  'windmove-right)

;; tweak in term-mode, so these also work in term-windows:
 (define-key term-raw-map "\M-k" 'windmove-up)
 (define-key term-raw-map "\M-h" 'windmove-left)
 (define-key term-raw-map "\M-l" 'windmove-right)
 (define-key term-raw-map "\M-j" 'windmove-down)

;; tweek for org-mode, other
(define-key org-mode-map "\M-k" 'windmove-up)
(define-key org-mode-map "\M-h" 'windmove-left)
(define-key org-mode-map "\M-l" 'windmove-right)
(define-key org-mode-map "\M-j" 'windmove-down)

;; evil-like other bindings, that I like
;; hmm.. maybe not yet, might by usefull for other stuff (-> outcommented)
;; (define-key org-mode-map "L" 'org-shiftright)
;; (define-key org-mode-map "H" 'org-shiftleft)
;; (define-key org-mode-map "L" 'org-shiftdown)
;; (define-key org-mode-map "K" 'org-shiftup)
;;    - syntax for key with slash "\M-.." --> see explanation in lisp docu:
;;         https://www.gnu.org/software/emacs/manual/html_node/elisp/Basic-Char-Syntax.html#Basic-Char-Syntax
;;    - the most important thing in term-char-mode is actually the term-raw-map
;;      --> here basically in a for loop for every key, e.g. a (97) is defined that, just this string shall be sent to the shell-process
;;    - this means that exceptions from this are very easy, just add/alter key in term-raw-map
;;    - the exception for the escape key is implemented in just this way actually:
;;      term.el:912   (define-key term-raw-map term-escape-char term-raw-escape-map)
;;      just leads to a second map where a new command can be executed (e.g. M-x)

;;* mode-line appearance
;; set mode line to show full path of current file
;; (setq-default mode-line-format
;;    (list '((buffer-file-name " %f"
;;               (dired-directory
;;                dired-directory
;;                 (revert-buffer-function " %b"
;;                ("%b - Dir:  " default-directory))))))) 
;;; *) set mode line appearance
;;;    (has to come AFTER  color themes, don t ask why)
;; don t ask why exactly, but the following (in order (!)) resulted nice in combi with zenburn
;; i.e.  .) modest visual difference of current buffer's mode line
;;       .) decent layout  
;;       .) harmonic colors with zenburn 
;; (require 'powerline)
;; (require 'smart-mode-line)
;; (sml/setup)
;; (setq sml/no-confirm-load-theme t) ;; avoid being asked "wanna compile theme in elisp" (or so..) everytime


;;* buffer/window navigation management
;;** better short cuts for previous / next buffer
(global-set-key (kbd "M-'") 'previous-buffer)
(global-set-key (kbd "M-\\") 'next-buffer)

;;;* pdf-view
(require 'pdf-view)
 
 (setq pdf-info-epdfinfo-program "/usr/local/bin/epdfinfo")
 
 (setq pdf-view-midnight-colors `(,(face-attribute 'default :foreground) .
                                  ,(face-attribute 'default :background)))
 
 (add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode))
 
 (add-hook 'pdf-view-mode-hook (lambda ()
                                 (pdf-view-midnight-minor-mode)))
 
 (provide 'init-pdfview)


