;; * next todos
;; ** DONE gsyn SPC g ;
;; ** DONE M-hjkl -> windmove
;; ** DONE org-metaup etc. C-h/j/k/l
;; ** DONE planet funs
;; ** DONE quick search replace in region
;; ** DONE [visual-line-mode] line wrapping default (the doom way?)
;; ** DONE visual state - expand on repeat "v"
;; ** TODO check hooks doom way? add-hook or add-hook!
;; ** TODO add CRNT keyword for 'current'
;; ** DONE org variable pitch font
;; ** DONE org no lin nrs
;; ** DONE org latex preview all toggle etc.
;; ** [?] when does doom-emacs load my config.el and why do keybinds get overriden? what s the conceptual solution to that, just ":after org-mode"?

;; * mouse things TODO needed? why?
;; (xterm-mouse-mode 1)
;; (global-set-key [mouse-4] 'scroll-down-line)
;; (global-set-key [mouse-5] 'scroll-up-line)

;; * mac specific
;;
(if IS-MAC (setq mac-command-modifier 'meta))

;; * leader ; -> M-x
;;   leader : -> eval-expression
(map! :leader
      :desc "M-x" ";" #'execute-extended-command
      :desc "Eval expression" ":" #'eval-expression)
;; also enable SPC-x -> just to handy on mobile
(map! :leader
      :desc "M-x" "x" #'execute-extended-command
      )

;; * TODOs
;; ** better mode-line color inactive window light-grey (?), active --> black??
;;NOT DOOM ;;; ;; ** combine org/headline with major-mode in programming-language --> fold/unfold capability sections / short-cuts new-heading / sub-heading etc.

;; * debugger-mode I (evil settings after evil)
;; (set at start so comfortable debugging of init file in case it a biggy)
(add-hook 'debugger-mode-hook
          (lambda ()
            (visual-line-mode)))

;; * debug on start-up
(setq debug-only-on-start-up t)
(if debug-only-on-start-up
  (setq debug-on-error t)
  )




;; * machine distinction mechanism (server-/local-machines)
;; * get machine, we re on
(setq myhost (getenv "MYHOST")) ;; my host can be laptop/phone
;; (tech.comment: could have also used (system-name), but this is not reproducible when i change my machine's names, so my solution is less maintenance intensive)
;; -> put into .bashrc of machine:
;; export MYHOST=laptop
;; or
;; export MYHOST=hlrn
;; or
;; export MYHOST=mathe
;; or
;; export MYHOST=phone
;; ** you can also set it later interactively with this fun:
(defun set-myhost ()
  (interactive)
  (setq new-myhost-name (read-string "Enter server name (e.g. laptop/hlrn/mathe/phone):"))
  (setq myhost new-myhost-name)
  (message "MYHOST set to %s" new-myhost-name)
  )

(defun show-myhost ()
  (interactive)
  (message "MYHOST is %s" myhost)
  )

;; * define local / server machines
 (defvar my-server-machine-names '("mathe" "hlrn" "emmy"))
 (defvar my-local-machine-names '("laptop" "phone"))

 ;; * current-server
 (defvar my-current-server-name "hlrn") ;; the server i m currently working on

 (defun set-my-current-server-name ()
   (interactive)
   (setq new-ssh-server-name (read-string "enter server name alias (aliases defined in your ~/.ssh/config file, e.g. blogin/mathe):"))
   (setq ssh-server-name new-ssh-server-name)
   (message "server name set to %s" new-ssh-server-name)
   )


 (defun myhost-is-local ()
   (interactive)
   (setq result nil)
   (cond
    ((member myhost my-local-machine-names)
     (setq result t))
    ( t (setq result nil)))
   result)
 ;; test : (myhost-is-local)

 (defun myhost-is-server ()
   (interactive)
   (setq result nil)
   (cond
    ((member myhost my-server-machine-names)
     (setq result t))
    ( t (setq result nil)))
   result)
 ;; test : (myhost-is-server)

 ;; * general requirement: use-package and quelpa-use-package
;; ** use-package
;; NOT DOOM ;;; (require 'package)
;; NOT DOOM ;;; (add-to-list 'package-archives
;; NOT DOOM ;;;              '("melpa" . "https://melpa.org/packages/") t)
;; NOT DOOM ;;;  (require 'use-package)
;; NOT DOOM ;;;  ;; ** quelpa-usapackage -> enables you to update source of package from github and recompile on the fly by adding ":quelpa" key-word to use-package:  "(use-package <package-name> :quelpa <other stuff>)
;; NOT DOOM ;;;  ;; (setq myhost (getenv "MYHOST"))
;; NOT DOOM ;;;  ;; (cond
;; NOT DOOM ;;;  ;;  ((equal myhost "phone") (message "on phone -> quelpa not set"))
;; NOT DOOM ;;;  ;;  (t (progn
;; NOT DOOM ;;;  ;; (quelpa
;; NOT DOOM ;;;  ;;  '(quelpa-use-package
;; NOT DOOM ;;;  ;;    :fetcher git
;; NOT DOOM ;;;  ;;    :url "https://github.com/quelpa/quelpa-use-package.git"))
;; NOT DOOM ;;;  ;; (require 'quelpa-use-package)
;; NOT DOOM ;;;  ;; )))
;; NOT DOOM ;;;
;; NOT DOOM ;;;  ;; overlay an arrow where the mark is
;; NOT DOOM ;;;    (defvar mp-overlay-arrow-position)
;; NOT DOOM ;;;    (make-variable-buffer-local 'mp-overlay-arrow-position)
;; NOT DOOM ;;;    (add-to-list 'overlay-arrow-variable-list  'mp-overlay-arrow-position)
;; NOT DOOM ;;;
;; NOT DOOM ;;;   (defun mp-mark-hook ()
;; NOT DOOM ;;;          ;; (make-local-variable 'mp-overlay-arrow-position)
;; NOT DOOM ;;;      (unless (or (minibufferp (current-buffer)) (not (mark)))
;; NOT DOOM ;;;        (set
;; NOT DOOM ;;;         'mp-overlay-arrow-position
;; NOT DOOM ;;;         (save-excursion
;; NOT DOOM ;;;           (goto-char (mark))
;; NOT DOOM ;;;           (forward-line 0)
;; NOT DOOM ;;;           (point-marker)))))

;;NOT DOOM ;;;  ;;; USER CONTROL
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; decide if want to use different themes for different files/modes
;;NOT DOOM ;;;  (setq color-theme-buffer-local-switch nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;; ; END USER CONTROL
;;NOT DOOM ;;;
;;NOT DOOM ;;; ; TODOS
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; copy/paste in terminal-mode, also remote
;;NOT DOOM ;;;  ;; todo: first check if xclip is installed in system
;;NOT DOOM ;;;  ;;(require 'xclip)
;;NOT DOOM ;;;  ;;(xclip-mode 1)
;;NOT DOOM ;;;  (message system-name)
;;NOT DOOM ;;;  ;;;; customization go to specific file (in cloud)
;;NOT DOOM (less complicated with doom's ~add-to-path!~) ;;;(setq my_load_path (file-name-directory load-file-name)) ;; save custom file also to the same path
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (setq custom-file-name "custom.el")
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (setq custom-file (concat my_load_path custom-file-name)) ;; has to be name "custom-file" -> so emacs recognizes it and writes saved customization there (https://www.gnu.org/software/emacs/manual/html_node/emacs/Saving-Customizations.html)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; do NOT load it (i don t want that custom shit)
;;NOT DOOM ;;;  ;; (load custom-file)


;;; GENERAL STUFF ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; path of my init file loaded in .emacs init file --> all manually installed .el-files (packages) should be located there
;; add this path to load path
;; (setq my_load_path "~/MyEmacsConfig/") ;; the init file folder contains also all manual packages
;; (add-to-list 'load-path my_load_path)
;;(add-to-list 'image-load-path my_load_path)
;;
(add-load-path! ".")


;;NOT DOOM ;;; ;; * general.el
;;NOT DOOM ;;; ;; (for now i use it only for leader-keys)
;;NOT DOOM ;;; ;; (non leader bindings still with "legacy" commands (global-set-key, etc.)
;;NOT DOOM ;;; (use-package general
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;; (general-evil-setup t)
;;NOT DOOM ;;;
;;NOT DOOM ;;; (general-create-definer js/leader-def
;;NOT DOOM ;;;   :states '(normal insert visual emacs)
;;NOT DOOM ;;;   :keymaps 'override
;;NOT DOOM ;;;   :prefix "SPC"
;;NOT DOOM ;;;   :global-prefix "M-SPC") ;; evil leader access in "all situations" (this also "deactivates" prefix SPC for insert and emacs state so you can type spaces :D!)
;;NOT DOOM ;;;
;;NOT DOOM ;;; ;; two context-dependent leaders
;;NOT DOOM ;;; ;; (i think I do not need them really :D)
;;NOT DOOM ;;; ;; (general-create-definer js/local-leader1-def
;;NOT DOOM ;;; ;;   :states '(normal visual)
;;NOT DOOM ;;; ;;   ;; :prefix my-local-leader
;;NOT DOOM ;;; ;;   :prefix ",")
;;NOT DOOM ;;; ;; (general-create-definer js/local-leader2-def
;;NOT DOOM ;;; ;;   :states '(normal visual)
;;NOT DOOM ;;; ;;   ;; :prefix my-local-leader
;;NOT DOOM ;;; ;;   :prefix "\\")
;;NOT DOOM ;;; ;;
;;NOT DOOM ;;; ;; test:
;;NOT DOOM ;;; ;; (js/leader-def "6" (lambda () (interactive) (message "hello")))
;;NOT DOOM ;;; ;; or only for a mode
;;NOT DOOM ;;; ;; (js/leader-def :keymaps 'org-mode-map "m" (lambda () (interactive) (message "heeello")))
;;NOT DOOM ;;; ;; (js/leader-def :keymaps 'emacs-lisp-mode-map "m" (lambda () (interactive) (message "heeello")))
;;NOT DOOM ;;; ;;
;;NOT DOOM ;;; ;;  GENERAL SETTINGS
;;NOT DOOM ;;; ;;
;;NOT DOOM ;;; ;; ;; * window movement/placement ("'M' is my leader")
;;NOT DOOM undoomed ;;; ;; (global-set-key (kbd "M-2") 'split-window-below)
;;NOT DOOM undoomed ;;; ;; (global-set-key (kbd "M-3") 'split-window-right)
;;NOT DOOM undoomed ;;; ;; (global-set-key (kbd "M-0") 'delete-window)
;;NOT DOOM undoomed ;;; ;; (global-set-key (kbd "M-1") 'delete-other-windows) ;; aka maximize
;;NOT DOOM undoomed ;;; ;; (global-set-key (kbd "M-4") 'js/kill-this-buffer-no-prompt)
;;NOT DOOM  undoomed;;; ;; (global-set-key (kbd "M-d") 'js/kill-this-buffer-no-prompt) ;; let s see which "kill-binding" will dominate, delete less used in future
;;NOT DOOM ;;; ;; (global-set-key (kbd "M-;") 'js/open-browser)
;;NOT DOOM  undoomed;;; ;; (global-set-key (kbd "M-y") 'previous-buffer)
;;NOT DOOM  undoomed;;; ;; (global-set-key (kbd "M-o") 'next-buffer)
;;NOT DOOM ;;; ;;
;;NOT DOOM ;;; (defun js/open-browser ()
;;NOT DOOM ;;;   "shall context dependent, open browser and do what i (probably) want:
;;NOT DOOM ;;;    customize to my liking.
;;NOT DOOM ;;;    for now: just open firefox (if EXWM window does not exist, create)"
;;NOT DOOM ;;;   (interactive)
;;NOT DOOM ;;;   ;; check if browser instance exists
;;NOT DOOM ;;;   (setq browser-exwm-window-exists (get-buffer "firefox"))
;;NOT DOOM ;;;   ;; if exists -> switch
;;NOT DOOM ;;;   (if browser-exwm-window-exists
;;NOT DOOM ;;;       (switch-to-buffer "firefox")
;;NOT DOOM ;;;     ;; else -> run new firefox
;;NOT DOOM ;;;       (start-process-shell-command "firefox" nil "firefox")))
;;NOT DOOM ;;;
;;NOT DOOM ;;; (global-set-key (kbd "M-b") 'helm-mini )
;;NOT DOOM ;;;
(map!
"M-K" '(lambda () (interactive) (enlarge-window 4))
"M-J" '(lambda () (interactive) (shrink-window 4))
"M-H" '(lambda () (interactive) (enlarge-window-horizontally 4))
"M-L" '(lambda () (interactive) (shrink-window-horizontally 4)))
;;NOT DOOM ;;;
;;NOT DOOM ;;; ;; kbd "M-[" makes (xterm-mouse-mode behave strange/break (bug?)
;;NOT DOOM ;;;
;;NOT DOOM ;;; ;; (global-set-key (kbd "M-[") 'dummy-message)
;;NOT DOOM ;;; ;; (global-set-key (kbd "M-[") 'winner-undo)
;;NOT DOOM ;;; ;; (global-set-key (kbd "M-]") 'winner-redo)
;;NOT DOOM ;;;
;;NOT DOOM ;;; ;; * default font
;;NOT DOOM ;;; (defvar js/default-font-size 120)
;;NOT DOOM ;;; ;; (set-face-attribute 'default nil :font "FreeMono" :height js/default-font-size) ;; original default on arch
;;NOT DOOM ;;; ;; (set-face-attribute 'default nil :font "Source Code Pro" :height js/default-font-size) ;; bit more decent than fira, but very similar
;;NOT DOOM ;;; (set-face-attribute 'default nil :font "Fira Code Retina" :height js/default-font-size)
;;NOT DOOM ;;; ;; (set-face-attribute 'default nil :font "Cantarell" :height js/default-font-size) ;; is variable pitch
;;NOT DOOM ;;; ;; (set-face-attribute 'default nil :font "Courier New" :height js/default-font-size) ;; similar to FreeMono
;;NOT DOOM ;;;
;; ** detect machine name
(defvar machine-name)
(cond
  ((equal system-name "johannes-ThinkPad-L380-Yoga")
   (setq machine-name "laptop")
   )
  (t
   (setq machine-name "unknown")
   )
  )


;;NOT DOOM POT ;;;  ;; ** suppress "spamy" auto-revert messages
;;NOT DOOM ;;;  (setq auto-revert-verbose nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** title (play around -> tribute to emacs)
;;NOT DOOM ;;;  (setq frame-title-format '("I ❤ Emacs I ❤ Emacs I ❤ Emacs I ❤ Emacs I ❤ Emacs ❤ I"))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ; ** global line number mode on
;;NOT DOOM ;;;  (global-display-line-numbers-mode)
;;NOT DOOM ;;;  ; ** scroll bar off
;;NOT DOOM ;;;  (if (display-graphic-p)
;;NOT DOOM ;;;      (scroll-bar-mode -1)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;  ;; ** tool bar off
;;NOT DOOM ;;;  (tool-bar-mode -1)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** menu bar off
;;NOT DOOM ;;;  (menu-bar-mode -1)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** highlight corresponding parenthesis
;;NOT DOOM ;;;  (show-paren-mode t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** rainbow delimiters
;;NOT DOOM ;;; (use-package rainbow-delimiters
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  (rainbow-delimiters-mode t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** general COLOR THEMES ;;;;;;;;;;;;;
;;NOT DOOM ;;;  (color-theme-initialize) ;;; must first initialize (otherwise color-theme-buffer-local --> not working)
;;NOT DOOM ;;;
;;NOT DOOM ;;; (use-package color-theme
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  (setq color-theme-is-global nil)
;;NOT DOOM ;;;  ;; (color-theme-aalto-light)
;;NOT DOOM ;;; ;;  ;;(load-theme 'leuven)
;;NOT DOOM ;;;  ;;T (add-to-list 'custom-theme-load-path "emacs-leuven-theme")
;;NOT DOOM ;;; ;; (use-package zenburn-theme
;;NOT DOOM ;;;   ;; :ensure t)
;;NOT DOOM ;;; (load-theme 'zenburn t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; instruction:
;;NOT DOOM ;;;  ;; add mode hook with color theme
;;NOT DOOM ;;;  ;; Tipp: find out mode name of a buffer with e.g.: (buffer-local-value 'major-mode (get-buffer "*ansi-term*"))
;;NOT DOOM ;;; (use-package color-theme-buffer-local
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  ;; use the following as templates
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** personal (general) customization of faces (comments light green, etc.)
;;NOT DOOM ;;;  ;; (set-face-attribute 'font-lock-comment-face nil :foreground "light green")
;;NOT DOOM ;;;  (set-face-attribute 'font-lock-comment-face nil :foreground "green yellow")
;;NOT DOOM ;;;  ;; (set-face-attribute 'font-lock-comment-face nil :foreground "color-193")
;;NOT DOOM ;;;  (set-face-attribute 'font-lock-keyword-face nil :foreground "SkyBlue1" :weight 'bold)
;;NOT DOOM ;;;  (set-face-attribute 'font-lock-string-face nil :foreground "hot pink")
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; **
;;NOT DOOM ;;;  (if color-theme-buffer-local-switch
;;NOT DOOM ;;;      (add-hook 'text-mode-hook
;;NOT DOOM ;;;                (lambda nil (color-theme-buffer-local 'color-theme-feng-shui (current-buffer))))
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;  ;; (add-hook 'after-change-major-mode-hook  --> not working as default color --> produced mess in ansi-term
;;NOT DOOM ;;;  ;;      (lambda nil (color-theme-buffer-local 'color-theme-aalto-light (current-buffer))))
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; strange arrow up/down error --> outcommented
;;NOT DOOM ;;;  (if color-theme-buffer-local-switch
;;NOT DOOM ;;;      (add-hook 'c++-mode-hook
;;NOT DOOM ;;;        (lambda nil (color-theme-buffer-local 'color-theme-aalto-light (current-buffer))))
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (if color-theme-buffer-local-switch
;;NOT DOOM ;;;  (add-hook 'dired-mode-hook
;;NOT DOOM ;;;            (lambda nil (color-theme-buffer-local 'color-theme-classic (current-buffer))))
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (if color-theme-buffer-local-switch
;;NOT DOOM ;;;  (add-hook 'dired-mode-hook
;;NOT DOOM ;;;     (lambda nil (color-theme-buffer-local 'color-theme-charcoal-black (current-buffer))))
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun mydefault-buffer-local-theme () ;;
;;NOT DOOM ;;;     (interactive)
;;NOT DOOM ;;;  (color-theme-buffer-local 'color-theme-aalto-light (current-buffer))
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;  ;; (global-unset-key (kbd "<f10>") 'mydefault-buffer-local-theme) ;; work around because default color was strange in cygwin-emacs-nw --> just press f10 when color is strange
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * evil - load/ general (comes first -> basis for other packages/definitions)
;;NOT DOOM ;;;  ;; necessary for evil-collection (before load evil first time):
;;NOT DOOM ;;;  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
;;NOT DOOM ;;;  (setq evil-want-keybinding nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (use-package evil
;;NOT DOOM ;;;    :ensure t
;;NOT DOOM ;;;    :config
;;NOT DOOM ;;;    (evil-mode 1)
;;NOT DOOM ;;;    ;; (add-to-list 'evil-emacs-state-modes 'dired-mode)
;;NOT DOOM ;;;    (add-to-list 'evil-emacs-state-modes 'term-mode) ;; according to my emacs-policy -> only exception starting in emacs-state
;;NOT DOOM ;;;    ;;; quirk to allow to move beyond last character of line to evaluate lisp expressions
;;NOT DOOM ;;;    (setq evil-move-beyond-eol t)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; evil-collection --> set for certain modes
;;NOT DOOM ;;; (use-package evil-collection
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  (evil-collection-init
;;NOT DOOM ;;;   'dired
;;NOT DOOM ;;;   )
;;NOT DOOM ;;;  ;;; use alternative for ESC
;;NOT DOOM ;;; (use-package key-chord
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  (key-chord-mode 1)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
;;NOT DOOM ;;;  (key-chord-define evil-visual-state-map "jk" 'evil-normal-state)
;;NOT DOOM ;;;  (key-chord-define evil-replace-state-map "jk" 'evil-normal-state)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
;;NOT DOOM ;;;  ;; (key-chord-define evil-visual-state-map "jj" 'evil-normal-state) # this has nasty effect, commented out
;;NOT DOOM ;;;  (key-chord-define evil-replace-state-map "jj" 'evil-normal-state)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; **
;;NOT DOOM ;;;  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
;;NOT DOOM ;;;  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
;;NOT DOOM ;;;  ;; ** search string under visual selection (commonly used also by vimmers)
;;NOT DOOM ;;; (use-package evil-visualstar
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;
;; ** evil macros repeat
(map!
      :n "," #'(lambda () (interactive)
(setq macro (evil-get-register evil-last-register t))
(evil-execute-macro nil macro)))

;; quick search replace
(defun quick-evil-search-replace-region ()
  (interactive)
(let ((my-string "'<,'>s///g"))
  (minibuffer-with-setup-hook
   ;; (lambda () (backward-char  4))
    (lambda () (backward-char (/ 7 2)))
    (evil-ex my-string))))

(map! :leader
      :n "r" #'quick-evil-search-replace-region)
;;NOT DOOM ;;;
;; quickly select pasted region
(defun evil-select-pasted ()
  "Visually select last pasted text."
  (interactive)
  (evil-goto-mark ?\[)
  (evil-visual-char)
  (evil-goto-mark ?\]))

(map! :n "zv" 'evil-select-pasted)
;; ( -> mapped to evil leader v)
;;NOT DOOM ;;;
;;NOT DOOM ;;; ;; * (general) evil leader bindings
;;NOT DOOM ;;;    (use-package comment-dwim-2 :ensure t) ;; toggles also single line, in contrast to comment-dwim
;;NOT DOOM POT;;;    (js/leader-def
;;NOT DOOM POT;;;    "c" 'comment-dwim-2
;;NOT DOOM POT;;;    "s" 'save-buffer
;;NOT DOOM POT;;;    "f" 'helm-find
;;NOT DOOM POT;;;    "?" '"gsyn"


;; dired-go-current-buffer
(defun dired-go-current-buffer ()
   (interactive)
       (dired default-directory))
(map! :leader "d" #'dired-go-current-buffer)

(map! :leader "SPC" #'save-buffer)


;; doom had no default rg binding ->
(map! :leader "sr" #'consult-ripgrep)


;;NOT DOOM POT;;;    "g" 'helm-swoop  ; only dired -> helm-rg ( ack / ag / rg --> ag did not work , rg works (if installed)
;;NOT DOOM POT;;;    "p" 'helm-projectile-find-file ;; -> "p" ssh-clipboard-paste, defined there
;;NOT DOOM POT;;;    "d" 'dired-go-current-buffer
;;NOT DOOM POT;;;    "x" 'helm-M-x
;;NOT DOOM POT;;;    "2" 'split-window-below
;;NOT DOOM POT;;;    "3" 'split-window-right
;;NOT DOOM POT;;;    "0" 'delete-window
;;NOT DOOM POT;;;    "1" 'delete-other-windows
;;NOT DOOM POT;;;    "b" 'helm-mini  ; recent files (better than recentf-open-files and/or helm-buffers-list)
;;NOT DOOM POT;;;    "r" 'quick-evil-search-replace  ; quick way to replace expression in region
;;NOT DOOM POT;;;    "v" 'evil-select-pasted  ; quick way to replace expression in region
;;NOT DOOM POT;;;    "e" (lambda () (interactive) (revert-buffer t t) (message "buffer reverted" ))
;;NOT DOOM POT;;;    "'" 'iresize-mode
;;NOT DOOM POT;;;    ":" 'gsyn
;;NOT DOOM POT;;;    ";" 'gsyn
;;NOT DOOM POT;;;  )
;;NOT DOOM POT;;;
;;NOT DOOM ;;; (use-package evil-numbers
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  (global-set-key (kbd "C-c +") 'evil-numbers/inc-at-pt)
;;NOT DOOM ;;;  (global-set-key (kbd "C-c -") 'evil-numbers/dec-at-pt)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * debugger-mode II (evil settings)
;;NOT DOOM ;;;  (add-to-list 'evil-normal-state-modes 'debugger-mode)
;;NOT DOOM ;;;
;;NOT DOOM POT;;;  ;; * drag-stuff (evilized)
;;NOT DOOM ;;;  ;; ( this is already a bit "tweaking" of evil mode )
;;NOT DOOM ;;;  (define-key evil-normal-state-map (kbd "C-j") 'drag-stuff-down)
;;NOT DOOM ;;;  (define-key evil-normal-state-map (kbd "gr") 'repeat)
;;NOT DOOM ;;;  (define-key evil-normal-state-map (kbd "C-k") 'drag-stuff-up)
;;NOT DOOM ;;;  (define-key evil-normal-state-map (kbd "C-h") 'drag-stuff-left)
;;NOT DOOM ;;;  (define-key evil-normal-state-map (kbd "C-l") 'drag-stuff-right)
;;NOT DOOM ;;;

;; * planet-mode (my org extension)
(load! "planet/planet")

 ;; ** save git mode default
  (planet-git-save-turn-on)

;; ** planet key-bindings ( -> leader SPC-e-...)
(map! :leader
      (:prefix-map ("e" . "planet")
       :desc "planet today"         "d" #'planet-today
       :desc "planet today"         "e" #'planet-today
       :desc "planet week"          "y" #'planet-this-week
       :desc "planet view week"     "w" #'planet-view-week2X4
       :desc "planet view quit"     "q" #'planet-view-quit
       :desc "planet auto-gsyn on"   "g" #'planet-git-save-turn-on
       :desc "planet gsyn and revert"  "s" #'gsyn-and-revert
       :desc "planet auto-gsyn off"  "G" #'planet-git-save-turn-off
      ))


(map! :map planet-mode-map
      :leader
      (:prefix ("e" . "planet")
       (:prefix ("k" . "category") ;; "k" (germ. kategorie) more ergonomic than c (category) after pressing "e" (left hand), then "k" (right hand)
       "w" #'planet-set-category-work
       "t" #'planet-set-category-tools
       "c" #'planet-set-category-science
       "p" #'planet-set-category-private
       "k" #'planet-set-category-knowledge
       "s" #'planet-set-category-sustainment)
      (:prefix ("t" . "type")
       "b" #'planet-set-type-birthday
       "t" #'planet-set-type-fullday)
      ))

;; * job -> come/go
(defun js/job-book-in ()
  (interactive)
  (beginning-of-buffer)
  (insert "* job book in \n")
  (insert (format-time-string "[%H:%M]\n"))
  )

(defun js/job-book-out ()
  (interactive)
  (end-of-buffer)
  (insert "* job book out \n")
  (insert (format-time-string "[%H:%M]\n"))
  )
(map! :map evil-org-mode
      :leader
      (:prefix ("e" . "planet")
      :desc "job in" :n  "i" #'js/job-book-in
      :desc "job out" :n "o" #'js/job-book-out
      ))

;; not working (see learnings key evil emacs):
;; (map! :map planet-mode-map
;;       :n ">" #'planet-next
;;       :n "<" #'planet-previous)
;; (evil-make-overriding-map planet-mode-map 'normal)

;; "brute" solution (works, since evil-normal-state-local-map precedes evil-org):
(add-hook 'planet-mode-hook
  (lambda ()
    (define-key evil-normal-state-local-map ">" 'planet-next)
    (define-key evil-normal-state-local-map "<" 'planet-previous)))


(defun efs/run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

  ;; don t know if usefull ;; ;; ** default initial view (levels)
  ;; don t know if usefull ;; (add-hook 'planet-mode-hook
  ;; don t know if usefull ;;          (lambda ()
  ;; don t know if usefull ;;            ;; (outline-show-all)
  ;; don t know if usefull ;;            ))
  ;; don t know if usefull ;; (defun org-show-3-levels ()
  ;; don t know if usefull ;;   (interactive)
  ;; don t know if usefull ;;   (org-content 3))
  ;; don t know if usefull ;; (add-hook 'org-mode-hook
  ;; don t know if usefull ;;   (lambda ()
  ;; don t know if usefull ;;     (define-key org-mode-map "\C-cm" 'org-show-two-levels)))


;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * )  my packages ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;NOT DOOM ;;;  ;-----------------------------------------------------------
;;NOT DOOM ;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;NOT DOOM ;;;


;; gsyn dependency
(defun gsyn-is-setup ()
  (interactive)
  (setq command-string "gsyn_dummy_message_call_other_non_exported")
  (async-shell-command command-string)
  )
(defun gsyn-find-main-git-directory-of-current-file ()
  (setq command-string "git rev-parse --show-toplevel")
  (setq output (shell-command-to-string command-string))
  ;; output e.g. :
  ;; "/home/johannes/MyEmacsConfig
  ;; "
  ;;--> quit "new line" from output -> only path -> e.g. "/home/johannes/MyEmacsConfig"
  (setq current-git-top-level-absolute-path (replace-regexp-in-string "\n$" "" output))
  current-git-top-level-absolute-path)

(defun gsyn ()
  (interactive)
  (let
      ((display-buffer-alist
        (list
         (cons
          ;; "\\* gsyn output \\*.*"
          "\*gsyn output\*"
          (cons #'display-buffer-no-window nil)))))
    (setq current-git-top-level-absolute-path (gsyn-find-main-git-directory-of-current-file))
    (setq command-string (concat "gsyn " current-git-top-level-absolute-path))
    (message (concat "git-synchronization launched ... (executed: " command-string ")"))
    ;;(let (shell-command-buffer-name-async "*gsyn output*")
    (async-shell-command command-string "*gsyn output*"))
)

(defun gsyn-and-revert ()
  (interactive)
  (let
      ((display-buffer-alist
        (list
         (cons
          ;; "\\* gsyn output \\*.*"
          "\*gsyn output\*"
          (cons #'display-buffer-no-window nil)))))
    (setq current-git-top-level-absolute-path (gsyn-find-main-git-directory-of-current-file))
    (setq command-string (concat "gsyn " current-git-top-level-absolute-path))
    (message (concat "git-synchronization launched ... (executed: " command-string ")"))
    ;;(let (shell-command-buffer-name-async "*gsyn output*")
    (call-process-shell-command command-string)
    (planet-revert-all-planet-buffers))
)

;; key binding (conform with doom "SPC g ...")
(map! :leader
      ;; :prefix ("g" . "+git") ;; not necessary
      "g ;" #'gsyn
      "g g" #'gsyn)

;; ** gsyn popup rule for doom-emacs
(set-popup-rule! ".*gsyn.*output.*" :ignore t) ;; workaround, in combination with prerequisite that (above) async-shell-command with trick: #'display-buffer-no-window
;; (did not figure out how to simply suppress (no show) of a popup buffer with doom's set-popup-rule!)

;;NOT DOOM ;;;  ;;;+) MELPA packages - make them available (some very good additional package list)
;;NOT DOOM ;;; ;; (add-to-list 'package-archives
;;NOT DOOM ;;; ;;              '("melpa" . "https://melpa.org/packages/"))
;;NOT DOOM ;;;  (when (< emacs-major-version 24)
;;NOT DOOM ;;;    ;; For important compatibility libraries like cl-lib
;;NOT DOOM ;;;    (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * elisp mode
;;NOT DOOM ;;; (use-package auto-complete
;;NOT DOOM ;;;    :ensure t)
;;NOT DOOM ;;;  (add-hook 'emacs-lisp-mode-hook
;;NOT DOOM ;;;            (lambda ()
;;NOT DOOM ;;;              (auto-complete-mode)
;;NOT DOOM ;;;              (rainbow-delimiters-mode t)
;;NOT DOOM ;;;              ))
;;NOT DOOM ;;;  ;; ** debugging
;;NOT DOOM ;;;  ;; *** comments: two options in emacs: debug (old) ;  edebug -> better, interactive, "matlab-like", just a 'little overhead' --> need to perform 'instrumentalization' before every debugging...
;;NOT DOOM ;;;  ;; *** --> just hit 'SPC-/'
;;NOT DOOM ;;;  ;; *** more convenient short-cut for instrumentalize function: than "C-u C-M-x"!
;;NOT DOOM ;;;  ;; (evil-leader/set-key-for-mode 'emacs-lisp-mode "/" 'instrumentalize-fun)
;;NOT DOOM ;;;
;;NOT DOOM ;;; ;;T this didnt work, really strange :( (js/leader-def :keymaps 'emacs-lisp-mode-map "/" 'instrumentalize-fun)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
(defun instrumentalize-fun ()
  (interactive)
  ;; (edebug-eval-defun t)
  (eval-defun t) ;; argument can be any --> effect is to instrumentalize for edebug
  )
;;NOT DOOM ;;;  ;;; ***
;;NOT DOOM ;;;  (evil-define-key 'normal edebug-mode-map (kbd "n") 'edebug-next-mode)
;;NOT DOOM ;;;  (evil-define-key 'normal edebug-mode-map (kbd "F10") 'edebug-next-mode)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (evil-define-key 'normal edebug-mode-map (kbd "q") 'top-level)
;;NOT DOOM ;;;  (evil-define-key 'normal edebug-mode-map (kbd "F8") 'top-level)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * bash (=shell-script-mode)
;;NOT DOOM ;;;  (add-hook 'shell-script-mode-hook
;;NOT DOOM ;;;            (lambda ()
;;NOT DOOM ;;;              (auto-complete-mode)
;;NOT DOOM ;;;              (rainbow-delimiters-mode t)
;;NOT DOOM ;;;              ))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * c++
;;NOT DOOM ;;;  (add-hook 'c++-mode-hook
;;NOT DOOM ;;;            (lambda ()
;;NOT DOOM ;;;              (auto-complete-mode)
;;NOT DOOM ;;;              (rainbow-delimiters-mode t)
;;NOT DOOM ;;;              ))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * python
;;NOT DOOM ;;;  (add-hook 'python-mode-hook
;;NOT DOOM ;;;            (lambda ()
;;NOT DOOM ;;;              (auto-complete-mode)
;;NOT DOOM ;;;              (rainbow-delimiters-mode t)
;;NOT DOOM ;;;              ))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (autoload 'pylint "pylint")
;;NOT DOOM ;;;  (add-hook 'python-mode-hook 'pylint-add-menu-items)
;;NOT DOOM ;;;  (add-hook 'python-mode-hook 'pylint-add-key-bindings)
;;NOT DOOM ;;;
;;; ** python debug key-bindings
(defun python-set-break-point-current-line()
  (interactive)
  (end-of-line)
  (newline)
  (insert "pdb.set_trace()")
  (move-beginning-of-line nil)
  (setq beginofline (point))
  (move-end-of-line nil)
  (setq endofline (point))
  (evil-indent beginofline endofline)
  ;; save
  (save-buffer)
  )
 ;; SET BREAKPOINT <F12>
(map! :map python-mode-map
      :leader
      (:prefix ("c" . "code")
       :desc "set break-point" :n "k" #'python-set-break-point-current-line))

(map! :map org-mode-map
      :leader
      (:prefix ("c" . "code")
       :desc "C-c-C-c" :n "c" #'org-ctrl-c-ctrl-c))


;;NOT DOOM ;;;  ;;; * english-german-translator
;;NOT DOOM ;;;  (defvar english-german-translator-buffer-name "*english-german-translator*")
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun english-german-translator-init ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    "currently: Start eww-buffer with dict.cc in a new buffer."
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (eww "dict.cc")
;;NOT DOOM ;;;    (rename-buffer english-german-translator-buffer-name)
;;NOT DOOM ;;;    (english-german-translator-move-point-to-input-field)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun get-point-position ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (setq current_pos (point))
;;NOT DOOM ;;;    (message current_pos)
;;NOT DOOM ;;;    current_pos)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun english-german-translator-move-point-to-input-field ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (goto-char 332)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun english-german-translator ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    ;; initiate if not already exists
;;NOT DOOM ;;;    (if (not (get-buffer english-german-translator-buffer-name))
;;NOT DOOM ;;;        (english-german-translator-init)
;;NOT DOOM ;;;        )
;;NOT DOOM ;;;    ;; switch to that buffer
;;NOT DOOM ;;;    (switch-to-buffer english-german-translator-buffer-name)
;;NOT DOOM ;;;    (english-german-translator-move-point-to-input-field)
;;NOT DOOM ;;;    ;; (switch-to-buffer english-german-translator-buffer-name)
;;NOT DOOM ;;;    ;; (english-german-translator-move-point-to-input-field)
;;NOT DOOM ;;;    ;; (switch-to-buffer english-german-translator-buffer-name)
;;NOT DOOM ;;;    ;; (english-german-translator-move-point-to-input-field)
;;NOT DOOM ;;;    ;; (switch-to-buffer english-german-translator-buffer-name)
;;NOT DOOM ;;;    ;; (english-german-translator-move-point-to-input-field)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
 ;;; * ipython-calculator (my)
 ;; todo: if not exists --> create ansi-term (non-sticky), enter ipython, and rename *ipython-calculator*
 (defvar ipython-calculator-buffer-name-nostar "ipython-calculator")
 (defvar ipython-calculator-buffer-name (concat "*" ipython-calculator-buffer-name-nostar "*"))

 (defun ipython-calculator-init ()
   (interactive)
   (js/ansi-term ipython-calculator-buffer-name-nostar)
   ;; (python-calculator-mode)
   ;; * execute ipython
   (cond ((equal myhost "phone")
          (comint-send-string ipython-calculator-buffer-name "python\n"))
         (t
          (comint-send-string ipython-calculator-buffer-name "ipython\n"))))

 (defun ipython-calculator-init0 ()
   "Start a terminal-emulator in a new buffer and run ipython."
   (interactive)
   (setq program "/bin/bash")

   (setq term-ansi-buffer-name (concat ipython-calculator-buffer-name))

   (setq term-ansi-buffer-name (term-ansi-make-term term-ansi-buffer-name program))

   (switch-to-buffer term-ansi-buffer-name)

   (set-buffer term-ansi-buffer-name)
   (term-mode)
   (term-char-mode)
   (python-calculator-mode)

   ;; Historical baggage.  A call to term-set-escape-char used to not
   ;; undo any previous call to t-s-e-c.  Because of this, ansi-term
   ;; ended up with both C-x and C-c as escape chars.  Who knows what
   ;; the original intention was, but people could have become used to
   ;; either.   (Bug#12842)
   (let (term-escape-char)
     ;; I wanna have find-file on C-x C-f -mm
     ;; your mileage may definitely vary, maybe it's better to put this in your .emacs ...
     (term-set-escape-char ?\C-x))

   (defun js/show-buffer-name ()
     (interactive)
     (message (buffer-name)))

   ;; * execute ipython
   (cond ((equal myhost "phone")
          (comint-send-string ipython-calculator-buffer-name "python\n"))
         (t
          (comint-send-string ipython-calculator-buffer-name "ipython\n"))))


 (defun ipython-calculator ()
   (interactive)
   ;; initiate if not already exists
   (if (not (get-buffer ipython-calculator-buffer-name))
       (ipython-calculator-init)
       )
   ;; switch to that buffer
   (switch-to-buffer ipython-calculator-buffer-name)
   )

(map! :leader
    :desc "ipython calc." "oa" #'ipython-calculator)


 (defvar python-calculator-mode-map
   (let ((m (make-sparse-keymap))) ;; i think this achieves a "local key binding" for the buffer
     (define-key m (kbd "M-p") 'term-send-up)
     m))

 (define-minor-mode python-calculator-mode "this is the documentation."
   :init-value nil
   :lighter " py-calc"
   :keymap python-calculator-mode-map
   :group 'python-calculator
   :global nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * org-mode
;;NOT DOOM ;;;  ;; ** prior stuff
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (setq org-blank-before-new-entry
;;NOT DOOM ;;;        '((heading . nil)
;;NOT DOOM ;;;         (plain-list-item . auto)))
;;NOT DOOM ;;;  ;; make sure we have the latest package of org
;;NOT DOOM ;;;  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
;;NOT DOOM ;;;  ;; org ellipsis
;;NOT DOOM ;;;  ;; right arrows
;;NOT DOOM ;;;  ;; “↝” “⇉” “⇝” “⇢” “⇨” “⇰” “➔” “➙” “➛” “➜” “➝” “➞”
;;NOT DOOM ;;;↓
;; down/up arrow utf8
;; (insert "\u2193")
;; ↓↓
;; (insert "\u2191")
;; ↑↑
;;NOT DOOM ;;;  ;; “➟” “➠” “➡” “➥” “➦” “➧” “➨”
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; “➩” “➪” “➮” “➯” “➱” “➲”
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; “➳” “➵” “➸” “➺” “➻” “➼” “➽”
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; arrow heads
;;NOT DOOM ;;;  ;; “➢” “➣” “➤” “≪”, “≫”, “«”, “»”
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; other arrows
;;NOT DOOM ;;;  ;; “↞” “↠” “↟” “↡” “↺” “↻”
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; lightening
;;NOT DOOM ;;;  ;; “⚡”
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; other symbols
;;NOT DOOM ;;;  ;; …, ▼, ↴, , ∞, ⬎, ⤷, ⤵
;;NOT DOOM ;;; (use-package org
;;NOT DOOM ;;;   :ensure t)
(after! org
  (setq org-ellipsis " ▾"))
        ;; (add-hook! org-mode-abbrev-table
  ;; (make-variable-buffer-local 'org-superstar-headline-bullets-list)
  ;; (setq org-superstar-headline-bullets-list '("" "" "*" "*"))
  ;; (setq org-superstar-headline-bullets-list '(" "))
           ;; )
;;NOT DOOM ;;;  ;; (setq org-ellipsis " ▼")
;;NOT DOOM ;;;  (set-face-attribute 'org-ellipsis nil :underline nil  :foreground "gray65")
;;NOT DOOM ;;;  ;; (setq org-ellipsis "▾")
;;NOT DOOM ;;;  ;; (setq org-ellipsis " ⤵")
;;NOT DOOM ;;;  ;; ** fix TAB -> org-cycle for android phone
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "TAB") 'org-cycle)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** redisplay inline images comfy key
;;NOT DOOM ;;; (js/leader-def "or" 'org-redisplay-inline-images)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** always redisplay inline images after ctrl-c-ctrl-c
;;NOT DOOM ;;;  (advice-add 'org-ctrl-c-ctrl-c :after 'org-redisplay-inline-images)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** org bullets
;;NOT DOOM ;;;  ;; hexagrams
;;NOT DOOM ;;;  ;; “✡” “⎈” “✽” “✲” “✱” “✻” “✼” “✽” “✾” “✿” “❀” “❁” “❂” “❃” “❄” “❅” “❆” “❇”
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; circles
;;NOT DOOM ;;;  ;; “○” “☉” “◎” “◉” “○” “◌” “◎” “●” “◦” “◯” “⚪” “⚫” “⚬” “❍” “￮” “⊙” “⊚” “⊛” “∙” “∘”
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; special circles
;;NOT DOOM ;;;  ;; “◐” “◑” “◒” “◓” “◴” “◵” “◶” “◷” “⚆” “⚇” “⚈” “⚉” “♁” “⊖” “⊗” “⊘”
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; crosses
;;NOT DOOM ;;;  ;; “✙” “♱” “♰” “☥” “✞” “✟” “✝” “†” “✠” “✚” “✜” “✛” “✢” “✣” “✤” “✥”
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; poker sybmols
;;NOT DOOM ;;;  ;; “♠” “♣” “♥” “♦” “♤” “♧” “♡” “♢”
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; yinyang
;;NOT DOOM ;;;  ;; “☯” “☰” “☱” “☲” “☳” “☴” “☵” “☶” “☷”
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; special symbols
;;NOT DOOM ;;;  ;; “☀” “♼” “☼” “☾” “☽” “☣” “§” “¶” “‡” “※” “✕” “△” “◇” “▶” “◀” “◈”
;;NOT DOOM ;;; (use-package org-bullets
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  (add-hook 'org-mode-hook
;;NOT DOOM ;;;            (lambda nil (org-bullets-mode 1)))
;;NOT DOOM ;;;  (setq org-bullets-bullet-list
;;NOT DOOM ;;;    '(;;; Large
;;NOT DOOM ;;;      "◉"
;;NOT DOOM ;;;      ;;""
;;NOT DOOM ;;;      "○"
;;NOT DOOM ;;;      "•"
;;NOT DOOM ;;;      "★"
;;NOT DOOM ;;;      "✸"
;;NOT DOOM ;;;      "◆"
;;NOT DOOM ;;;      "♣"
;;NOT DOOM ;;;      "♠"
;;NOT DOOM ;;;      "♥"
;;NOT DOOM ;;;      "♦"
;;NOT DOOM ;;;      ;; ◉ ○ ●  ★  ♥ ◇ ✚ ✜ ☯ ◆ ♠ ♣ ♦ ☢ ❀ ◆ ◖ ▶ ✿
;;NOT DOOM ;;;      ;; ► • ★ ▸
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** pretty symbols
;;NOT DOOM ;;;  (setq-default prettify-symbols-alist '(
;;NOT DOOM ;;;   ("#+BEGIN_SRC" . "†")
;;NOT DOOM ;;;   ("#+END_SRC" . "†")
;;NOT DOOM ;;;   ("#+begin_src" . "†")
;;NOT DOOM ;;;   ("#+end_src" . "†")
;;NOT DOOM ;;;   (">=" . "≥")
;;NOT DOOM ;;;   ("=>" . "⇨")
;;NOT DOOM ;;;   ("->" . "➔")
;;NOT DOOM ;;;   ("-->" . "➔")
;;NOT DOOM ;;;   ))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** pretty tags (todo future) http://blog.lujun9972.win/emacs-document/blog/2020/02/19/beautify-org-mode/index.html
;;NOT DOOM ;;;  ;; (use-package org-pretty-tags
;;NOT DOOM ;;;  ;;  :demand t
;;NOT DOOM ;;;  ;;  :config
;;NOT DOOM ;;;  ;;  (setq org-pretty-tags-surrogate-strings
;;NOT DOOM ;;;  ;;  (quote
;;NOT DOOM ;;;  ;;  (("TOPIC" . "☆")
;;NOT DOOM ;;;  ;;  ("PROJEKT" . "💡")
;;NOT DOOM ;;;  ;;  ("SERVICE" . "✍")
;;NOT DOOM ;;;  ;;  ("Blog" . "✍")
;;NOT DOOM ;;;  ;;  ("music" . "♬")
;;NOT DOOM ;;;  ;;  ("security" . "🔥"))))
;;NOT DOOM ;;;  ;;  (org-pretty-tags-global-mode))
;;NOT DOOM ;;;  ;; ** disable line-numbers
;;NOT DOOM ;;;   (add-hook 'org-mode-hook
;;NOT DOOM ;;;             (lambda nil (display-line-numbers-mode -1)))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (add-hook 'org-mode-hook
;;NOT DOOM ;;;             (lambda nil
;;NOT DOOM ;;;               (org-bullets-mode 1)
;;NOT DOOM ;;;               ))
;;NOT DOOM ;;; (require 'org-install)
;;NOT DOOM ;;;

;; insert xournal note
(defun js/async-shell-command-no-window (command output-buffer-name)
  (interactive)
  (let
      ((display-buffer-alist
        (list
         (cons
          output-buffer-name
          (cons #'display-buffer-no-window nil)))))
    (async-shell-command
     command output-buffer-name)))

(defun js/org-insert-xournal-note ()
  (interactive)
  ;; * file name
  (setq date (planet-get-todays-date))
  (setq min (format "%02i"(planet-date-get-min date)))
  (setq hour (format "%02i"(planet-date-get-hour date)))
  (setq filename (concat (planet-convert-date-to-filebasename date) "_" hour "_" min ".xopp"))
  (message filename)
  ;; * create file from template
  (setq currentpath (file-name-directory buffer-file-name))
  (setq filefullname (concat  currentpath "/" filename))
  (setq template-filefullname "/home/johannes/MyEmacsConfig/xournal_org_template_new.xopp")
  ;; * open xournal file (no popup of async output)
  (setq command_string (concat "xournalpp " filefullname))
  (js/async-shell-command-no-window command_string  "*org_xournal_new_open_output*")
  (copy-file template-filefullname filefullname)
  ;; * insert file link
  (end-of-line)
  (newline)
  (insert (concat "[[file:" filename "][✎]]")) ;; insert "pencil-button" to open and edit (org file link)
  )

(map! :leader
      :map (evil-org-mode-map org-mode-map)
      "i x" #'js/org-insert-xournal-note)

;;NOT DOOM ;;;
;;NOT DOOM ;;; (defun dummy ()
;;NOT DOOM ;;;   (interactive)
;;NOT DOOM ;;;   (newline)
;;NOT DOOM ;;;   )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** clock in/out settings
;;NOT DOOM ;;;  ;; *** change todo state "CLOCKED IN..." / "", for clocked in headings
;;NOT DOOM ;;;  (defvar org-todo-state-on-clock-in-saved)
;;NOT DOOM ;;;  (setq org-todo-state-on-clock-in-saved "")
;;NOT DOOM ;;;  (add-hook 'org-clock-in-hook
;;NOT DOOM ;;;           (lambda ()
;;NOT DOOM ;;;             ;; save old state (in global variable)
;;NOT DOOM ;;;             (setq org-todo-state-on-clock-in-saved (org-get-todo-state))
;;NOT DOOM ;;;             (org-todo "CLOCKED IN...")
;;NOT DOOM ;;;            ))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (add-hook 'org-clock-out-hook
;;NOT DOOM ;;;           (lambda ()
;;NOT DOOM ;;;             (org-set-todo-state-before-clocked)
;;NOT DOOM ;;;             (message "my org clock out:")
;;NOT DOOM ;;;             (message (concat "current todo state: " (org-get-todo-state)))
;;NOT DOOM ;;;             (message (concat "old/new todo state:" org-todo-state-on-clock-in-saved))
;;NOT DOOM ;;;            ))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun org-set-todo-state-before-clocked ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (org-todo org-todo-state-on-clock-in-saved)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun org-get-todo-state ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (setq components (org-heading-components))
;;NOT DOOM ;;;    ;; (message (nth 2 components))
;;NOT DOOM ;;;    (setq todo-state (nth 2 components))
;;NOT DOOM ;;;    todo-state)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun org-print-todo-state ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (setq components (org-heading-components))
;;NOT DOOM ;;;    (setq todo-state (nth 2 components))
;;NOT DOOM ;;;    (message (concat "current todo state: " todo-state))
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** show distribution of clocked time per tag
;;NOT DOOM ;;; (require 'org-table)
;;NOT DOOM ;;;
;;NOT DOOM ;;; (require 'org-clock)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun clocktable-by-tag/shift-cell (n)
;;NOT DOOM ;;;    (let ((str ""))
;;NOT DOOM ;;;      (dotimes (i n)
;;NOT DOOM ;;;        (setq str (concat str "| ")))
;;NOT DOOM ;;;      str))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun clocktable-by-tag/insert-tag (params)
;;NOT DOOM ;;;    (let ((tag (plist-get params :tags)))
;;NOT DOOM ;;;      (insert "|--\n")
;;NOT DOOM ;;;      (insert (format "| %s | *Tag time* |\n" tag))
;;NOT DOOM ;;;      (let ((total 0))
;;NOT DOOM ;;;    (mapcar
;;NOT DOOM ;;;         (lambda (file)
;;NOT DOOM ;;;       (let ((clock-data (with-current-buffer (find-file-noselect file)
;;NOT DOOM ;;;                   (org-clock-get-table-data (buffer-name) params))))
;;NOT DOOM ;;;         (when (> (nth 1 clock-data) 0)
;;NOT DOOM ;;;           (setq total (+ total (nth 1 clock-data)))
;;NOT DOOM ;;;           (insert (format "| | File *%s* | %.2f |\n"
;;NOT DOOM ;;;                   (file-name-nondirectory file)
;;NOT DOOM ;;;                   (/ (nth 1 clock-data) 60.0)))
;;NOT DOOM ;;;           (dolist (entry (nth 2 clock-data))
;;NOT DOOM ;;;             (insert (format "| | . %s%s | %s %.2f |\n"
;;NOT DOOM ;;;                     (org-clocktable-indent-string (nth 0 entry))
;;NOT DOOM ;;;                     (nth 1 entry)
;;NOT DOOM ;;;                     (clocktable-by-tag/shift-cell (nth 0 entry))
;;NOT DOOM ;;;                     (/ (nth 3 entry) 60.0)))))))
;;NOT DOOM ;;;         (org-agenda-files))
;;NOT DOOM ;;;        (save-excursion
;;NOT DOOM ;;;      (re-search-backward "*Tag time*")
;;NOT DOOM ;;;      (org-table-next-field)
;;NOT DOOM ;;;      (org-table-blank-field)
;;NOT DOOM ;;;      (insert (format "*%.2f*" (/ total 60.0)))))
;;NOT DOOM ;;;      (org-table-align)))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun org-dblock-write:clocktable-by-tag (params)
;;NOT DOOM ;;;    (insert "| Tag | Headline | Time (h) |\n")
;;NOT DOOM ;;;    (insert "|     |          | <r>  |\n")
;;NOT DOOM ;;;    (let ((tags (plist-get params :tags)))
;;NOT DOOM ;;;      (mapcar (lambda (tag)
;;NOT DOOM ;;;            (setq params (plist-put params :tags tag))
;;NOT DOOM ;;;            (clocktable-by-tag/insert-tag params))
;;NOT DOOM ;;;          tags)))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (provide 'clocktable-by-tag)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** links in org-mode
;;NOT DOOM ;;;  ;; *** copy url to clipboard and stuff
;;NOT DOOM ;;;  ;; --> best way -> just M-x org-toggle-link-display , and copy url with evil "yi]"
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** evaluate code snippets in org
;;NOT DOOM ;;;  ;; *** don t confirm every time
;;NOT DOOM ;;;  (setq org-confirm-babel-evaluate nil)
;;NOT DOOM ;;;  ;; *** add languages: C++/C
;;NOT DOOM ;;;  (org-babel-do-load-languages
;;NOT DOOM ;;;   'org-babel-load-languages
;;NOT DOOM ;;;   '(
;;NOT DOOM ;;;     (C . t);; This enables Babel to process C, C++ and D source blocks.
;;NOT DOOM ;;;     (python . t);;
;;NOT DOOM ;;;     (matlab . t);;
;;NOT DOOM ;;;     (latex . t);;
;;NOT DOOM ;;;     (emacs-lisp . t);;
;;NOT DOOM ;;;     (shell . t);; (sh . t) does not work (docum. faulty)
;;NOT DOOM ;;;     )
;;NOT DOOM ;;;   )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; *** add quick-templates (<s <TAB> /
;;NOT DOOM ;;;  ;; delete all that crap and do my own
;;NOT DOOM ;;;  ;; add c++
;;NOT DOOM ;;;  (setq org-structure-template-alist nil)
;;NOT DOOM ;;;  ;; (add-to-list 'org-structure-template-alist '("s" "#+BEGIN_SRC\n?\n#+END_SRC")) ;; default
;;NOT DOOM ;;;  (add-to-list 'org-structure-template-alist '("s" "#+begin_src\n?\n#+end_src")) ;; default
;;NOT DOOM ;;;  (add-to-list 'org-structure-template-alist '("c" "#+begin_src C++\n?\n#+end_src")) ;; c++
;;NOT DOOM ;;;  (add-to-list 'org-structure-template-alist '("C" "#+begin_src C\n?\n#+end_src")) ;; C
;;NOT DOOM ;;;  (add-to-list 'org-structure-template-alist '("p" "#+begin_src python\n?\n#+end_src")) ;; python
;;NOT DOOM ;;;  (add-to-list 'org-structure-template-alist '("b" "#+begin_src bash\n?\n#+end_src")) ;; bash
;;NOT DOOM ;;;  (add-to-list 'org-structure-template-alist '("m" "#+begin_src math\n?\n#+end_src")) ;; math (aka matlab)
;;NOT DOOM ;;;  (add-to-list 'org-structure-template-alist '("l" "#+begin_src latex\n?\n#+end_src")) ;; latex
;;NOT DOOM ;;;  ;; default content of org-structure-template-alist:
;;NOT DOOM ;;;  ;; (
;;NOT DOOM ;;;  ;; ("s" "#+BEGIN_SRC ?
;;NOT DOOM ;;;  ;; #+END_SRC") ("e" "#+BEGIN_EXAMPLE
;;NOT DOOM ;;;  ;; ?
;;NOT DOOM ;;;  ;; #+END_EXAMPLE") ("q" "#+BEGIN_QUOTE
;;NOT DOOM ;;;  ;; ?
;;NOT DOOM ;;;  ;; #+END_QUOTE") ("v" "#+BEGIN_VERSE
;;NOT DOOM ;;;  ;; ?
;;NOT DOOM ;;;  ;; #+END_VERSE") ("V" "#+BEGIN_VERBATIM
;;NOT DOOM ;;;  ;; ?
;;NOT DOOM ;;;  ;; #+END_VERBATIM") ("c" "#+BEGIN_CENTER
;;NOT DOOM ;;;  ;; ?
;;NOT DOOM ;;;  ;; #+END_CENTER") ("C" "#+BEGIN_COMMENT
;;NOT DOOM ;;;  ;; ?
;;NOT DOOM ;;;  ;; #+END_COMMENT") ("l" "#+BEGIN_EXPORT latex
;;NOT DOOM ;;;  ;; ?
;;NOT DOOM ;;;  ;; #+END_EXPORT") ("L" "#+LaTeX: ") ("h" "#+BEGIN_EXPORT html
;;NOT DOOM ;;;  ;; ?
;;NOT DOOM ;;;  ;; #+END_EXPORT") ("H" "#+HTML: ") ("a" "#+BEGIN_EXPORT ascii
;;NOT DOOM ;;;  ;; ?
;;NOT DOOM ;;;  ;; #+END_EXPORT") ("A" "#+ASCII: ") ("i" "#+INDEX: ?") ("I" "#+INCLUDE: %file ?"))

;; ** org-mode -> visual-line-mode by default
;; org-mode toggle bold/italic

(after! org
  (defun org-toggle-quote-region ()
    (interactive)
    (my-toggle-marker-around-region "\"" "\""  "\"" "\"")
    )
  (defun org-toggle-bold-region ()
    (interactive)
    (my-toggle-marker-around-region "*" "\*"  "*" "\*")
    )
  (defun org-toggle-code-region ()
    (interactive)
    (my-toggle-marker-around-region "~" "\~"  "~" "\~")
    )

  (defun org-toggle-red-region ()
    (interactive)
    (my-toggle-marker-around-region "=" "="  "=" "=")
    )


  (defun org-toggle-underline-region ()
    (interactive)
    (my-toggle-marker-around-region "_" "_"  "_" "_")
    )
  (defun org-toggle-italic-region ()
    (interactive)
    (my-toggle-marker-around-region "/" "\/" "/" "\/")
    )
  ;; todo: rethink these, already reserverd for other stuff
  (map!
   :map evil-org-mode-map
   :leader
   (:prefix-map ("j" . "format")
    :desc "toggle bold"       "b" #'org-toggle-bold-region
    :desc "toggle italic"     "i" #'org-toggle-italic-region
    :desc "toggle code"       "c" #'org-toggle-code-region
    :desc "toggle underline"  "u" #'org-toggle-underline-region
    :desc "preview LateX"     "l" #'org-latex-preview
    :desc "capitalize region" "C" #'capitalize-region
      ))
  ) ;; after! org

 (defun region-to-string ()
   (interactive)
   (setq region-string (buffer-substring (mark) (point)))
   ;; (message (concat region-string))
   region-string)
 (defun my-toggle-marker-around-region (marker-begin marker-begin-regex marker-end marker-end-regex)
   (setq begin (region-beginning))
   (setq end (region-end))
   (setq region_string (buffer-substring (mark) (point)))

   ;; if begins and ends with single star --> bold
   (if (string-match (concat "^" marker-begin-regex ".*" marker-end-regex "$") region_string) ;; org-headings are : '* blabla' or '** blabla' etc.
       (progn
         (save-excursion
           (goto-char begin)
           (delete-char (length marker-begin))
           (goto-char end)
           (backward-char);; because we deleted the char '*'
           (delete-char (length marker-begin))
           (message (concat "region is: " region_string))
           )
         )
       ;; else (toggle state: not marked)
       (progn
         (save-excursion
           (goto-char begin)
           (insert marker-begin)
           (goto-char end)
           (forward-char) ;; because we added the char '*'
           (insert marker-end)
           (message (concat "region is: " region_string))
           )
         )
       )
   )

;;NOT DOOM ;;;  ;; ** org latex export (settings and tweaks)
;;NOT DOOM ;;;
;; *** make plainlists below level always unnumbered
;; the "blunt way" redefine function (better later-> use advice or sth)
(defun org-latex-headline (headline contents info)
  "Transcode a HEADLINE element from Org to LaTeX.
CONTENTS holds the contents of the headline.  INFO is a plist
holding contextual information."
  (unless (org-element-property :footnote-section-p headline)
    (let* ((class (plist-get info :latex-class))
	   (level (org-export-get-relative-level headline info))
	   (numberedp (org-export-numbered-headline-p headline info))
	   (class-sectioning (assoc class (plist-get info :latex-classes)))
	   ;; Section formatting will set two placeholders: one for
	   ;; the title and the other for the contents.
	   (section-fmt
	    (let ((sec (if (functionp (nth 2 class-sectioning))
			   (funcall (nth 2 class-sectioning) level numberedp)
			 (nth (1+ level) class-sectioning))))
	      (cond
	       ;; No section available for that LEVEL.
	       ((not sec) nil)
	       ;; Section format directly returned by a function.  Add
	       ;; placeholder for contents.
	       ((stringp sec) (concat sec "\n%s"))
	       ;; (numbered-section . unnumbered-section)
	       ((not (consp (cdr sec)))
		(concat (funcall (if numberedp #'car #'cdr) sec) "\n%s"))
	       ;; (numbered-open numbered-close)
	       ((= (length sec) 2)
		(when numberedp (concat (car sec) "\n%s" (nth 1 sec))))
	       ;; (num-in num-out no-num-in no-num-out)
	       ((= (length sec) 4)
		(if numberedp (concat (car sec) "\n%s" (nth 1 sec))
		  (concat (nth 2 sec) "\n%s" (nth 3 sec)))))))
	   ;; Create a temporary export back-end that hard-codes
	   ;; "\underline" within "\section" and alike.
	   (section-back-end
	    (org-export-create-backend
	     :parent 'latex
	     :transcoders
	     '((underline . (lambda (o c i) (format "\\underline{%s}" c))))))
	   (text
	    (org-export-data-with-backend
	     (org-element-property :title headline) section-back-end info))
	   (todo
    (and (plist-get info :with-todo-keywords)
		 (let ((todo (org-element-property :todo-keyword headline)))
		   (and todo (org-export-data todo info)))))
	   (todo-type (and todo (org-element-property :todo-type headline)))
	   (tags (and (plist-get info :with-tags)
		      (org-export-get-tags headline info)))
	   (priority (and (plist-get info :with-priority)
			  (org-element-property :priority headline)))
	   ;; Create the headline text along with a no-tag version.
	   ;; The latter is required to remove tags from toc.
	   (full-text (funcall (plist-get info :latex-format-headline-function)
			       todo todo-type priority text tags info))
	   ;; Associate \label to the headline for internal links.
	   (headline-label (org-latex--label headline info t t))
	   (pre-blanks
	    (make-string (org-element-property :pre-blank headline) ?\n)))
      (if (or (not section-fmt) (org-export-low-level-p headline info))
	  ;; This is a deep sub-tree: export it as a list item.  Also
	  ;; export as items headlines for which no section format has
	  ;; been found.
	  (let ((low-level-body
		 (concat
		  ;; If headline is the first sibling, start a list.
		  (when (org-export-first-sibling-p headline info)
		    ;; (format "\\begin{%s}\n" (if numberedp 'enumerate 'itemize))) <===== CHANGED
		    (format "\\begin{%s}\n" 'itemize))
		  ;; Itemize headline
		  "\\item"
		  (and full-text
		       (string-match-p "\\`[ \t]*\\[" full-text)
		       "\\relax")
		  " " full-text "\n"
		  headline-label
		  pre-blanks
		  contents)))
	    ;; If headline is not the last sibling simply return
	    ;; LOW-LEVEL-BODY.  Otherwise, also close the list, before
	    ;; any blank line.
	    (if (not (org-export-last-sibling-p headline info)) low-level-body
	      (replace-regexp-in-string
	       "[ \t\n]*\\'"
	       ;; (format "\n\\\\end{%s}" (if numberedp 'enumerate 'itemize)) <====== CHANGED
	       (format "\n\\\\end{%s}" 'itemize)
	       low-level-body)))
	;; This is a standard headline.  Export it as a section.  Add
	;; an alternative heading when possible, and when this is not
	;; identical to the usual heading.
	(let ((opt-title
	       (funcall (plist-get info :latex-format-headline-function)
			todo todo-type priority
			(org-export-data-with-backend
			 (org-export-get-alt-title headline info)
			 section-back-end info)
			(and (eq (plist-get info :with-tags) t) tags)
			info))
	      ;; Maybe end local TOC (see `org-latex-keyword').
	      (contents
	       (concat
		contents
		(let ((case-fold-search t)
		      (section
		       (let ((first (car (org-element-contents headline))))
			 (and (eq (org-element-type first) 'section) first))))
		  (org-element-map section 'keyword
		    (lambda (k)
		      (and (equal (org-element-property :key k) "TOC")
			   (let ((v (org-element-property :value k)))
			     (and (string-match-p "\\<headlines\\>" v)
				  (string-match-p "\\<local\\>" v)
				  (format "\\stopcontents[level-%d]" level)))))
		    info t)))))
	  (if (and opt-title
		   (not (equal opt-title full-text))
		   (string-match "\\`\\\\\\(.+?\\){" section-fmt))
	      (format (replace-match "\\1[%s]" nil nil section-fmt 1)
		      ;; Replace square brackets with parenthesis
		      ;; since square brackets are not supported in
		      ;; optional arguments.
		      (replace-regexp-in-string
		       "\\[" "(" (replace-regexp-in-string "\\]" ")" opt-title))
		      full-text
		      (concat headline-label pre-blanks contents))
	    ;; Impossible to add an alternative heading.  Fallback to
	    ;; regular sectioning format string.
	    (format section-fmt full-text
		    (concat headline-label pre-blanks contents))))))))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; *** (? check) enable enumerations with a./b./c.
;;NOT DOOM ;;;  (setq org-list-allow-alphabetical t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; *** org-ref (--> citation management & pdflatex export)
;;NOT DOOM ;;;  (use-package org-ref
;;NOT DOOM ;;;     :ensure t)
;;NOT DOOM ;;;  ;; *** org export --> has to run bibtex also
;;NOT DOOM ;;;  (setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (setq org-latex-prefer-user-labels t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; *** my latex pdf export with hooked command from option #+export_pdf_hook (short-cut to f5)
;;NOT DOOM ;;;  ;;   (wrote this for automatic syncing on compilation in first place
;;NOT DOOM ;;;  ;;   like so: #+export_pdf_hook: rclone sync {} googledrive:ExistenzGruendungSacherFlitz)
;;NOT DOOM ;;;  ;;   or for autocompression with gs:
;;NOT DOOM ;;;  ;; #+export_pdf_hook: gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -sOutputFile=output.pdf {} && mv -f output.pdf {}

(defun js/org-export-latex-pdf-with-hook ()
  (interactive)
  (save-buffer)
  ;; export to pdf
  (org-latex-export-to-pdf)

  ;; apply my hooked process (syncing)
  (setq export_pdf_hook (org-kwd "EXPORT_PDF_HOOK"))
  (setq filename-base (file-name-base (buffer-file-name)))
  (setq pdffile-name (concat filename-base ".pdf"))
  ;; (message pdffile-name)
  ;; get the argument for export_hook
  ;; can be like so:
  ;; #+export_hook: rclone {} googledrive:ExistenzGruendungSacherFlitz
  ;; --> command to be executed "rclone {} googledrive:ExistenzGruendungSacherFlitz"
  ;; (message export_pdf_hook)
  ;; {} will be replaced by
  (setq export_pdf_hook_final (replace-regexp-in-string "{}" pdffile-name export_pdf_hook))
  (message (concat "apply export-pdf-hook, executing command: " export_pdf_hook_final " ; output in buffer: *org_export_pdf_hook_process_output*"))
  (async-shell-command export_pdf_hook_final "*org_export_pdf_hook_process_output*")
  )

;; **** use of 2 helper functions: org-kwds / org-kwd
;; (from: http://kitchingroup.cheme.cmu.edu/blog/2013/05/05/Getting-keyword-options-in-org-files/)
(defun org-kwds ()
  "parse the buffer and return a cons list of (property . value)
from lines like:
#+PROPERTY: value"
  (org-element-map (org-element-parse-buffer 'element) 'keyword
                   (lambda (keyword) (cons (org-element-property :key keyword)
                                           (org-element-property :value keyword)))))
(defun org-kwd (KEYWORD)
  "get the value of a KEYWORD in the form of #+KEYWORD: value"
  (cdr (assoc KEYWORD (org-kwds))))

;; **** make the output not pop-up
(add-to-list 'display-buffer-alist
  (cons "\\*org_export_pdf_hook_process_output*\\*.*" (cons #'display-buffer-no-window nil)))
;; **** define the "run-f5" short cut
(add-hook! 'org-mode-hook
              #'doom-disable-line-numbers-h)

(after! org
(map! :map org-mode-map "<f5>" 'js/org-export-latex-pdf-with-hook))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** evil org
;;NOT DOOM ;;; (use-package evil-org
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  (setq org-M-RET-may-split-line nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; ** make tab key work as org-cycle in terminal
;;NOT DOOM ;;;  (evil-define-key 'normal evil-jumper-mode-map (kbd "TAB") nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (add-hook 'org-mode-hook
;;NOT DOOM ;;;            (lambda ()
;;NOT DOOM ;;;              (org-indent-mode)
;;NOT DOOM ;;;              (visual-line-mode)))
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;; ** paste image from clipboard in org-mode
(defun js/org-insert-clipboard-image () ;; --> insert image after screenshooting to clipboard
  (interactive)
  (setq filename
        (concat
                  "screenshot_"
                  (format-time-string "%Y%m%d_%H%M%S") ".png"))
  (setq command_string (concat "xclip -selection clipboard -t image/png -o > " filename))
  (shell-command command_string)
  ;; (message concat("executed command: "  command_string))
  ;; insert new line with file ref
  (end-of-line)
  (newline)
  (insert (concat "[[./" filename "]]"))
  ;; (insert command_string)
  (org-display-inline-images)
  )

(map! :leader
      ;; :prefix ("i" . "+insert") ;; not necessary
      "i i" #'js/org-insert-clipboard-image)

;;NOT DOOM ;;; ;; (evil-leader/set-key "ln" 'planet-open-quick-notes)

;;
;;
;; begin "UNDOOMED" ;;;
;; * filefolder (own package/concept idea)
;; update:
;; started as: for the need to hide org files with inline images/ attachments / clutter
;; resulted to: a beautifull KISS optimal new concept for folder/file structure in general, for *any type of file* with any exyension
;; you can do it on any file system
;; but you can leverage emacs dired
;; see below for concept

;; deprecated 'hidden' structure
;; ==> in favor of 'normal' filefolders
;; (defun create-hidden-org-file-folder (&optional filebasename path)
;; "in dired -> create org mode file within hidden folder (of same name)
;; (we don t want all the \"junk\" to be seen, images, latex aux files, etc.)
;; (originally i wanted to additionally set a soft link to org file, but discarded that, because soft links are \"mistreated/violated\" by Dropbox)"
;;   (interactive)
;;    ;; * determine filename
;;    (if (not filebasename)
;;        (setq filebasename (read-string "Org-file-name (without .org-extension):"))
;;      )

;;    ;; * path
;;    (if (not path) ;; default --> put to current path
;;         (setq path (get-current-path))
;;      )
;;    ;; (if not already exists) create the hidden (dotted) folder with same name of org file
;;      (setq new-directory-full-name (concat (file-name-as-directory path) "." filebasename ".org"))
;;      (if (not (file-directory-p new-directory-full-name))
;;          (progn
;;          (make-directory new-directory-full-name)
;;           ;; create the org file within that folder
;;           (setq new-org-file-full-name (concat (file-name-as-directory new-directory-full-name) filebasename ".org"))
;;           ;; * create file (2 options)
;;           ;; ** option1: with-temp-buffer
;;           ;; (with-temp-buffer (write-file new-org-file-full-name)) ;; equivalent to >> echo "" > file
;;           ;; ** option2: write-region
;;           (write-region "" nil new-org-file-full-name) ;; equivalent to >> echo "" >> file
;;           ;; option2 safer, in case dayfile exists, content is not deleted
;;           )
;;        ;; else
;;         (message (concat "hidden folder \"" new-directory-full-name "\" already exists."))
;;         ;; return full file name of org file
;;        )
;; new-org-file-full-name)


(defun create-org-file-folder (&optional filebasename path)
"in dired -> create org mode file within folder (of same name)
(we don t want all the \"junk\" to be seen, images, latex aux files, etc.)
(originally i wanted to additionally set a soft link to org file, but discarded that, because soft links are \"mistreated/violated\" by Dropbox)"
  (interactive)
   ;; * determine filename
   (if (not filebasename)
       (setq filebasename (read-string "Org-file-name (without .org-extension):"))
     )

   ;; * path
   (if (not path) ;; default --> put to current path
        (setq path (get-current-path))
     )
   ;; (if not already exists) create the folder with same name of org file
     (setq new-directory-full-name (concat (file-name-as-directory path) filebasename ".org"))
     (if (not (file-directory-p new-directory-full-name))
         (progn
         (make-directory new-directory-full-name)
          ;; create the org file within that folder
          (setq new-org-file-full-name (concat (file-name-as-directory new-directory-full-name) filebasename ".org"))
          ;; * create file (2 options)
          ;; ** option1: with-temp-buffer
          ;; (with-temp-buffer (write-file new-org-file-full-name)) ;; equivalent to >> echo "" > file
          ;; ** option2: write-region
          (write-region "" nil new-org-file-full-name) ;; equivalent to >> echo "" >> file
          ;; option2 safer, in case dayfile exists, content is not deleted
          )
       ;; else
        (message (concat "hidden folder \"" new-directory-full-name "\" already exists."))
        ;; return full file name of org file
       )
new-org-file-full-name)

;; ** hidden org folder stuff (so i have everything of that "org-document" in one folder like: images, raw-files, latex-export auxiliary files etc.)
;; (update: it resulted that the 'hidden structure' was a bad idea
;;          symlink fragility
;;          dot-files have a different traditional meaning: more config files, not data
;;          symlinks dont work in dropbox
;;          to much overhead: in file-explorer/dired you are shown double filenames -> annoying
;;          -> so full benefits on 'normal' folder name, but with file extension
;;          e.g. |_ doc.org
;;               |_ article1.pdf
;;
;;          so, when in in dired
;;                 if on off.ext
;;                    open off.ext/off.ext
;;                 if in off.ext
;;                    open off.ext
;;                (off=file base name)
;;                (ext=file extension)
;;          well... it s only for dired :D
;;
(defun filefolder-string-is-a-filefolder (str)
  ;; quit the trailing "/" if dir
  (if (file-directory-p str)
      (setq str (directory-file-name str)))
  (cond ((not (file-directory-p str))
         (message (concat "not a filefolder, cause not a directory: " str))
         nil)
        ;; test: (setq str "custom.org")
        ;; test: (setq str "emacs_demo.org")
        ;; test: (setq str "planet")
        ((not (file-name-extension str))
        (message (concat "not a filefolder, cause has no extension: " str))
        nil)
        (t
         (message "it s a filefolder")
         t)))
;;  A    dir.ext
;;  test
;; (filefolder-string-is-a-filefolder "planet") ;; => nil
;; (filefolder-string-is-a-filefolder "emacs_demo.org") ;; => t
;; (filefolder-string-is-a-filefolder "custom.org") ;; => nil
(defun filefolder-open ()
  (interactive)
  ;; test1:
  ;; (setq file-under-point "emacs_demo.org")
  ;; (setq parent-dir "MyEmacsConfig")
  ;; test2:
  ;; (setq file-under-point "emacs_demo.org")
  ;; (setq parent-dir "emacs_demo.org")
  ;; test (defun test () (interactive) (message (dired-get-filename)))
  ;; test (defun test () (interactive) (message (dired-get-file-for-visit)))
  (setq filefullname (dired-get-filename)) ;;under point
  (setq parent-dir (file-name-directory filefullname))
  (message (concat "filefullname:" filefullname))
  (message (concat "parent-dir:" parent-dir))
  (cond ((filefolder-string-is-a-filefolder filefullname)
  (setq filename (file-name-nondirectory filefullname))
         (message "on a filefolder")
         (find-file (concat filefullname "/" filename)))
        ((filefolder-string-is-a-filefolder parent-dir)
(message "in a filefolder")
  (setq filename (file-name-nondirectory (directory-file-name parent-dir))) ;; quit trailing "/" here is done first
 (setq folderedfile (concat parent-dir filename))
         ;; always assume ffn.ext/ffn.ext
         (message (concat "visit folderedfile: " folderedfile))
         (find-file folderedfile))
        (t (message "not on filefolder, nor in filefolder"))))
;;
;;

;;NOT DOOM ;;;  ;; ** hidden org folder stuff (so i have everything of that "org-document" in one folder like: images, raw-files, latex-export auxiliary files etc.)
;;NOT DOOM ;;;  (defun create-symlink-for-hidden-org-file-folder (&optional orgdotfolder-full)
;;NOT DOOM ;;;     (interactive)
;;NOT DOOM ;;;     (setq orgdotfolder (file-name-nondirectory orgdotfolder-full))
;;NOT DOOM ;;;     ;; create softlink --> discarded, see above
;;NOT DOOM ;;;     (when (string-match "^\.\\(.*\\)\.org$" orgdotfolder)
;;NOT DOOM ;;;       (setq filebasename (match-string 1 file))
;;NOT DOOM ;;;       (setq link-name (concat default-directory "/" filebasename ".org"))
;;NOT DOOM ;;;       (setq target-name (concat "./." filebasename ".org/" filebasename ".org" )) ;; relative path to org file in hidden folder
;;NOT DOOM ;;;       (when (not (file-exists-p link-name))
;;NOT DOOM ;;;         (make-symbolic-link target-name link-name)
;;NOT DOOM ;;;         )
;;NOT DOOM ;;;       )
;;NOT DOOM ;;;     )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun create-symlinks-for-all-hidden-org-file-folders (&optional path)
;;NOT DOOM ;;;     (interactive)
;;NOT DOOM ;;;     ;; process opt. arg
;;NOT DOOM ;;;     (when (not path)
;;NOT DOOM ;;;       (setq path (get-current-path))
;;NOT DOOM ;;;       )
;;NOT DOOM ;;;
;;NOT DOOM ;;;      ;; later restore default-directory (don t know if necessary...)
;;NOT DOOM ;;;     (setq original-default-directory default-directory)
;;NOT DOOM ;;;     (cd path)
;;NOT DOOM ;;;     (setq files (directory-files default-directory))
;;NOT DOOM ;;;     (setq N (length files))
;;NOT DOOM ;;;     (setq i 0)
;;NOT DOOM ;;;     (while (< i N)
;;NOT DOOM ;;;       (setq file (nth i files))
;;NOT DOOM ;;;       (when (file-directory-p file)
;;NOT DOOM ;;;         (when (string-match "^\..*\.org$" file)
;;NOT DOOM ;;;           (setq orgfilefolder-full (concat default-directory "/" file))
;;NOT DOOM ;;;           (create-symlink-for-hidden-org-file-folder orgfilefolder-full)
;;NOT DOOM ;;;           ;; (setq filebasename (match-string 1 file))
;;NOT DOOM ;;;           ;; (setq link-name (concat default-directory "/" filebasename ".org"))
;;NOT DOOM ;;;           ;; (setq target-name (concat "./." filebasename ".org/" filebasename ".org" )) ;; relative path to org file in hidden folder
;;NOT DOOM ;;;           ;; (when (not (file-exists-p link-name))
;;NOT DOOM ;;;           ;;   (make-symbolic-link target-name link-name)
;;NOT DOOM ;;;           ;;   )
;;NOT DOOM ;;;           )
;;NOT DOOM ;;;         )
;;NOT DOOM ;;;       (setq i (1+ i))
;;NOT DOOM ;;;       )
;;NOT DOOM ;;;     (cd original-default-directory)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun delete-all-symbolic-links (&optional path)
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;     (when (not path)
;;NOT DOOM ;;;       (setq path (get-current-path))
;;NOT DOOM ;;;       )
;;NOT DOOM ;;;
;;NOT DOOM ;;;      ;; later restore default-directory (don t know if necessary...)
;;NOT DOOM ;;;     (setq original-default-directory default-directory)
;;NOT DOOM ;;;     (cd path)
;;NOT DOOM ;;;     (setq files (directory-files default-directory))
;;NOT DOOM ;;;     (setq N (length files))
;;NOT DOOM ;;;     (setq i 0)
;;NOT DOOM ;;;     (while (< i N)
;;NOT DOOM ;;;       (setq file (nth i files))
;;NOT DOOM ;;;       (when (file-symlink-p file)
;;NOT DOOM ;;;         (delete-file file)
;;NOT DOOM ;;;         )
;;NOT DOOM ;;;       (setq i (1+ i))
;;NOT DOOM ;;;       )
;;NOT DOOM ;;;     (cd original-default-directory)
;;NOT DOOM ;;;     )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun create-hidden-org-file-folder-with-symlink (&optional filename)
;;NOT DOOM ;;;     (interactive)
;;NOT DOOM ;;;     (if (not filename)
;;NOT DOOM ;;;         (setq filename (read-string "Org-file-name (without .org-extension):"))
;;NOT DOOM ;;;       )
;;NOT DOOM ;;;     ;; create dot-folder (above function)
;;NOT DOOM ;;;     (dired-create-org-file-hidden-folder)
;;NOT DOOM ;;;     ;; create softlink --> discarded, see above
;;NOT DOOM ;;;     (setq target-name (concat "./." filename ".org/" filename ".org" )) ;; relative path to org file in hidden folder
;;NOT DOOM ;;;     (setq link-name (concat currentpath "/" filename ".org"))
;;NOT DOOM ;;;     (make-symbolic-link target-name link-name)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun get-current-path ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (cond ( (equal major-mode 'dired-mode)
;;NOT DOOM ;;;  	      (setq currentpath (dired-current-directory))
;;NOT DOOM ;;;  	)
;;NOT DOOM ;;;  	( (equal major-mode 'term-mode)
;;NOT DOOM ;;;  	     (setq currentpath default-directory)
;;NOT DOOM ;;;  	)
;;NOT DOOM ;;;  	(t ;; else
;;NOT DOOM ;;;  	     (setq currentpath (file-name-directory buffer-file-name))
;;NOT DOOM ;;;  	)
;;NOT DOOM ;;;     )
;;NOT DOOM ;;;   currentpath)
;;NOT DOOM ;;;
(defun js/org-preamble-default-insert ()
  (interactive)
  ;; allow bindings to work "#BIND+ ...
  (setq org-export-allow-bind-keywords t)
  (insert (concat
         "#+title: <title>" "\n"
         "#+options: num:t" "\n"
         "#+options: toc:t" "\n"
         "#+options: H:2" "\n"
         "#+options: \\n:t" "\n"
         "# itemize all bullets" "\n"
         "#+LATEX_HEADER: \\renewcommand{\\labelitemi}{$\\bullet$}" "\n"
         "#+LATEX_HEADER: \renewcommand{\labelitemii}{$\circ$}" "\n"
         "#+LATEX_HEADER: \\renewcommand{\\labelitemiii}{$\\bullet$}" "\n"
         "#+LATEX_HEADER: \\renewcommand{\\labelitemiv}{$\\bullet$}" "\n"
         "#+LATEX_HEADER: \\usepackage[parfill]{parskip}" "\n"
         "#+BIND: org-latex-image-default-width \".98\\linewidth\"" "\n"
         "#+BIND: org-latex-image-default-width \"9cm\"" "\n"
        ;; "# other export language (mind "for technical reasons" has to be first english than ngerman, otherwise english, whyever.. latex-"bug")"
         "#+LATEX_HEADER: \\usepackage[english, ngerman]{babel}" "\n"
         )))
;;NOT DOOM ;;;  ;; ** default LATEX_HEADER
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; *** allow bindings to work "#BIND+ ..."
;;NOT DOOM ;;;  (setq org-export-allow-bind-keywords t)
;;NOT DOOM ;;;  ;; (not code, just doc here)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; #+title: <title>
;;NOT DOOM ;;;  ;; #
;;NOT DOOM ;;;  ;; # options:
;;NOT DOOM ;;;  ;; #+options: num:t
;;NOT DOOM ;;;  ;; #+options: toc:t
;;NOT DOOM ;;;  ;; #+options: H:2
;;NOT DOOM ;;;  ;; #
;;NOT DOOM ;;;  ;; # itemize all bullets
;;NOT DOOM ;;;  ;; #+LATEX_HEADER: \renewcommand{\labelitemi}{$\bullet$}
;;NOT DOOM ;;;  ;; #+LATEX_HEADER: \renewcommand{\labelitemii}{$\bullet$}
;;NOT DOOM ;;;  ;; #+LATEX_HEADER: \renewcommand{\labelitemiii}{$\bullet$}
;;NOT DOOM ;;;  ;; #+LATEX_HEADER: \renewcommand{\labelitemiv}{$\bullet$}
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; #+BIND: org-latex-image-default-width ".98\\linewidth"
;;NOT DOOM ;;;  ;; # or
;;NOT DOOM ;;;  ;; #+BIND: org-latex-image-default-width "9cm"
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; # other export language (mind "for technical reasons" has to be first english than ngerman, otherwise english, whyever.. latex-"bug")
;;NOT DOOM ;;;  ;; #+LATEX_HEADER: \usepackage[english, ngerman]{babel}
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** make sure emacs visits the target of a link (otherwise currentpath is wrong -> problem with pasting images)
;;NOT DOOM ;;;  (setq find-file-visit-truename t)
;;NOT DOOM ;;;
;; org-mode inline images appearance
(setq org-image-actual-width 300) ;; --> makes images more readable, for closer look, just open in image viewer

(defun js/org-image-set-width ()
  (interactive)
  (setq org-image-new-width (read-number "Set width in pxls (e.g. 300): "))
  (setq org-image-actual-width org-image-new-width)
  (org-redisplay-inline-images)
  (message (concat "org inline image width set to: " (number-to-string org-image-new-width)))
  )


(defun js/org-image-increase-width ()
  (interactive)
  (setq org-image-new-width (round (* 1.5 org-image-actual-width)))
  (setq org-image-actual-width org-image-new-width)
  (org-redisplay-inline-images)
)


(defun js/org-image-decrease-width ()
  (interactive)
  (setq org-image-new-width (round (* 0.66 org-image-actual-width)))
  (setq org-image-actual-width org-image-new-width)
  (org-redisplay-inline-images)
)


(map! :map 'org-mode-map
      :n "z=" #'js/org-image-increase-width
      :n "z-" #'js/org-image-decrease-width)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** org mode startup appearance
;;NOT DOOM ;;;  ;; *** org mode pretty entities (arrows and stuff)
;;NOT DOOM ;;;  ;; (setq org-pretty-entities t)
;;NOT DOOM ;;;  (setq org-pretty-entities nil)
;;NOT DOOM ;;;  ;; *** show inline images
;;NOT DOOM ;;;  (setq org-startup-with-inline-images t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** emphasis markers -> outcommented -> decided to not mess around with that, since this belongs to org-mode convention!
;;NOT DOOM ;;;  ;; --> need another solution to highlight important text with background (red/green/etc.) -> todo
;;NOT DOOM ;;;  ;; (setq org-hide-emphasis-markers t)
;;NOT DOOM ;;;  ;; (setq org-emphasis-alist
;;NOT DOOM ;;;  ;; (quote (("*" bold)
;;NOT DOOM ;;;  ;; ("/" italic)
;;NOT DOOM ;;;  ;; ("_" underline)
;;NOT DOOM ;;;  ;; ("=" (:foreground "white" :background "red"))
;;NOT DOOM ;;;  ;; ("|" (:foreground "white" :background "green"))
;;NOT DOOM ;;;  ;; ("!" (:foreground "white" :background "green"))
;;NOT DOOM ;;;  ;; ("&" (:foreground "white" :background "green"))
;;NOT DOOM ;;;  ;; ("\\" (:foreground "white" :background "green"))
;;NOT DOOM ;;;  ;; ("°" (:foreground "white" :background "green"))
;;NOT DOOM ;;;  ;; (">" (:foreground "white" :background "green"))
;;NOT DOOM ;;;  ;; ("?" (:foreground "white" :background "green"))
;;NOT DOOM ;;;  ;; ("€" (:foreground "white" :background "green"))
;;NOT DOOM ;;;  ;; ("~" org-verbatim verbatim)
;;NOT DOOM ;;;  ;; ("+"
;;NOT DOOM ;;;  ;; (:strike-through t))
;;NOT DOOM ;;;  ;; )))
;;NOT DOOM ;;;  ;; ( org-set-emph-re)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** add some new labels
;;NOT DOOM ;;;  (setq org-todo-keywords
;;NOT DOOM ;;;        '((sequence
;;NOT DOOM ;;;           "DONE"
;;NOT DOOM ;;;           "CANCELED"
;;NOT DOOM ;;;           "DEFERRED"
;;NOT DOOM ;;;           "ANSWERED"
;;NOT DOOM ;;;           "QUESTION"
;;NOT DOOM ;;;           "DONEBEFORE"
;;NOT DOOM ;;;           "NEXTDAY"
;;NOT DOOM ;;;           "CHOICE"
;;NOT DOOM ;;;           "DISCARDED"
;;NOT DOOM ;;;           "PROGRESS..."
;;NOT DOOM ;;;           "CLOCKED IN..."
;;NOT DOOM ;;;           "CURRENT..."
;;NOT DOOM ;;;           "WAITING"
;;NOT DOOM ;;;           "TODO"
;;NOT DOOM ;;;           )))
;;NOT DOOM ;;;
;;NOT DOOM ;;;    (setq org-todo-keyword-faces
;;NOT DOOM ;;;      '(("PROJ" :background "blue" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("TODO" :background "red1" :foreground "white" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("QUESTION" :background "orange" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("NEXT" :background "red1" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("CURRENT..." :background "orange" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("CLOCKED IN..." :background "orange" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("DISCARDED" :background "grey" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("WAITING" :background "yellow" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("PROGRESS..." :background "yellow" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("DEFERRED" :background "green" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("DONEBEFORE" :background "grey" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("NEXTDAY" :background "pink" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("DELEGATED" :background "gold" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("MAYBE" :background "gray" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("APPT" :background "red1" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("DONE" :background "forest green" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("CHOICE" :background "forest green" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("BESTCHOICE" :background "forest green" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("ANSWERED" :background "forest green" :weight bold :box (:line-width 2 :style released-button))
;;NOT DOOM ;;;        ("CANCELED" :background "grey" :foreground "black" :weight bold :box (:line-width 2 :style released-button))))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; evil org-mode
;;NOT DOOM ;;;  ;; (evil-leader/set-key-for-mode 'org-mode "l" 'org-preview-latex-fragment)
;;NOT DOOM ;;;  ;; (evil-leader/set-key "l" 'org-preview-latex-fragment)
;;NOT DOOM ;;;  ;; ** appearance/fonts/colors
;;NOT DOOM ;;;  ;; *** keyword/properties/codeblock stuff -> unobtrusive
;;NOT DOOM ;;;  (set-face-attribute 'org-drawer nil :foreground "#5f5f5f")
;;NOT DOOM ;;;  (set-face-attribute 'org-special-keyword nil :foreground "#afafaf")
;;NOT DOOM ;;;  (set-face-attribute 'org-block-begin-line nil :foreground "#5f5f5f")
;;NOT DOOM ;;;  (set-face-attribute 'org-meta-line nil :foreground "#5f5f5f")
;;NOT DOOM ;;;  (set-face-attribute 'org-level-1 nil :foreground "#DCDCCC" :weight 'normal)
;;NOT DOOM ;;;  (set-face-attribute 'org-level-2 nil :foreground "#DCDCCC" :weight 'normal)
;;NOT DOOM ;;;  (set-face-attribute 'org-level-3 nil :foreground "#DCDCCC" :weight 'normal)
;;NOT DOOM ;;;  (set-face-attribute 'org-level-4 nil :foreground "#DCDCCC")
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (set-face-attribute 'org-level-1 nil :foreground "color-141" :weight 'bold)
;;NOT DOOM ;;;  ;; (set-face-attribute 'org-level-2 nil :foreground "color-105" :weight 'bold)
;;NOT DOOM ;;;  ;; (set-face-attribute 'org-level-3 nil :foreground "color-147" :weight 'bold)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (set-face-attribute 'org-link nil :foreground "#5fffff")
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** basic behaviour keybindings (implementation via "literal-key-funs)
;;NOT DOOM ;;;  ;; comment on concept:
;;NOT DOOM ;;;  ;; org has organized "key binding behavior with functions like org-return" so the keys are doing different stuff in different contexts (heading/item/table) . since i m using evil, this "layer" would have to be replaced completely by my own layer (functions) for each mode: myorgevil-insert-return/ myorgevil-normal-return/ myorgevil-visual-return, with this logic.
;;NOT DOOM ;;;  ;; however, i ll keep the original layer as a "fall back" by cond-statements "else -> fallback (e.g. org-metareturn).
;;NOT DOOM ;;;  ;; *** normal state
;;NOT DOOM ;;; ;; **** SPC-RET -> open-links
;;NOT DOOM ;;;  ;; **** enter
;;NOT DOOM ;;; (evil-define-key 'normal org-mode-map (kbd "RET") 'myorgevil-normal-RET)
;;NOT DOOM ;;;  (defun myorgevil-normal-RET ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (cond
;;NOT DOOM ;;; 	;; at heading
;;NOT DOOM ;;; 	((org-at-heading-p)
;;NOT DOOM ;;; 	 (org-meta-return))
;;NOT DOOM ;;; 	;; at plain list item
;;NOT DOOM ;;; 	((org-at-item-p)
;;NOT DOOM ;;; 	(org-meta-return)
;;NOT DOOM ;;; 	(evil-insert-state))
;;NOT DOOM ;;; 	;; "fallback"
;;NOT DOOM ;;; 	(t
;;NOT DOOM ;;; 	;; (org-return))))
;;NOT DOOM ;;; 	(org-meta-return)))) ;; i prefer this -> open new org file and "enter" -> pop new heading -> "p" paste sth
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; **** C-l/L (demote)
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "C-l") 'myorgevil-normal-C-l)
;;NOT DOOM ;;;  (defun myorgevil-normal-C-l ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (cond
;;NOT DOOM ;;;     ;; at plain list item -> new item same level
;;NOT DOOM ;;;     ((org-at-item-p)
;;NOT DOOM ;;;      (org-metaright)
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;     ;; "fallback"
;;NOT DOOM ;;;     (t
;;NOT DOOM ;;;      (org-metaright))))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "C-S-l") 'myorgevil-normal-C-L)
;;NOT DOOM ;;;  (defun myorgevil-normal-C-L ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (cond
;;NOT DOOM ;;;     ;; at plain list item -> new item same level
;;NOT DOOM ;;;     ((org-at-item-p)
;;NOT DOOM ;;;      (org-shiftmetaright)
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;     ;; "fallback"
;;NOT DOOM ;;;     (t
;;NOT DOOM ;;;      (org-shiftmetaright))))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; **** C-h/H (promote)
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "C-h") 'myorgevil-normal-C-h)
;;NOT DOOM ;;;  (defun myorgevil-normal-C-h ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (cond
;;NOT DOOM ;;;     ;; at plain list item -> new item same level
;;NOT DOOM ;;;     ((org-at-item-p)
;;NOT DOOM ;;;      (org-metaleft)
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;     ;; "fallback"
;;NOT DOOM ;;;     (t
;;NOT DOOM ;;;      (org-metaleft))))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "C-S-h") 'myorgevil-normal-C-H)
;;NOT DOOM ;;;  (defun myorgevil-normal-C-H ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (cond
;;NOT DOOM ;;;     ;; at plain list item -> new item same level
;;NOT DOOM ;;;     ((org-at-item-p)
;;NOT DOOM ;;;      (org-shiftmetaleft)
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;     ;; "fallback"
;;NOT DOOM ;;;     (t
;;NOT DOOM ;;;      (org-shiftmetaleft))))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; **** M-RET
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "M-RET") 'myorgevil-normal-M-RET)
;;NOT DOOM ;;;  (defun myorgevil-normal-M-RET ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (cond
;;NOT DOOM ;;;     ;; at plain list item -> new item same level
;;NOT DOOM ;;;     ((org-at-item-p)
;;NOT DOOM ;;;      (org-meta-return)
;;NOT DOOM ;;;      (evil-insert-state)
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;     ;; at plain heading -> new item same level
;;NOT DOOM ;;;     ((org-at-heading-p)
;;NOT DOOM ;;;      (org-meta-return)
;;NOT DOOM ;;;     (evil-insert-state)
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;     ;; "fallback"
;;NOT DOOM ;;;     (t
;;NOT DOOM ;;;      (org-return))
;;NOT DOOM ;;;    ))
;;NOT DOOM ;;;  ;; *** insert state
;;NOT DOOM ;;;  ;; **** M-RET
;;NOT DOOM ;;;  (evil-define-key 'insert org-mode-map (kbd "M-RET") 'myorgevil-insert-M-RET)
;;NOT DOOM ;;;  (defun myorgevil-insert-M-RET ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (cond
;;NOT DOOM ;;;     ;; at plain list item -> new item same level
;;NOT DOOM ;;;     ((org-at-item-p)
;;NOT DOOM ;;;      (org-meta-return)
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;     ;; at plain heading -> new item same level
;;NOT DOOM ;;;     ((org-at-heading-p)
;;NOT DOOM ;;;      (org-meta-return)
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;     ;; "fallback"
;;NOT DOOM ;;;     (t
;;NOT DOOM ;;;      (org-return))
;;NOT DOOM ;;;    ))
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; **** C-l (demote)
;;NOT DOOM ;;;  (evil-define-key 'insert org-mode-map (kbd "C-l") 'myorgevil-normal-C-l)
;;NOT DOOM ;;;  (defun myorgevil-insert-C-l ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (myorgevil-normal-C-l))
;;NOT DOOM ;;;  ;; **** C-h (promote)
;;NOT DOOM ;;;  (evil-define-key 'insert org-mode-map (kbd "C-h") 'myorgevil-normal-C-h)
;;NOT DOOM ;;;  (defun myorgevil-insert-C-h ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (myorgevil-normal-C-h))
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun myorg-meta-return-enter-insert-state ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (org-meta-return)
;;NOT DOOM ;;;    (evil-insert-state)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** copy/paste - behavior
;;NOT DOOM ;;;  (evil-define-key 'insert org-mode-map (kbd "C-p") 'evil-paste-after)
;;NOT DOOM ;;;  ;; ** basic navigation, consistent evil
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "L") 'org-shiftright)
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "M-RET") 'myorg-return)
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "H") 'org-shiftleft)
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "C-K") 'org-shiftup)
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "C-J") 'org-shiftdown) ;; leave "J" for joining lines
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;exception: M-h/j/k/l are reserved for window-management --> map to C-h/j/k/l
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "C-l") 'org-metaright)
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "C-h") 'org-metaleft)
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "C-k") 'org-metaup)
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "C-j") 'org-metadown)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (evil-define-key 'insert org-mode-map (kbd "C-l") 'org-metaright)
;;NOT DOOM ;;;  (evil-define-key 'insert org-mode-map (kbd "C-h") 'org-metaleft)
;;NOT DOOM ;;;  (evil-define-key 'insert org-mode-map (kbd "C-k") 'org-metaup)
;;NOT DOOM ;;;  (evil-define-key 'insert org-mode-map (kbd "C-j") 'org-metadown)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (evil-define-key 'normal org-mode-map (kbd "left") 'dummy-message)
;;NOT DOOM ;;;  (defun dummy-message ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (message "this is a message from dummy-message")
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "C-l") 'org-shiftmetaright)
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "C-h") 'org-shiftmetaleft)
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "M-K") 'org-shiftmetaup)
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "M-J") 'org-shiftmetadown)
;;NOT DOOM ;;;
;;NOT DOOM ;;; (js/leader-def :keymaps 'org-mode-map "*" 'org-toggle-heading)
;;NOT DOOM ;;; (js/leader-def :keymaps 'org-mode-map "8" 'org-toggle-heading) ;; lazy, 8 for *
;;NOT DOOM ;;;
;; ** org variable pitch for text
(cond ((equal myhost "laptop")
       (setq doom-variable-pitch-font (font-spec :family "Cantarell"))
       (add-hook! org-mode
	(mixed-pitch-mode 1))
))
;; ** org -> hide emphasis markers
(setq org-hide-emphasis-markers t)
;;NOT DOOM ;;;  ;; new emphasis-markers
;;NOT DOOM ;;;  (add-to-list 'org-emphasis-alist
;;NOT DOOM ;;;               '("^" (:foreground "red")
;;NOT DOOM ;;;                 ))
;;NOT DOOM ;;;
;;not DOOM ;;;  ;; * outshine mode (org-mode outlining in code-files)
;;NOT DOOM ;;; (use-package org
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;; (use-package outshine
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  ;; ** TODO ellipsis set to " ▾"
;;NOT DOOM ;;;  ;; this did not work (var doesnt exist):
;;NOT DOOM ;;;  ;; (setq outshine-ellipsis " ▾")
;;NOT DOOM ;;;  ;; ** INFO -> this is all the stuff that works (https://orgmode.org/worg/org-tutorials/org-outside-org.html):
;;NOT DOOM ;;;  ;; C-c 	PrefixCommand
;;NOT DOOM ;;;  ;; <M-down> 	outline-next-visible-heading
;;NOT DOOM ;;;  ;; <M-left> 	outline-hide-more
;;NOT DOOM ;;;  ;; <M-right> 	outline-show-more
;;NOT DOOM ;;;  ;; <M-up> 	outline-previous-visible-heading
;;NOT DOOM ;;;  ;; <tab> 	outshine-cycle
;;NOT DOOM ;;;  ;; <backtab> 	outshine-cycle-buffer
;;NOT DOOM ;;;  ;; C-c C-a 	show-all
;;NOT DOOM ;;;  ;; C-c C-b 	outline-backward-same-level
;;NOT DOOM ;;;  ;; C-c C-c 	hide-entry
;;NOT DOOM ;;;  ;; C-c C-d 	hide-subtree
;;NOT DOOM ;;;  ;; C-c C-e 	show-entry
;;NOT DOOM ;;;  ;; C-c C-f 	outline-forward-same-level
;;NOT DOOM ;;;  ;; C-c TAB 	show-children
;;NOT DOOM ;;;  ;; C-c C-k 	show-branches
;;NOT DOOM ;;;  ;; C-c C-l 	hide-leaves
;;NOT DOOM ;;;  ;; C-c RET 	outline-insert-heading
;;NOT DOOM ;;;  ;; C-c C-n 	outline-next-visible-heading
;;NOT DOOM ;;;  ;; C-c C-o 	outline-hide-other
;;NOT DOOM ;;;  ;; C-c C-p 	outline-previous-visible-heading
;;NOT DOOM ;;;  ;; C-c C-q 	outline-hide-sublevels
;;NOT DOOM ;;;  ;; C-c C-s 	show-subtree
;;NOT DOOM ;;;  ;; C-c C-t 	hide-body
;;NOT DOOM ;;;  ;; C-c C-u 	outline-up-heading
;;NOT DOOM ;;;  ;; C-c C-v 	outline-move-subtree-down
;;NOT DOOM ;;;  ;; C-c C-^ 	outline-move-subtree-up
;;NOT DOOM ;;;  ;; C-c ' 	outorg-edit-as-org
;;NOT DOOM ;;;  ;; C-c @ 	outline-mark-subtree
;;NOT DOOM ;;;  ;; C-c I 	outline-previous-visible-heading
;;NOT DOOM ;;;  ;; C-c J 	outline-hide-more
;;NOT DOOM ;;;  ;; C-c K 	outline-next-visible-heading
;;NOT DOOM ;;;  ;; C-c L 	outline-show-more
;;NOT DOOM ;;;  ;; C-c C-< 	outline-promote
;;NOT DOOM ;;;  ;; C-c C-> 	outline-demote
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun outshine-calc-outline-regexp ()
;;NOT DOOM ;;;    ;; FIXME: Rename function.
;;NOT DOOM ;;;    "Return the outline regexp for the current mode."
;;NOT DOOM ;;;     (concat " *" (when (and outshine-regexp-outcommented-p
;;NOT DOOM ;;;                       (or comment-start
;;NOT DOOM ;;;                           ;; MAYBE: Should this be `warn'?
;;NOT DOOM ;;;                           (message (concat "Cannot calculate outcommented outline-regexp without `comment-start' character defined"))))
;;NOT DOOM ;;;              (concat " *" (regexp-quote (outshine-calc-comment-region-starter)) ;; modified
;;NOT DOOM ;;;  		    "*" ;; modified
;;NOT DOOM ;;;  		    ;; "[^\\s]*"
;;NOT DOOM ;;;  		    "[^ ]*" ;; somehow working for %%T but not %%TT (todo with outline-end-of-subtree, but hard to debug, and one char suffices, just a nice to have anyway)
;;NOT DOOM ;;;  		    (if outshine-enforce-no-comment-padding-p
;;NOT DOOM ;;;                          ""
;;NOT DOOM ;;;                        (outshine-calc-comment-padding))))
;;NOT DOOM ;;;            outshine-normalized-outline-regexp-base
;;NOT DOOM ;;;            " "))
;;NOT DOOM ;;;    ;; ** TODOS
;;NOT DOOM ;;;  ;; *** DONE [outshine-cycle does it] cycling bug -> children only first
;;NOT DOOM ;;;  ;; *** DONE allow preceding whitespaces / allow variable nr of comment-chars (not by default), e.g. "### ** heading", at the moment he needs "# ** header" to work fully
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; *** [need to make own lowlevel fun regexp insert etc.] make heading of comment -> SPC-8
;;NOT DOOM ;;;  ;; *** DONE better colors
;;NOT DOOM ;;;  ;;    i d like to keep regular code color, just add a little "sth", prepend and format the leading stars rather, or not at all. maybe just make code bold.
;;NOT DOOM ;;;  ;; *** DONE allow for any additional non-whitespace chars directly after comment-char (so i can use for comment categories (important/side-note/workaround/etc.)
;;NOT DOOM ;;;  ;; *** functions to format properly headings
;;NOT DOOM ;;;  ;; **** "***heading" -> "*** heading"
;;NOT DOOM ;;;   ;; " s/\(\*++\)\([^ *]\{1\}\)/; \1 \2/g")
;;NOT DOOM ;;;  ;; ****  "%%*" --> "%% *"
;;NOT DOOM ;;;  ;; (setq myhost (getenv "MYHOST"))
;;NOT DOOM ;;;  ;; (cond
;;NOT DOOM ;;;  ;;  ((equal myhost "phone") (message "on phone -> quelpa not set"))
;;NOT DOOM ;;;  ;;  (t (progn
;;NOT DOOM ;;;  ;;       (message "no phone")
;;NOT DOOM ;;;  ;;       (use-package outshine
;;NOT DOOM ;;;  ;; 	:quelpa (outshine :fetcher github :repo "alphapapa/outshine"))
;;NOT DOOM ;;;  ;;       )))
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** bindings (-> same as my org-mode workflow)
;;NOT DOOM ;;;  ;; *** demote/promote C-h/C-l
;;NOT DOOM ;;; (use-package org
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  (evil-define-key 'normal outshine-mode-map (kbd "C-h") 'outline-promote)
;;NOT DOOM ;;;  (evil-define-key 'normal outshine-mode-map (kbd "C-l") 'outline-demote)
;;NOT DOOM ;;;  ;; *** levels 1/2/3 -> SPC l 1/2/3
;;NOT DOOM ;;; (js/leader-def "o0" 'outline-show-all)
;;NOT DOOM ;;; (js/leader-def "o1" (lambda () (interactive) (outshine-cycle-buffer 1)))
;;NOT DOOM ;;; (js/leader-def "o2" (lambda () (interactive) (outshine-cycle-buffer 2)))
;;NOT DOOM ;;; (js/leader-def "o3" (lambda () (interactive) (outshine-cycle-buffer 3)))
;;NOT DOOM ;;; (js/leader-def "o4" (lambda () (interactive) (outshine-cycle-buffer 4)))
;;NOT DOOM ;;; (js/leader-def "o5" (lambda () (interactive) (outshine-cycle-buffer 5)))
;;NOT DOOM ;;; (js/leader-def "o6" (lambda () (interactive) (outshine-cycle-buffer 6)))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; *** tab -> outshine-cycle
;;NOT DOOM ;;;  (evil-define-minor-mode-key 'normal 'outshine-mode (kbd "TAB") 'outshine-cycle)
;;NOT DOOM ;;;  ;; ** appearance
;;NOT DOOM ;;;  ;; *** style headings
;;NOT DOOM ;;;  (set-face-attribute 'outshine-level-1 nil :foreground "color-141" :weight 'bold)
;;NOT DOOM ;;;  (set-face-attribute 'outshine-level-2 nil :foreground "color-105" :weight 'bold)
;;NOT DOOM ;;;  (set-face-attribute 'outshine-level-3 nil :foreground "color-147" :weight 'bold)
;;NOT DOOM ;;;  ;; color-176
;;NOT DOOM ;;;
;;NOT DOOM ;;;   ;; color-160
;;NOT DOOM ;;;   ;; color-161
;;NOT DOOM ;;;   ;; color-162
;;NOT DOOM ;;;   ;; color-163
;;NOT DOOM ;;;   ;; color-164
;;NOT DOOM ;;;   ;; color-165
;;NOT DOOM ;;;   ;; color-166
;;NOT DOOM ;;;   ;; color-167
;;NOT DOOM ;;;   ;; color-168
;;NOT DOOM ;;;   ;; color-169
;;NOT DOOM ;;;   ;; color-170
;;NOT DOOM ;;;   ;; color-171
;;NOT DOOM ;;;   ;; color-172
;;NOT DOOM ;;;   ;; color-173
;;NOT DOOM ;;;   ;; color-174
;;NOT DOOM ;;;   ;; color-175
;;NOT DOOM ;;;   ;; color-176
;;NOT DOOM ;;;   ;; color-177
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (set-face-attribute 'outshine-level-4 nil :weight 'bold)
;;NOT DOOM ;;;  ;; (set-face-attribute 'outshine-level-5 nil :weight 'bold)
;;NOT DOOM ;;;  ;; * term / terminal / ansi-term
;;NOT DOOM ;;;  ;; ** use my own term version: stickyterm (slightly modified ansi-term)
;;NOT DOOM ;;; (use-package term
;;NOT DOOM ;;;   :ensure t) ;; stickyterm builds on /requires term (variables etc. -> load term before
;;NOT DOOM ;;;
(load "stickyterm.el")

(defun js/ansi-term (&optional buffername)
  "Start a terminal-emulator in a new buffer.
This is almost the same as `term' apart from always creating a new buffer,
and `C-x' being marked as a `term-escape-char'."
  (interactive)
  (setq program  (or explicit-shell-file-name
					       (getenv "ESHELL")
					       shell-file-name))
  (if buffername
      (ansi-term program buffername)
      (ansi-term program)))

(map! :leader
      :desc "Open Terminal" "o s" 'js/ansi-term)
;;NOT DOOM ;;;
;;NOT DOOM ;;; (use-package term
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  ;; (if color-theme-buffer-local-switch
;;NOT DOOM ;;;  (add-hook 'term-mode-hook
;;NOT DOOM ;;;             (lambda nil (color-theme-buffer-local 'color-theme-dark-laptop (current-buffer))))
;;NOT DOOM ;;;   ;; )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (add-hook 'term-mode-hook
;;NOT DOOM ;;;             (lambda nil (display-line-numbers-mode -1)))



(after! term
;; Alt-p --> map to arrow-up always
;; ( reason: ipython, I could n t achieve ipython remapping of "Alt-p"= "up", so I achieved it with this kind of workaround: the terminal-emulator / ipython "does not see" Alt-p coming, emacs will translate it to "up" before. so i get the desired behaviour and don t have to tediously use arrow keys)
;; IMPLICATION (!): all desired terminal behaviour on "Alt-p" has to be bound BOTH for (a) arrow up (so it ll work in emacs) and (b) also for "Alt-p" (i.e. .inputrc etc.), so I ll also get the behaviour outside emacs' term-mode, like normal shell.
(evil-define-key 'emacs term-raw-map (kbd "M-p") 'term-send-up)
(evil-define-key 'emacs term-raw-map (kbd "M-n") 'term-send-down)


;; *** short cut for term-paste
(evil-define-key 'normal term-raw-map (kbd "p") 'term-paste)
(evil-define-key 'normal term-raw-map (kbd "C-p") 'term-paste)
(evil-define-key 'emacs term-raw-map (kbd "C-p") 'term-paste)
(evil-define-key 'insert term-raw-map (kbd "C-p") 'term-paste)


;; *** switch only between (term char with emacs-state) and (term line with normal-state)
;;

(define-key term-raw-map [?\C-/] 'term-switch-line-mode-normal-state) ;; glaube: der wird "durchgelassen vorbei an emacs-state und landet dann in term-raw-map ->> deshalb hier ändern"
(define-key term-raw-map [?\M-/] 'term-switch-line-mode-normal-state) ;; sogar noch etwas mehr convenient: der wird "durchgelassen vorbei an emacs-state und landet dann in term-raw-map ->> deshalb hier ändern"

;; var1 not working:
;; (general-define-key
;;     :states 'normal
;;     :keymaps 'term-raw-map
;;     "SPC k" #'term-switch-char-mode-emacs-state)

;; var2 not working:
;; (general-define-key
;;  :states 'normal
;;  :keymaps 'term-raw-map
;;  :prefix "SPC"
;;  "k" 'term-switch-char-mode-emacs-state)

;; var3 -> working:
 (general-define-key :states 'normal :keymaps 'term-mode-map :prefix "SPC" "k" 'term-switch-char-mode-emacs-state)

 ;; **** previous/next buffer key binding, set also for term's
 (evil-define-key 'emacs term-raw-map (kbd "M-y") 'previous-buffer)
 (evil-define-key 'emacs term-raw-map (kbd "M-o") 'next-buffer)
 (evil-define-key 'normal term-raw-map (kbd "M-y") 'previous-buffer)
 (evil-define-key 'normal term-raw-map (kbd "M-o") 'next-buffer)
 (evil-define-key 'visual term-raw-map (kbd "M-y") 'previous-buffer)
 (evil-define-key 'visual term-raw-map (kbd "M-o") 'next-buffer)

;; handy shortcut for terminal -> copy/paste paths
(map! :map term-raw-map
     :nvieomr "C-M-y" #'copy-current-path
     :nvieomr "C-M-p" #'change-dir-from-clipboard
     )

(defun tempfig-revert ()
  (interactive)
  (with-current-buffer "tempfig1.pdf"
    (revert-buffer t 'no-confirm)))

(map!
        :gi "C-RET"         nil
        :gn [C-return]      nil)
(map! :map term-raw-map
      :nvieomr [C-return] #'tempfigs-revert)

(defun tempfigs-revert ()
  (interactive)
  (dolist (b (buffer-list))
    (with-current-buffer b
      (if buffer-file-name
          (if (string-match ".*tempfig.*" buffer-file-name)
              (revert-buffer t 'no-confirm))))))


;; actually.. it comes handy for all modes
(map!  ;; (which maps by default?)
     :nvieomr "C-M-y" #'copy-current-path
     :nvieomr "C-M-p" #'change-dir-from-clipboard
     )
(map!  :map dired-mode-map
     :nvieomr "C-M-y" nil
     :nvieomr "C-M-p" nil)

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

;;NOT DOOM ;;;  ;; *** term color theme
;;NOT DOOM ;;;  ;; (how did I get it from customization? -> customized in menue, then copied from custem.el ("custom-set-faces ...") and formatted
;;NOT DOOM ;;;  (set-face-attribute 'term nil :background "black" :foreground "white")
;;NOT DOOM ;;;  ;; (set-face-attribute 'term-color-back nil :background "black" :foreground "white")
;;NOT DOOM ;;;  ;; (set-face-attribute 'term-bold nil :background "black")
;;NOT DOOM ;;;  (set-face-attribute 'term-color-white nil :background "black" :foreground "white")
;;NOT DOOM ;;;  (set-face-attribute 'term-color-blue nil :background "#5fafd7" :foreground "#5fafd7")
;;NOT DOOM ;;;  (set-face-attribute 'term-color-green nil :background "#a1db00" :foreground "#a1db00")
;;NOT DOOM ;;;
;;NOT DOOM ;;;

;; make initial state for term emacs-state
;; this did not work:
;; (add-hook 'term-mode-hook
;;            (lambda nil (evil-emacs-state)))
;; this did work:
(evil-set-initial-state 'term-mode 'emacs)

) ;; end after!
;;NOT DOOM ;;;  ;; *** tramp connection to hlrn (fast command)
;;NOT DOOM ;;;  ;; **** still have problem that it hangs on "waiting for prompts from remote shell..."
;;NOT DOOM ;;;  ;; -> could not solve it, tried like this
;;NOT DOOM ;;;  ;; (exec-path-from-shell-initialize)
;;NOT DOOM ;;;  ;; (setq exec-path-from-shell-check-startup-files nil)
;;NOT DOOM ;;;  ;; (setq exec-path-from-shell nil)
;;NOT DOOM ;;;  (load "hlrn_tramp_connect.el")
;;NOT DOOM ;;;  ;; --> includes hlrn_tramp_home / hlrn_tramp_work1 / hlrn_tramp_work2
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; +) save minibuffer history for future sessions
;;NOT DOOM ;;;  (savehist-mode 1)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; +) move buffers
;;NOT DOOM ;;;  (load "buffer-move.el")
;;NOT DOOM ;;;  ;; To use it, simply put a (require 'buffer-move) in your ~/.emacs and
;;NOT DOOM ;;; (use-package buffer-move
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  ;; define some keybindings. For example, i use :
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (global-set-key (kbd "<C-S-up>")     'buf-move-up)
;;NOT DOOM ;;;  ;; (global-set-key (kbd "<C-S-down>")   'buf-move-down)
;;NOT DOOM ;;;  ;; (global-set-key (kbd "<C-S-left>")   'buf-move-left)
;;NOT DOOM ;;;  ;; (global-set-key (kbd "<C-S-right>")  'buf-move-right)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; +) windows stuff
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;  -) undo-/ redo window configuration
;;NOT DOOM ;;;  (winner-mode 1)
;;NOT DOOM ;;;  ;;  -) resize windows
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; VARI
;;NOT DOOM ;;;  (global-set-key (kbd "<C-S-up>")     'enlarge-window)
;;NOT DOOM ;;;  (global-set-key (kbd "<C-S-down>")   'shrink-window)
;;NOT DOOM ;;;  (global-set-key (kbd "<C-S-left>")   'shrink-window-horizontally)
;;NOT DOOM ;;;  (global-set-key (kbd "<C-S-right>")  'enlarge-window-horizontally)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defvar iresize-mode-map
;;NOT DOOM ;;;    (let ((m (make-sparse-keymap)))
;;NOT DOOM ;;;      (define-key m (kbd "C-p") 'enlarge-window)
;;NOT DOOM ;;;      (define-key m (kbd "p") 'enlarge-window)
;;NOT DOOM ;;;      (define-key m (kbd "<up>") 'enlarge-window-horizontally)
;;NOT DOOM ;;;      (define-key m (kbd "C-n") 'shrink-window)
;;NOT DOOM ;;;      (define-key m (kbd "n") 'shrink-window)
;;NOT DOOM ;;;      (define-key m (kbd "<down>") 'shrink-window)
;;NOT DOOM ;;;      (define-key m (kbd "C-c C-c") 'iresize-mode)
;;NOT DOOM ;;;      (define-key m (kbd "<right>") 'enlarge-window-horizontally)
;;NOT DOOM ;;;      (define-key m (kbd "<left>") 'shrink-window-horizontally)
;;NOT DOOM ;;;      m))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (define-minor-mode iresize-mode "this is the documentation of iresize-mode. blablah."
;;NOT DOOM ;;;    :init-value nil
;;NOT DOOM ;;;    :lighter " IResize"
;;NOT DOOM ;;;    :keymap iresize-mode-map
;;NOT DOOM ;;;    :group 'iresize
;;NOT DOOM ;;;    :global t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; iresize/evil
;;NOT DOOM ;;;  ;; (evil-define-key 'normal iresize-mode-map (kbd "k") 'enlarge-window)
;;NOT DOOM ;;;  ;; (evil-define-key 'normal iresize-mode-map (kbd "j") 'shrink-window)
;;NOT DOOM ;;;  ;; (evil-define-key 'normal iresize-mode-map (kbd "l") 'enlarge-window-horizontally)
;;NOT DOOM ;;;  ;; (vil-define-key 'normal iresize-mode-map (kbd "h") 'shrink-window-horizontally)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (evil-define-minor-mode-key 'normal 'iresize-mode (kbd "K") 'enlarge-window)
;;NOT DOOM ;;;  (evil-define-minor-mode-key 'normal 'iresize-mode (kbd "J") 'shrink-window)
;;NOT DOOM ;;;  (evil-define-minor-mode-key 'normal 'iresize-mode (kbd "L") 'enlarge-window-horizontally)
;;NOT DOOM ;;;  (evil-define-minor-mode-key 'normal 'iresize-mode (kbd "H") 'shrink-window-horizontally)
;;NOT DOOM ;;;  ;; fast (double) resize
;;NOT DOOM ;;;  (evil-define-minor-mode-key 'normal 'iresize-mode (kbd "k") 'enlarge-window-4)
;;NOT DOOM ;;;  (evil-define-minor-mode-key 'normal 'iresize-mode (kbd "j") 'shrink-window-4)
;;NOT DOOM ;;;  (evil-define-minor-mode-key 'normal 'iresize-mode (kbd "l") 'enlarge-window-horizontally-4)
;;NOT DOOM ;;;  (evil-define-minor-mode-key 'normal 'iresize-mode (kbd "h") 'shrink-window-horizontally-4)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun shrink-window-horizontally-2 ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (shrink-window-horizontally 2)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;  (defun enlarge-window-horizontally-2 ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (enlarge-window-horizontally 2)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;  (defun shrink-window-2 ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (shrink-window 2)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;  (defun enlarge-window-2 ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (enlarge-window 2)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun shrink-window-horizontally-3 ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (shrink-window-horizontally 3)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;  (defun enlarge-window-horizontally-3 ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (enlarge-window-horizontally 3)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;  (defun shrink-window-3 ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (shrink-window 3)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;  (defun enlarge-window-3 ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (enlarge-window 3)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun shrink-window-horizontally-4 ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (shrink-window-horizontally 4)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;  (defun enlarge-window-horizontally-4 ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (enlarge-window-horizontally 4)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;  (defun shrink-window-4 ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (shrink-window 4)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;(defun enlarge-window-4 ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;  (enlarge-window 4))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (provide 'iresize)
;;NOT DOOM ;;;



;;  ) create new big window (my-split- ... functions)
(defun js/split-root-window (size direction)
  (split-window (frame-root-window)
                (and size (prefix-numeric-value size))
                direction))

(defun js/split-root-window-below (&optional size)
  (interactive "P")
  (js/split-root-window size 'below))

(defun js/split-root-window-above (&optional size)
  (interactive "P")
  (js/split-root-window size 'above))

(defun js/split-root-window-right (&optional size)
  (interactive "P")
  (js/split-root-window size 'right))

(defun js/split-root-window-left (&optional size)
  (interactive "P")
  (js/split-root-window size 'left))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;;
;;NOT DOOM ;;;  ;;(require 'ivy)
;;NOT DOOM ;;;  ;;(load "recent_dirs.el")
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; +) copy under linux ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;NOT DOOM ;;; (setq x-select-enable-clipboard t)
;;NOT DOOM ;;;  ;(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; +) keyboard
;;NOT DOOM ;;; ;; (require 'iso-transl)
;;NOT DOOM ;;;  ;; US-International auf Linux, sonst funzen dead keys nicht, fur quotes etc.
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;+) AUTOMATIC PACKAGE INSTALLATION ;; LIST ALL PACKAGES HERE ;;;
;;NOT DOOM ;;;  ;-------------------------------------------------------------------
;;NOT DOOM ;;;  ;;;;;;; DID NOT WORK ... ;;;;;;;;;;;;;;;;;;;;;
;;NOT DOOM ;;;  ;; list the packages you want
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * mode line
;;NOT DOOM ;;;  ;; ** todos
;;NOT DOOM ;;;  ;; *** eliminate infos (or move to tabbar)
;;NOT DOOM ;;;  ;; **** major mode string -> eliminate
;;NOT DOOM ;;;  ;; **** git branch -> eliminate
;;NOT DOOM ;;;  ;; **** effort/clocking -> move to tabbar
;;NOT DOOM ;;;
;;NOT DOOM ;;;      ;; (setq mode-line-format
;;NOT DOOM ;;;      ;;       (list
;;NOT DOOM ;;; ;;NOT DOOM ;;;      ;;        ;; value of `mode-name'
;;NOT DOOM ;;;      ;;        "%m: "
;;NOT DOOM ;;;      ;;        ;; value of current buffer name
;;NOT DOOM ;;;      ;;        "buffer %b, "
;;NOT DOOM ;;;      ;;        ;; value of current line number
;;NOT DOOM ;;;      ;;        "line %l \n"
;;NOT DOOM ;;;      ;;        "-- user: "
;;NOT DOOM ;;;      ;;        ;; value of user
;;NOT DOOM ;;;      ;;        (getenv "USER")))
;;NOT DOOM ;;;  ;;(require 'uniquify) ;; give buffer name part of path --> distinguish files with same names
;;NOT DOOM ;;;  ;;(setq uniquify-buffer-name-style 'forward) ;;forward accomplishes this
;;NOT DOOM ;;; (use-package doom-modeline
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  (doom-modeline-mode  1)
;;NOT DOOM ;;;  (when (not (display-graphic-p))
;;NOT DOOM ;;;  ;; (setq doom-modeline-icon nil)
;;NOT DOOM ;;;  (setq doom-modeline-icon nil)
;;NOT DOOM ;;;  (setq doom-modeline-modal-icon nil))
;;NOT DOOM ;;;  ;; (setq all-the-icons-scale-factor 1.2) ; (default)
;;NOT DOOM ;;;  ;; (setq all-the-icons-scale-factor 0.9) ; (nice try to be sleakier, but e.g. emacs-icon does not react)
;;NOT DOOM ;;;  ;; (use-package doom-modeline
;;NOT DOOM ;;;  ;;    :ensure   t
;;NOT DOOM ;;;  ;;    :init  (doom-modeline-mode  1 ))
;;NOT DOOM ;;;  ;; quick and dirty own custom -> circle (also in terminal mode)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; *** don t show UTF-8/bla
;;NOT DOOM ;;;  (setq doom-modeline-buffer-encoding nil)
;;NOT DOOM ;;;  ;; (setq doom-modeline-buffer-encoding t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (when (not (display-graphic-p))
;;NOT DOOM ;;;  (setq evil-normal-state-tag "●")
;;NOT DOOM ;;;  (setq evil-insert-state-tag "●")
;;NOT DOOM ;;;  (setq evil-visual-state-tag "●")
;;NOT DOOM ;;;  (setq evil-motion-state-tag "●")
;;NOT DOOM ;;;  (setq evil-emacs-state-tag "●"))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; my colors for normal/visual/etc evil states
;;NOT DOOM ;;;  ;; more obtrusive:
;;NOT DOOM ;;;  ;; (set-face-attribute 'doom-modeline-evil-normal-state nil :foreground "lawn green")
;;NOT DOOM ;;;  ;; (set-face-attribute 'doom-modeline-evil-visual-state nil :foreground "dark orange")
;;NOT DOOM ;;;  ;; (set-face-attribute 'doom-modeline-evil-insert-state nil :foreground "dodger blue")
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; less obtrusive:
;;NOT DOOM ;;;  (set-face-attribute 'doom-modeline-evil-normal-state nil :foreground "green yellow")
;;NOT DOOM ;;;  ;; (set-face-attribute 'doom-modeline-evil-normal-state nil :foreground "lime green")
;;NOT DOOM ;;;  (set-face-attribute 'doom-modeline-evil-visual-state nil :foreground "gold")
;;NOT DOOM ;;;  (set-face-attribute 'doom-modeline-evil-insert-state nil :foreground "turquoise1")
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (set-face-attribute 'mode-line-inactive nil :background "#444444")
;;NOT DOOM ;;;  (set-face-attribute 'mode-line-inactive nil :foreground "#626262")
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** settings from doom-modeline homepage:
;;NOT DOOM ;;;  ;; ;; How tall the mode-line should be. It's only respected in GUI.
;;NOT DOOM ;;;  ;; ;; If the actual char height is larger, it respects the actual height.
;;NOT DOOM ;;;  ;; (setq doom-modeline-height 25)
;;NOT DOOM ;;;  (setq doom-modeline-height 0) ;; -> always minimal height
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; How wide the mode-line bar should be. It's only respected in GUI.
;;NOT DOOM ;;;  ;; (setq doom-modeline-bar-width 4)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether to use hud instead of default bar. It's only respected in GUI.
;;NOT DOOM ;;;  ;; (defcustom doom-modeline-hud nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; The limit of the window width.
;;NOT DOOM ;;;  ;; ;; If `window-width' is smaller than the limit, some information won't be displayed.
;;NOT DOOM ;;;  ;; (setq doom-modeline-window-width-limit fill-column)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; How to detect the project root.
;;NOT DOOM ;;;  ;; ;; The default priority of detection is `ffip' > `projectile' > `project'.
;;NOT DOOM ;;;  ;; ;; nil means to use `default-directory'.
;;NOT DOOM ;;;  ;; ;; The project management packages have some issues on detecting project root.
;;NOT DOOM ;;;  ;; ;; e.g. `projectile' doesn't handle symlink folders well, while `project' is unable
;;NOT DOOM ;;;  ;; ;; to hanle sub-projects.
;;NOT DOOM ;;;  ;; ;; You can specify one if you encounter the issue.
;;NOT DOOM ;;;  ;; (setq doom-modeline-project-detection 'project)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Determines the style used by `doom-modeline-buffer-file-name'.
;;NOT DOOM ;;;  ;; ;;
;;NOT DOOM ;;;  ;; ;; Given ~/Projects/FOSS/emacs/lisp/comint.el
;;NOT DOOM ;;;  ;; ;;   auto => emacs/lisp/comint.el (in a project) or comint.el
;;NOT DOOM ;;;  ;; ;;   truncate-upto-project => ~/P/F/emacs/lisp/comint.el
;;NOT DOOM ;;;  ;; ;;   truncate-from-project => ~/Projects/FOSS/emacs/l/comint.el
;;NOT DOOM ;;;  ;; ;;   truncate-with-project => emacs/l/comint.el
;;NOT DOOM ;;;  ;; ;;   truncate-except-project => ~/P/F/emacs/l/comint.el
;;NOT DOOM ;;;  ;; ;;   truncate-upto-root => ~/P/F/e/lisp/comint.el
;;NOT DOOM ;;;  ;; ;;   truncate-all => ~/P/F/e/l/comint.el
;;NOT DOOM ;;;  ;; ;;   truncate-nil => ~/Projects/FOSS/emacs/lisp/comint.el
;;NOT DOOM ;;;  ;; ;;   relative-from-project => emacs/lisp/comint.el
;;NOT DOOM ;;;  ;; ;;   relative-to-project => lisp/comint.el
;;NOT DOOM ;;;  ;; ;;   file-name => comint.el
;;NOT DOOM ;;;  ;; ;;   buffer-name => comint.el<2> (uniquify buffer name)
;;NOT DOOM ;;;  ;; ;;
;;NOT DOOM ;;;  ;; ;; If you are experiencing the laggy issue, especially while editing remote files
;;NOT DOOM ;;;  ;; ;; with tramp, please try `file-name' style.
;;NOT DOOM ;;;  ;; ;; Please refer to https://github.com/bbatsov/projectile/issues/657.
;;NOT DOOM ;;;  ;; (setq doom-modeline-buffer-file-name-style 'auto)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether display icons in the mode-line.
;;NOT DOOM ;;;  ;; ;; While using the server mode in GUI, should set the value explicitly.
;;NOT DOOM ;;;  ;; (setq doom-modeline-icon (display-graphic-p))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether display the icon for `major-mode'. It respects `doom-modeline-icon'.
;;NOT DOOM ;;;  ;; (setq doom-modeline-major-mode-icon t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether display the colorful icon for `major-mode'.
;;NOT DOOM ;;;  ;; ;; It respects `all-the-icons-color-icons'.
;;NOT DOOM ;;;  ;; (setq doom-modeline-major-mode-color-icon t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether display the icon for the buffer state. It respects `doom-modeline-icon'.
;;NOT DOOM ;;;  ;; (setq doom-modeline-buffer-state-icon t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether display the modification icon for the buffer.
;;NOT DOOM ;;;  ;; ;; It respects `doom-modeline-icon' and `doom-modeline-buffer-state-icon'.
;;NOT DOOM ;;;  ;; (setq doom-modeline-buffer-modification-icon t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether to use unicode as a fallback (instead of ASCII) when not using icons.
;;NOT DOOM ;;;  ;; (setq doom-modeline-unicode-fallback nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether display the minor modes in the mode-line.
;;NOT DOOM ;;;  ;; (setq doom-modeline-minor-modes nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; If non-nil, a word count will be added to the selection-info modeline segment.
;;NOT DOOM ;;;  ;; (setq doom-modeline-enable-word-count nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Major modes in which to display word count continuously.
;;NOT DOOM ;;;  ;; ;; Also applies to any derived modes. Respects `doom-modeline-enable-word-count'.
;;NOT DOOM ;;;  ;; ;; If it brings the sluggish issue, disable `doom-modeline-enable-word-count' or
;;NOT DOOM ;;;  ;; ;; remove the modes from `doom-modeline-continuous-word-count-modes'.
;;NOT DOOM ;;;  ;; (setq doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether display the buffer encoding.
;;NOT DOOM ;;;  ;; (setq doom-modeline-buffer-encoding t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether display the indentation information.
;;NOT DOOM ;;;  ;; (setq doom-modeline-indent-info nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; If non-nil, only display one number for checker information if applicable.
;;NOT DOOM ;;;  ;; (setq doom-modeline-checker-simple-format t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; The maximum number displayed for notifications.
;;NOT DOOM ;;;  ;; (setq doom-modeline-number-limit 99)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; The maximum displayed length of the branch name of version control.
;;NOT DOOM ;;;  ;; (setq doom-modeline-vcs-max-length 12)
;;NOT DOOM ;;;
;; * workspaces
;; TODO conflict with termux (donnow why?) destroys termux touch navigation
;; --> outcomment for now
;; (map!
;;  "M-[" #'+workspace/switch-right
;;  "M-]" #'+workspace/switch-right)
;;NOT DOOM ;;;  ;; ;; Whether display the workspace name. Non-nil to display in the mode-line.
;;NOT DOOM ;;;  ;; (setq doom-modeline-workspace-name t)
;;NOT DOOM ;;;  ;; (setq doom-modeline-workspace-name nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether display the perspective name. Non-nil to display in the mode-line.
;;NOT DOOM ;;;  ;; (setq doom-modeline-persp-name t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; If non nil the default perspective name is displayed in the mode-line.
;;NOT DOOM ;;;  ;; (setq doom-modeline-display-default-persp-name nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; If non nil the perspective name is displayed alongside a folder icon.
;;NOT DOOM ;;;  ;; (setq doom-modeline-persp-icon t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether display the `lsp' state. Non-nil to display in the mode-line.
;;NOT DOOM ;;;  ;; (setq doom-modeline-lsp t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether display the GitHub notifications. It requires `ghub' package.
;;NOT DOOM ;;;  ;; (setq doom-modeline-github nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; The interval of checking GitHub.
;;NOT DOOM ;;;  ;; (setq doom-modeline-github-interval (* 30 60))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether display the modal state icon.
;;NOT DOOM ;;;  ;; ;; Including `evil', `overwrite', `god', `ryo' and `xah-fly-keys', etc.
;;NOT DOOM ;;;  ;; (setq doom-modeline-modal-icon t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether display the mu4e notifications. It requires `mu4e-alert' package.
;;NOT DOOM ;;;  ;; (setq doom-modeline-mu4e nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether display the gnus notifications.
;;NOT DOOM ;;;  ;; (setq doom-modeline-gnus t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Wheter gnus should automatically be updated and how often (set to 0 or smaller than 0 to disable)
;;NOT DOOM ;;;  ;; (setq doom-modeline-gnus-timer 2)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Wheter groups should be excludede when gnus automatically being updated.
;;NOT DOOM ;;;  ;; (setq doom-modeline-gnus-excluded-groups '("dummy.group"))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether display the IRC notifications. It requires `circe' or `erc' package.
;;NOT DOOM ;;;  ;; (setq doom-modeline-irc t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Function to stylize the irc buffer names.
;;NOT DOOM ;;;  ;; (setq doom-modeline-irc-stylize 'identity)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Whether display the environment version.
;;NOT DOOM ;;;  ;; (setq doom-modeline-env-version t)
;;NOT DOOM ;;;  ;; ;; Or for individual languages
;;NOT DOOM ;;;  ;; (setq doom-modeline-env-enable-python t)
;;NOT DOOM ;;;  ;; (setq doom-modeline-env-enable-ruby t)
;;NOT DOOM ;;;  ;; (setq doom-modeline-env-enable-perl t)
;;NOT DOOM ;;;  ;; (setq doom-modeline-env-enable-go t)
;;NOT DOOM ;;;  ;; (setq doom-modeline-env-enable-elixir t)
;;NOT DOOM ;;;  ;; (setq doom-modeline-env-enable-rust t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Change the executables to use for the language version string
;;NOT DOOM ;;;  ;; (setq doom-modeline-env-python-executable "python") ; or `python-shell-interpreter'
;;NOT DOOM ;;;  ;; (setq doom-modeline-env-ruby-executable "ruby")
;;NOT DOOM ;;;  ;; (setq doom-modeline-env-perl-executable "perl")
;;NOT DOOM ;;;  ;; (setq doom-modeline-env-go-executable "go")
;;NOT DOOM ;;;  ;; (setq doom-modeline-env-elixir-executable "iex")
;;NOT DOOM ;;;  ;; (setq doom-modeline-env-rust-executable "rustc")
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; What to display as the version while a new one is being loaded
;;NOT DOOM ;;;  ;; (setq doom-modeline-env-load-string "...")
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; Hooks that run before/after the modeline version string is updated
;;NOT DOOM ;;;  ;; (setq doom-modeline-before-update-env-hook nil)
;;NOT DOOM ;;;  ;; (setq doom-modeline-after-update-env-hook nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * WINDOW / BUFFER NAVIGATION STUFF
;;NOT DOOM ;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ** copy/paste path between buffers (terminal/dired)
(load "copy-paste-paths.el")
;; copy current path key bindings
;; *** this got sooo usefull/frequent -> bind also to evil leader (prime positions spc-y/ spc-p )
(map! :leader
      (:prefix-map ("y" . "paths")
       :desc "copy current path" "y" 'copy-current-path ;; analogouns to y = vim yank
       :desc "copy file path" "u" 'copy-fullfilename
 ;; analogouns to y = vim yank
       :desc "change path"       "p" 'change-dir-from-clipboard ;; analogouns to y = vim yank
       :desc "change path"       "Y" 'android-copy-to-clipboard
       :desc "change path"       "P" 'android-paste-clipboard)) ;; analogouns to y = vim yank
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; copy current filename (e.g. execute in matlab command window)
;;NOT DOOM ;;;  (global-set-key (kbd "<f9>") 'copy-current-file-name-no-extension)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; ** avy/ace jump
;;NOT DOOM ;;; (use-package avy
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  (js/leader-def "j" 'avy-goto-char-2) ;; 'avy-goto-char
;;NOT DOOM ;;;  (js/leader-def "m" 'avy-goto-char)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (setq dired-recursive-copies 'always)
;;NOT DOOM ;;;  (setq dired-dwim-target t) ;; do what i mean --> automatic "inteligent" copy location etc.
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * ) quickly move buffer to another window
;;NOT DOOM ;;;  (load "quickly-move-buffer-to-other-window.el")
;;NOT DOOM ;;;  ;; copy current path key bindings
;;NOT DOOM ;;;  (global-set-key (kbd "<f3>") 'get-this-buffer-to-move)
;;NOT DOOM ;;;  (global-set-key (kbd "M-u") 'get-this-buffer-to-move)
;;NOT DOOM ;;; (require 'dired)
;;NOT DOOM ;;;  (define-key dired-mode-map (kbd "<f3>") 'get-this-buffer-to-move)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (global-set-key (kbd "<f4>") 'switch-to-buffer-to-move)
;;NOT DOOM ;;;  (global-set-key (kbd "M-i") 'switch-to-buffer-to-move)
;;NOT DOOM ;;;  (define-key dired-mode-map (kbd "<f4>") 'switch-to-buffer-to-move)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; .) disable the "nerviges/sinnloses" automatic copy-path of other dired buffer (especially when renaming)
;;NOT DOOM ;;;  ;;    (this was suppose to "help" when performing copy / rename etc. operations in mini-buffer, so you would not have to type the location manually but get some "intelligent guess" from clipboard, BUT:
;;NOT DOOM ;;;  ;;    this is obsolete with dired-ranger --> much better copy/paste workflow)
;;NOT DOOM ;;;  (setq dired-dwim-target nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * dired
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** hide details by default
(add-hook 'dired-mode-hook
            'dired-hide-details-mode)
;;NOT DOOM ;;;  	    (dired-do-kill-lines))
;;NOT DOOM ;;;  	(progn (revert-buffer) ; otherwise just revert to re-show
;;NOT DOOM ;;;                 (set (make-local-variable 'dired-dotfiles-show-p) t)))))
;;NOT DOOM ;;;  ;; ** add option to list directories first
;;NOT DOOM ;;;  ;;(setq dired-listing-switches "-aBhl  --group-directories-first")
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** open in dired with external applications --> see '* open with external applications' (below)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;;; * ) dired "options" (minor-modes)
;;NOT DOOM ;;;  ;; ;;;--------------------------------------------
;;NOT DOOM ;;;  ;; ;;    .) open recent directories
;;NOT DOOM ;;;  ;; (global-set-key (kbd "C-x C-d") 'dired-recent-dirs-ivy-bjm) ;; see definition recent_dirs.el
;;NOT DOOM ;;;

;; create empty file ( = bash's touch)
(defun dired-create-new-empty-file ()
   (interactive)
   ;; create the hidden (dotted) folder with same name of org file
   (setq filename (read-string "file-name: "))
   (setq file-full-name (concat  (dired-current-directory) "/" filename))
   (with-temp-buffer (write-file file-full-name)))

(defun dired-create-new-empty-file-and-visit ()
   (interactive)
   ;; create the hidden (dotted) folder with same name of org file
   (setq filename (read-string "file-name: "))
   (setq file-full-name (concat  (dired-current-directory) "/" filename))
   (with-temp-buffer (write-file file-full-name)))

(defun dired-create-new-xournal-file-and-visit ()
  (interactive)
  ;; * file name
  (setq filename (read-string "xournal file name (without .xopp extension): "))
  ;; (message filename)
  ;; * create file from template
  (setq currentpath (file-name-directory (dired-current-directory)))
  (setq filefullname (concat  currentpath "/" filename))
  (setq template-filefullname "/home/johannes/MyEmacsConfig/xournal_org_template_new.xopp")
  ;; * open xournal file (no popup of async output)
  (setq command_string (concat "xournalpp " filefullname))
  (efs/run-in-background command_string)
  (copy-file template-filefullname filefullname))

(map! :localleader
      :map dired-mode-map
      "m" #'dired-create-new-empty-file
      "v" #'dired-create-new-empty-file-and-visit
      "x" #'dired-create-new-xournal-file-and-visit)

;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * helm-rg
;;NOT DOOM ;;; (use-package helm-rg
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  (setq helm-rg-default-extra-args '("--hidden"))
;;NOT DOOM ;;;  ;; only makes sence in dired buffers, for others-> helm-soop
;;NOT DOOM ;;;  (js/leader-def :keymaps 'dired-mode-mode-map "g" 'helm-rg) ;
;;NOT DOOM ;;;  ;; DIRED+ STUFF -> no longer officially supported MELPA (security reasons) --> outcommented
;;NOT DOOM ;;;  ;;  (https://emacs.stackexchange.com/questions/38553/dired-missing-from-melpa)
;;NOT DOOM ;;;  ;; ;;    .) reuse buffer,  don't open always new buffer when
;;NOT DOOM ;;;  ;;(require 'dired+) ;; was "somehow" necessary, otherwise not "launched"
;;NOT DOOM ;;;  ;; ;;;   .) reuse buffer when clicking on directory
;;NOT DOOM ;;;  ;; (diredp-toggle-find-file-reuse-dir 1)
;;NOT DOOM ;;;  ;; (define-key dired-mode-map (kbd "<mouse-2>") 'diredp-mouse-find-file)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;;   .) toggle sudo-rights
;;NOT DOOM ;;;  ;; (require 'dired-toggle-sudo)
;;NOT DOOM ;;;  ;; (define-key dired-mode-map (kbd "C-c C-s") 'dired-toggle-sudo)
;;NOT DOOM ;;;  ;; (eval-after-load 'tramp
;;NOT DOOM ;;;  ;;  '(progn
;;NOT DOOM ;;;  ;;     ;; Allow to use: /sudo:user@host:/path/to/file
;;NOT DOOM ;;;  ;;     (add-to-list 'tramp-default-proxies-alist
;;NOT DOOM ;;;  ;; 		  '(".*" "\\`.+\\'" "/ssh:%h:"))))
;;NOT DOOM ;;;
;;
;; ** dired short cut s: go frequent places -> "go home" / "go $WORK" / bookmarks / etc.
(defun dired-go-downloads ()
  (interactive)
(cond
 ((equal myhost "phone")
  (dired "/storage/emulated/0/Download/"))
 ((equal myhost "macos")
  (dired (substitute-in-file-name "$HOME/Downloads")))
 ((equal myhost "laptop")
  (dired (substitute-in-file-name "$HOME/Downloads")))
 (t
  (dired (substitute-in-file-name "$HOME/Downloads")))
 ))


(setq dropbox-path (getenv "DROPBOX"))
(map! :leader
      (:prefix-map ("l" . "frequent dirs")
      :desc "home"            "h" #'(lambda () (interactive) (dired (substitute-in-file-name "$HOME")))
      :desc "downloads"       "d" #'dired-go-downloads
      :desc "MyEmacsConfig"   "e" #'(lambda () (interactive) (dired (substitute-in-file-name "$HOME/MyEmacsConfig")))
      ;; :desc "cluster -> WORK" "w" #'(lambda () (interactive) (dired (substitute-in-file-name "$WORK")))
      ;; :desc "cluster -> FAST" "f" #'(lambda () (interactive) (dired (substitute-in-file-name "$FAST")))
      :desc "Data"            "F" #'(lambda () (interactive) (dired (substitute-in-file-name "$DATA")))
      :desc "mucke"           "m" #'(lambda () (interactive) (dired (substitute-in-file-name "$HOME/org/mucke/doktorparty_songs"))) ;;basking_project")))
      :desc "temp"            "t" #'(lambda () (interactive) (dired (substitute-in-file-name "$HOME/temp")))
      :desc "org"             "o" #'(lambda () (interactive) (dired (substitute-in-file-name "$HOME/org")))
      :desc "projects"        "p" #'(lambda () (interactive) (dired (substitute-in-file-name "$HOME/org/projects")))
      :desc "projects file"   "P" #'(lambda () (interactive) (find-file (substitute-in-file-name "$HOME/org/projects/projects_current.org/projects_current.org")))
      :desc "lists"           "l" #'(lambda () (interactive) (dired (substitute-in-file-name "$HOME/org/lists")))
      :desc "doom"            "D" #'(lambda () (interactive) (dired (substitute-in-file-name "$HOME/.config/doom")))
      :desc "Literatur"       "L" #'(lambda () (interactive) (dired (concat dropbox-path "/MyFiles/Beruf/Literatur/pdf/Inkjet/")))
      :desc "Promotion"       "N" #'(lambda () (interactive) (dired (concat dropbox-path "/MyFiles/Beruf/TUBerlinPromo/Promotionsprojekt/")))
      :desc "emacs init"      "i" #'(lambda () (interactive) (find-file (substitute-in-file-name "$HOME/MyEmacsConfig/my_emacs_init_doomtransfer2021.el")))
      :desc "quantica"        "q" #'(lambda () (interactive) (find-file (substitute-in-file-name "$HOME/org/quantica")))
      :desc "frequent commands" "f" #'(lambda () (interactive) (find-file (substitute-in-file-name "$HOME/org/frequent_commands.sh")))
 ))

;;NOT DOOM ;;;  (js/leader-def "hm" 'dired-go-mucke)
;;NOT DOOM ;;;  (js/leader-def "hb" 'helm-bookmarks)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;    .) auto revert dired default
;;NOT DOOM ;;;  (add-hook 'dired-mode-hook 'auto-revert-mode)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;    .) don't confirm deletion on every
;;NOT DOOM ;;;        (setq dired-recursive-deletes 'always)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;;;   .) add icons
;;NOT DOOM ;;;  ;; ;;(require 'dired-icon)
;;NOT DOOM ;;;  ;; ;;(add-hook 'dired-mode-hook 'dired-icon-mode)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; go up directory with backspace
(map! :map dired-mode-map :n "<DEL>" 'dired-up-directory)
;;NOT DOOM ;;; ;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; quickly choose files by letters
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; dired-narrow was not so handy.. this was not soo effective...
;;NOT DOOM ;;;  ;; todo -> better solution (maybe use / ? evil like to simply search)
;;NOT DOOM ;;;  ;; (require 'dired-narrow)
;;NOT DOOM ;;;  ;; (define-key dired-mode-map (kbd "<SPC>") 'dired-narrow)
;;NOT DOOM ;;;
;;NOT DOOM ;;;

 ;; ;;; dired ranger key's - nicely copy/paste files/dirs
(after! org
        (require 'dired-ranger))

(after! dired-ranger
  (map! :map dired-mode-map
        :n  "Y"  #'dired-ranger-copy
        :n  "C"  #'dired-ranger-copy
        :n  "C-c"  #'dired-ranger-copy
        :n  "X"  #'dired-ranger-move
        :n  "C-x"  #'dired-ranger-move
        :n  "P"  #'dired-ranger-paste
        :n  "C-v"  #'dired-ranger-paste))

  ;; (define-key dired-mode-map (kbd "Y") 'dired-ranger-copy)
  ;; (define-key dired-mode-map (kbd "X") 'dired-ranger-move)
  ;; (define-key dired-mode-map (kbd "P") 'dired-ranger-paste)



;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; function to quickly open a buffer's directory (or home if there is no meaningful directory like for *scratch*)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; evil dired - (results in mixture of evil and dired, evil: gg,G,/,?,yy,v  , dired, s,m,W,X,Y, etc.)
;;NOT DOOM ;;;   (evil-define-key 'normal dired-mode-map (kbd "W") 'dired-ranger-copy)
;;NOT DOOM ;;;   (evil-define-key 'normal dired-mode-map (kbd "X") 'dired-ranger-move)
;;NOT DOOM ;;;   (evil-define-key 'normal dired-mode-map (kbd "Y") 'dired-ranger-paste)
;;NOT DOOM ;;;
;;NOT DOOM ;;;    (evil-define-key 'normal dired-mode-map (kbd "<DEL>") 'dired-up-directory)
;;NOT DOOM ;;;    ;; (evil-define-key 'normal dired-mode-map "l" 'dired-find-alternate-file)
;;NOT DOOM ;;;   ;; (evil-define-key 'normal dired-mode-map "o" 'dired-sort-toggle-or-edit)
;;NOT DOOM ;;;    (evil-define-key 'normal dired-mode-map "s" 'dired-sort-toggle-or-edit)
;;NOT DOOM ;;;    (evil-define-key 'normal dired-mode-map "(" 'dired-hide-details-mode)
;;NOT DOOM ;;;    (evil-define-key 'normal dired-mode-map "m" 'dired-mark)
;;NOT DOOM ;;;    (evil-define-key 'normal dired-mode-map "o" 'dired-mark)
;;NOT DOOM ;;;    (evil-define-key 'normal dired-mode-map "u" 'dired-unmark)
;;NOT DOOM ;;;    (evil-define-key 'normal dired-mode-map "U" 'dired-unmark-all-marks)
;;NOT DOOM ;;;    (evil-define-key 'normal dired-mode-map "+" 'dired-create-directory)
;;NOT DOOM ;;;    (evil-define-key 'normal dired-mode-map "n" 'evil-search-next)
;;NOT DOOM ;;;    (evil-define-key 'normal dired-mode-map "N" 'evil-search-previous)
;;NOT DOOM ;;;    (evil-define-key 'normal dired-mode-map "q" 'kill-this-buffer)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** )  by hitting enter -> exit narrow-mode and enter file/dir
;;NOT DOOM ;;;  ;; --------------------------------------------------------------------
;;NOT DOOM ;;;  ;; ;;; (quick and dirty way)
;;NOT DOOM ;;;  ;; ;; source: http://oremacs.com/2015/07/16/callback-quit/
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;;; adjust some stuff for dired-narrow work-flow:
;;NOT DOOM ;;;  ;; ;;; this macro is necessary (don't understand but ok...)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (defmacro dired-narrow-quit-and-run (&rest body)
;;NOT DOOM ;;;  ;;   "Quit the minibuffer and run BODY afterwards."
;;NOT DOOM ;;;  ;;   `(progn
;;NOT DOOM ;;;  ;;      (put 'quit 'error-message "")
;;NOT DOOM ;;;  ;;      (run-at-time nil nil
;;NOT DOOM ;;;  ;;                   (lambda ()
;;NOT DOOM ;;;  ;;                     (put 'quit 'error-message "Quit")
;;NOT DOOM ;;;  ;;                     ,@body))
;;NOT DOOM ;;;  ;;      (minibuffer-keyboard-quit)))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;;
;;NOT DOOM ;;;  ;; (defun dired-narrow-quit-and-enter-file-or-dir ()
;;NOT DOOM ;;;  ;;    (interactive)
;;NOT DOOM ;;;  ;;        (dired-narrow-quit-and-run
;;NOT DOOM ;;;  ;;           (dired-find-file)  ;; <--- put here what you wanna do after exiting from dired-narrow
;;NOT DOOM ;;;  ;;         )
;;NOT DOOM ;;;  ;;      (user-error
;;NOT DOOM ;;;  ;;       "Not completing files currently")
;;NOT DOOM ;;;  ;;   )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (define-key dired-narrow-map (kbd "<return>") 'dired-narrow-quit-and-enter-file-or-dir)
;;NOT DOOM ;;;  ;; (define-key dired-narrow-map (kbd "RET") 'dired-narrow-quit-and-enter-file-or-dir)
;;NOT DOOM ;;;  ;; (define-key dired-narrow-map (kbd "C-e") 'exit-minibuffer)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; however the RET key by default is used to actually: start operating on the filtered files
;;NOT DOOM ;;;  ;; ;; --> define another key for that
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (define-key dired-narrow-map (kbd "<SPC>") 'exit-minibuffer)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; (defun exit-minibuffer-and-diredp-find-file-reuse-dir-buffer ()
;;NOT DOOM ;;;  ;; ;;   (interactive)
;;NOT DOOM ;;;  ;; ;;   (exit-minibuffer)
;;NOT DOOM ;;;  ;; ;;   (diredp-find-file-reuse-dir-buffer)
;;NOT DOOM ;;;  ;; ;; )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (define-key dired-narrow-map (kbd "RET") 'dired-narrow-quit-and-enter-file-or-dir)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;;; END DIRED STUFF ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;NOT DOOM ;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;; * open with external applications (in dired/ org-mode links / etc.)
;;
;; (use-package! dired-ranger
;;  after: dired)
;; (use-package! openwith
;; after: dired)
;; after! dired -> somehow not working
;; doesn't matter -> load it straight away, not so expensive
(require 'openwith)
(openwith-mode +1)

(after! dired
  (require 'openwith)
  (openwith-mode +1)
  )

;; (after! openwith
 (cond ((equal myhost "phone")
        (setq openwith-associations '(
                                      ("\\.jpg\\'" "termux-open" (file))
                                      ("\\.png\\'" "termux-open" (file))
                                      ("\\.pdf\\'" "termux-open" (file)))))
       ((equal myhost "laptop")
        (setq openwith-associations '(
                               ("\\.xoj\\'" "xournalpp" (file)) ;; xournalpp *can* open xoj-files (luckily)
                               ("\\.xopp\\'" "xournalpp" (file))
                               ("\\.pdf\\'" "okular" (file)))))
       (t ;; default dirty / for any linux version/machine
        (setq openwith-associations '(
                               ("\\.xoj\\'" "xournalpp" (file)) ;; xournalpp *can* open xoj-files (luckily)
                               ("\\.xopp\\'" "xournalpp" (file))
                               ("\\.avi\\'" "vlc" (file))
                               ("\\.pdf\\'" "okular" (file))))))
;; )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * save desktop sessions
;;NOT DOOM ;;;  ;;    (require 'session)
;;NOT DOOM ;;;  ;;    (add-hook 'after-init-hook 'session-initialize)
;;NOT DOOM ;;;  ;;(desktop-save-mode 1)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * sticky buffers (make possible for window to "stick" to its buffer)
;;NOT DOOM ;;;  (define-minor-mode sticky-buffer-mode
;;NOT DOOM ;;;    "Make the current window always display this buffer."
;;NOT DOOM ;;;    nil " sticky" nil
;;NOT DOOM ;;;    (set-window-dedicated-p (selected-window) sticky-buffer-mode))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; .) set ansi-term buffers sticky
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ..) this did not work! because at this point no window still exists: see discussion:  https://stackoverflow.com/questions/24152863/how-do-i-configure-emacs-to-dedicate-the-calculator-window
;;NOT DOOM ;;;  ;;(add-hook 'term-mode-hook 'sticky-buffer-mode)
;;NOT DOOM ;;;  ;; OR
;;NOT DOOM ;;;  ;;(add-hook 'term-mode-hook
;;NOT DOOM ;;;  ;;     (lambda () (sticky-buffer-mode)))
;;NOT DOOM ;;;  ;; ..) this also did not work! use advice function (see above thread and translate to modern elisp by seeing: https://www.gnu.org/software/emacs/manual/html_node/elisp/Porting-old-advice.html#Porting-old-advice
;;NOT DOOM ;;;  ;; (defun ansi-term--after ()
;;NOT DOOM ;;;  ;;   "Make the *ansi-term* window dedicated."
;;NOT DOOM ;;;   ;;  (let ((win (get-buffer-window "*ansi-term*")))
;;NOT DOOM ;;;   ;;    (when win
;;NOT DOOM ;;;     ;;      (set-window-dedicated-p win t))))
;;NOT DOOM ;;;   ;;  (set-window-dedicated-p  (get-buffer-window "*ansi-term*") t))
;;NOT DOOM ;;;  ;;)
;;NOT DOOM ;;;  ;;   (advice-add 'ansi-term :after 'ansi-term--after)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; .) this worked! :
;;NOT DOOM ;;;  ;;       *  manipulated the ansi-term function in term.el
;;NOT DOOM ;;;  ;;       * included a (sticky-buffer-mode) there
;;NOT DOOM ;;;  ;;       * dele
;;NOT DOOM ;;;  ;;       ted the term.elc file (not sure if this was necessary)
;;NOT DOOM ;;;  ;;       * renamed to mod_term.el and put to my load path (on dropbox)
;;NOT DOOM ;;;  ;;       * --> this effectively overwrites the usual term.el
;;NOT DOOM ;;;  ;;       * --> available for all my emacs computers
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * ) copy current buffer path clipboard
;;NOT DOOM ;;;  (defun cp-fullpath-of-current-buffer ()
;;NOT DOOM ;;;    "copy full path into clipboard"
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (when buffer-file-name
;;NOT DOOM ;;;      (setq filepath (file-name-directory buffer-file-name))
;;NOT DOOM ;;;      (kill-new  filepath)
;;NOT DOOM ;;;      (message (concat "copied current file path: " filepath   ))))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * ) ido-mode
;;NOT DOOM ;;;  ;; (require 'ido)
;;NOT DOOM ;;;      ;; (ido-mode t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * helm
;;NOT DOOM ;;; (use-package helm
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  (global-set-key (kbd "M-x") #'helm-M-x)
;;NOT DOOM ;;;  (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
;;NOT DOOM ;;;  (global-set-key (kbd "C-x C-f") #'helm-find-files)
;;NOT DOOM ;;;  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** helm describe modes
;;NOT DOOM ;;; (use-package helm-describe-modes
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  (global-set-key [remap describe-mode] #'helm-describe-modes)
;;NOT DOOM ;;;  ;; (setq helm-display-function 'helm-display-buffer-in-own-frame
;;NOT DOOM ;;;  ;;         helm-display-buffer-reuse-frame nil
;;NOT DOOM ;;;  ;;         helm-use-undecorated-frame-option nil)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** helm window
;;NOT DOOM ;;;  ;; *** option1 (full frame)
;;NOT DOOM ;;;  ;; (setq helm-full-frame t)
;;NOT DOOM ;;;  ;; (setq helm-autoresize-max-height 0)
;;NOT DOOM ;;;  ;; (setq helm-autoresize-min-height 20)
;;NOT DOOM ;;;  ;; (setq shackle-rules '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :ratio 0.4)))
;;NOT DOOM ;;;  ;; (setq helm-buffer-max-length 70) ;; file name column width
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; *** option2 (half frame, show only current buffer aside)
;;NOT DOOM ;;;  ;; (setq helm-split-window-in-side-p nil)
;;NOT DOOM ;;;  ;; (helm-autoresize-mode t)
;;NOT DOOM ;;;  ;; (setq helm-autoresize-max-height 50)
;;NOT DOOM ;;;  ;; (setq helm-autoresize-min-height 50)
;;NOT DOOM ;;;  ;; (setq shackle-rules '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :ratio 0.4)))
;;NOT DOOM ;;;  ;; (setq helm-buffer-max-length 70) ;; file name column width
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; *** option3 (half frame, show all buffers aside, compressed)
;;NOT DOOM ;;;  (add-to-list 'display-buffer-alist
;;NOT DOOM ;;;               '("\\`\\*helm"
;;NOT DOOM ;;;                 (display-buffer-in-side-window)
;;NOT DOOM ;;;                 (window-height . 0.4)))
;;NOT DOOM ;;;  (setq helm-display-function #'display-buffer)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * projectile
;;NOT DOOM ;;; (use-package projectile
;;NOT DOOM ;;;     :ensure t)
;;NOT DOOM ;;;  (projectile-global-mode)
;;NOT DOOM ;;;  (setq projectile-completion-system 'helm)
;;NOT DOOM ;;; (use-package helm-projectile
;;NOT DOOM ;;;     :ensure t)
;;NOT DOOM ;;;  (helm-projectile-on)
;;NOT DOOM ;;;  (setq projectile-indexing-method 'native)
;;NOT DOOM ;;;  (setq projectile-enable-caching t)
;;NOT DOOM ;;;  (setq helm-exit-idle-delay 0)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * matlab
;;NOT DOOM ;;;  ;;; ** Matlab matlab-emacs project;;
;;NOT DOOM ;;;  load-path
;;NOT DOOM ;;;  (setq path_to_matlab_emacs (concat my_load_path "matlab-emacs-src")) ;; the init file folder contains also all manual packages
;;NOT DOOM ;;;  (add-to-list 'load-path path_to_matlab_emacs)
;;NOT DOOM ;;;  (load-library "matlab-load")
;;NOT DOOM ;;;  (load-library "matlab")
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (matlab-cedet-setup)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (add-hook 'matlab-mode-hook
;;NOT DOOM ;;;            (lambda nil (auto-complete-mode)
;;NOT DOOM ;;;              (rainbow-delimiters-mode t)
;;NOT DOOM ;;;              ))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (add-hook 'M-shell-mode-hook
;;NOT DOOM ;;;   	     (lambda nil (company-mode)))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; turn off auto-fill-mode
;;NOT DOOM ;;;  ;; ;; (still does not work --> todo)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (add-hook 'matlab-mode-hook
;;NOT DOOM ;;;   	     (lambda nil (auto-fill-mode -1)))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** personal color theme manipulation
;;NOT DOOM ;;;  (set-face-attribute 'matlab-unterminated-string-face t :foreground "dark blue" :underline t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; tweak matlab key map
;;NOT DOOM ;;;  (define-key matlab-mode-map "\M-j" 'windmove-down)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
(load "my_matlab_hacks.el")
;;NOT DOOM ;;;  ;;; MATLAB comodity things
;;NOT DOOM ;;;  (defun send-string-to-matlab-shell-buffer-and-execute (sendstring)
;;NOT DOOM ;;;    "execute region line by line in interactive shell (buffer *shell*)."
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;      ; get region into string
;;NOT DOOM ;;;      (save-excursion
;;NOT DOOM ;;;        (set-buffer (get-buffer-create "*MATLAB*"))
;;NOT DOOM ;;;       (end-of-buffer)
;;NOT DOOM ;;;       (insert (concat sendstring))
;;NOT DOOM ;;;       (comint-send-input) ;; execute
;;NOT DOOM ;;;       (end-of-buffer)
;;NOT DOOM ;;;  ;;       (set-buffer (get-buffer-create "*MATLAB*"))
;;NOT DOOM ;;;  ;;      (end-of-buffer)
;;NOT DOOM ;;;  ;;      (insert (concat scriptname))
;;NOT DOOM ;;;  ;;      (comint-send-input) ;; execute
;;NOT DOOM ;;;  ;;      (end-of-buffer)
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;      ;; if executed within matlab-shell buffer --> move end of buffer
;;NOT DOOM ;;;      (if (string-equal (buffer-name) "*MATLAB*")
;;NOT DOOM ;;;          (end-of-buffer)
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;      (matlab-shell-end-of-buffer) ;; scroll down always
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun matlab-shell-end-of-buffer ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;      ; get region into string
;;NOT DOOM ;;;      ;; (save-excursion
;;NOT DOOM ;;;        ;; (set-buffer (get-buffer-create "*MATLAB*"))
;;NOT DOOM ;;;        (setq current-buffer (buffer-name))
;;NOT DOOM ;;;        (setq matlab-shell-window (get-buffer-window "*MATLAB*"))
;;NOT DOOM ;;;        (save-excursion
;;NOT DOOM ;;;          (set-buffer (get-buffer-create "*MATLAB*"))
;;NOT DOOM ;;;          (setq end-point-matlab-shell (point-max)))
;;NOT DOOM ;;;        (set-window-point matlab-shell-window end-point-matlab-shell)
;;NOT DOOM ;;;        ;; (switch-to-buffer "*MATLAB*")
;;NOT DOOM ;;;        ;; (comint-send-input "")
;;NOT DOOM ;;;        ;; (switch-to-buffer current-buffer)
;;NOT DOOM ;;;       ;; (end-of-buffer)
;;NOT DOOM ;;;      ;; )
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;  ;; alternative 1 --> but has to be launched from script
;;NOT DOOM ;;;  ;; (defun send-scriptname-to-shell-buffer-and-execute ()
;;NOT DOOM ;;;  ;;   (interactive)
;;NOT DOOM ;;;  ;;   (save-buffer)
;;NOT DOOM ;;;  ;;     ; get script name (has to be done before save-excursion, since he then quits buffer)
;;NOT DOOM ;;;  ;;     (setq scriptname (file-name-nondirectory (file-name-sans-extension (buffer-file-name))))
;;NOT DOOM ;;;  ;;     (save-excursion
;;NOT DOOM ;;;  ;;       (set-buffer (get-buffer-create "*MATLAB*"))
;;NOT DOOM ;;;  ;;      (end-of-buffer)
;;NOT DOOM ;;;  ;;      (insert (concat scriptname))
;;NOT DOOM ;;;  ;;      (comint-send-input) ;; execute
;;NOT DOOM ;;;  ;;      (end-of-buffer)
;;NOT DOOM ;;;  ;;     )
;;NOT DOOM ;;;  ;;     ;; if executed within matlab-shell buffer --> move end of buffer
;;NOT DOOM ;;;  ;;     (matlab-shell-end-of-buffer)
;;NOT DOOM ;;;  ;;     ;; (if (string-equal (buffer-name) "*MATLAB*")
;;NOT DOOM ;;;  ;;         ;; (end-of-buffer)
;;NOT DOOM ;;;  ;;     ;; )
;;NOT DOOM ;;;  ;; )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (alternative)
;;NOT DOOM ;;;  (defun send-scriptname-to-matlab-shell-buffer-and-execute ()
;;NOT DOOM ;;;    "execute "
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (setq this-buffer-filename-base (file-name-base (buffer-file-name)))
;;NOT DOOM ;;;    (send-string-to-matlab-shell-buffer-and-execute this-buffer-filename-base)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun save-and-send-scriptname-to-matlab-shell-buffer-and-execute ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (save-buffer)
;;NOT DOOM ;;;    (send-scriptname-to-matlab-shell-buffer-and-execute)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun send-current-line-to-matlab-shell-buffer-and-execute ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (move-beginning-of-line nil)
;;NOT DOOM ;;;    (setq beginofline (point))
;;NOT DOOM ;;;    (move-end-of-line nil)
;;NOT DOOM ;;;    (setq endofline (point))
;;NOT DOOM ;;;    (setq currentlinestring (buffer-substring beginofline endofline))
;;NOT DOOM ;;;
;;NOT DOOM ;;;    (send-string-to-matlab-shell-buffer-and-execute currentlinestring)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun send-current-region-to-matlab-shell-buffer-and-execute ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;      (setq region_string (buffer-substring (mark) (point)))
;;NOT DOOM ;;;      (send-string-to-matlab-shell-buffer-and-execute region_string)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun send-variable-at-cursor-matlab-shell-buffer-and-execute ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;      (setq variable_name (thing-at-point 'symbol))
;;NOT DOOM ;;;      (send-string-to-matlab-shell-buffer-and-execute variable_name)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun send-current-region-line-by-line-to-matlab-shell-buffer-and-execute ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;     (save-excursion
;;NOT DOOM ;;;       ; get line numbers of region beginning/end
;;NOT DOOM ;;;       (setq beginning_line_number (line-number-at-pos (region-beginning)))
;;NOT DOOM ;;;       (setq ending_line_number (line-number-at-pos (region-end)))
;;NOT DOOM ;;;
;;NOT DOOM ;;;      ;; (message (format "%i" beginning_line_number) )
;;NOT DOOM ;;;      ;; (message (format "%i" ending_line_number) )
;;NOT DOOM ;;;      (setq current_line_number beginning_line_number)
;;NOT DOOM ;;;      (goto-line beginning_line_number)
;;NOT DOOM ;;;      ;(message (format "%i" current_line_number) )
;;NOT DOOM ;;;        (while (< current_line_number (- ending_line_number 1))
;;NOT DOOM ;;;            (send-current-line-to-matlab-shell-buffer-and-execute)
;;NOT DOOM ;;;            ;; (message (format "%i" current_line_number) )
;;NOT DOOM ;;;            (setq current_line_number (line-number-at-pos (point)))
;;NOT DOOM ;;;            (forward-line)
;;NOT DOOM ;;;        )
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun send-current-line-or-region-line-by-line-to-matlab-shell-buffer-and-execute ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;     (if (use-region-p)
;;NOT DOOM ;;;       (send-current-region-line-by-line-to-matlab-shell-buffer-and-execute)
;;NOT DOOM ;;;       (send-current-line-to-matlab-shell-buffer-and-execute)
;;NOT DOOM ;;;     )
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun matlab-dbstep()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (send-string-to-matlab-shell-buffer-and-execute "dbstep")
;;NOT DOOM ;;;    ;; (matlab-jump-to-current-debug-position) ;; --> this was not working fluently
;;NOT DOOM ;;;    ;; --> instead: assume were still in the same file and procede to new line
;;NOT DOOM ;;;    ;; (sleep-for 10)
;;NOT DOOM ;;;    ;; (message "sleeping ...")
;;NOT DOOM ;;;    ;; (call-process "sleep" nil nil nil "1")
;;NOT DOOM ;;;    ;; (message "finished ...")
;;NOT DOOM ;;;    (matlab-get-jump-new-line-number-from-last-debug-output)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun matlab-dbcont()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (send-string-to-matlab-shell-buffer-and-execute "dbcont")
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun matlab-set-breakpoint-current-line()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    ; get line number
;;NOT DOOM ;;;    (setq line-nr (number-to-string (line-number-at-pos)))
;;NOT DOOM ;;;    ; get file name without ".m" extension
;;NOT DOOM ;;;   (setq filename-base (file-name-base (buffer-file-name)))
;;NOT DOOM ;;;    (send-string-to-matlab-shell-buffer-and-execute (concat "dbstop " filename-base " at " line-nr))
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun matlab-dbclear-all()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (send-string-to-matlab-shell-buffer-and-execute "dbclear all")
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun matlab-dbquit()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (send-string-to-matlab-shell-buffer-and-execute "dbquit")
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun matlab-dbclear-current-file()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (setq filename-base (file-name-base (buffer-file-name)))
;;NOT DOOM ;;;    (send-string-to-matlab-shell-buffer-and-execute (concat "dbclear " filename-base))
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun matlab-get-jump-new-line-number-from-last-debug-output ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (save-excursion
;;NOT DOOM ;;;      ; go to matlab shell buffer
;;NOT DOOM ;;;      (set-buffer (get-buffer-create "*MATLAB*"))
;;NOT DOOM ;;;      ; get last line of debug output
;;NOT DOOM ;;;      (end-of-buffer)
;;NOT DOOM ;;;      (forward-line -1) ; first move up one line
;;NOT DOOM ;;;      (move-beginning-of-line nil)
;;NOT DOOM ;;;      (setq beginofline (point))
;;NOT DOOM ;;;      (move-end-of-line nil)
;;NOT DOOM ;;;      (setq endofline (point))
;;NOT DOOM ;;;      (setq line-string (buffer-substring beginofline endofline))
;;NOT DOOM ;;;      (message line-string)
;;NOT DOOM ;;;      ; extract the file-name and line-nr
;;NOT DOOM ;;;      (string-match "\\([0-9][0-9]*\\) .*" line-string)
;;NOT DOOM ;;;      (setq line-nr (match-string 1  line-string)) ; group 1
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;      (goto-line (string-to-number line-nr))
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun matlab-jump-to-current-debug-position ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    ;; (sleep-for 0.1)
;;NOT DOOM ;;;    ;; produce current debug position information
;;NOT DOOM ;;;    (send-string-to-matlab-shell-buffer-and-execute "dbstack")
;;NOT DOOM ;;;    ;; get the line nr and file name
;;NOT DOOM ;;;    (save-excursion
;;NOT DOOM ;;;      ; go to matlab shell buffer
;;NOT DOOM ;;;      (set-buffer (get-buffer-create "*MATLAB*"))
;;NOT DOOM ;;;      ; get last line of debug output
;;NOT DOOM ;;;      (forward-line -1) ; first move up one line
;;NOT DOOM ;;;      (move-beginning-of-line nil)
;;NOT DOOM ;;;      (setq beginofline (point))
;;NOT DOOM ;;;      (move-end-of-line nil)
;;NOT DOOM ;;;      (setq endofline (point))
;;NOT DOOM ;;;      (setq line-string (buffer-substring beginofline endofline))
;;NOT DOOM ;;;      ; extract the file-name and line-nr
;;NOT DOOM ;;;      ;;       e.g. "> In script1 (line 99)" --> return "script1" (group 1) and "99" (group 2)
;;NOT DOOM ;;;      (setq finished nil)
;;NOT DOOM ;;;      (while (not finished)
;;NOT DOOM ;;;             (forward-line -1) ;line up
;;NOT DOOM ;;;             (move-beginning-of-line nil)
;;NOT DOOM ;;;             (setq beginofline (point))
;;NOT DOOM ;;;             (move-end-of-line nil)
;;NOT DOOM ;;;             (setq endofline (point))
;;NOT DOOM ;;;             (setq line-string (buffer-substring beginofline endofline))
;;NOT DOOM ;;;
;;NOT DOOM ;;;             ;; could be something like this "> In transit/expand (line 82)" --> get "transit"
;;NOT DOOM ;;;             (if (string-match "> In \\([^ /]*\\).* (line \\([0-9][0-9]*\\))" line-string)
;;NOT DOOM ;;;                 (setq finished t)
;;NOT DOOM ;;;               )
;;NOT DOOM ;;;             )
;;NOT DOOM ;;;      (setq filename-base (match-string 1  line-string)) ; group 1
;;NOT DOOM ;;;      (setq line-nr (match-string 2  line-string)) ; group 2
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;    ;; now after exursion / retrieving the information
;;NOT DOOM ;;;    ;; --> jump to the position in current buffer
;;NOT DOOM ;;;    ;; first, if not already in current-debug-file --> open it in current buffer
;;NOT DOOM ;;;    ; get file name base of current buffer
;;NOT DOOM ;;;    (setq this-buffer-filename-base (file-name-base (buffer-file-name)))
;;NOT DOOM ;;;    (if (not (string-equal this-buffer-filename-base filename-base))
;;NOT DOOM ;;;        (find-file (concat filename-base ".m"))
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;    ;; go to line
;;NOT DOOM ;;;    (goto-line (string-to-number line-nr))
;;NOT DOOM ;;;    (message (concat "going to current debug position: " filename-base " line: "line-nr))
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;  ;; MATLAB-DEBUG/RUN SHORT-CUTS (could serve generalistically for other languages)
;;NOT DOOM ;;;  ;; SET BREAKPOINT <F12>
;;NOT DOOM ;;;  (define-key matlab-mode-map (kbd "<f12>") 'matlab-set-breakpoint-current-line)
;;NOT DOOM ;;;  ;; DEBUG STEP <F10>
;;NOT DOOM ;;;  (define-key matlab-mode-map (kbd "<f10>") 'matlab-dbstep)
;;NOT DOOM ;;;  ;; DEBUG CONTINUE <F6> (todo--> could be united with F5, detect if in debug process)
;;NOT DOOM ;;;  (define-key matlab-mode-map (kbd "<f6>") 'matlab-dbcont)
;;NOT DOOM ;;;  ;; RUN script <F5>
;;NOT DOOM ;;;  (define-key matlab-mode-map (kbd "<f5>") 'save-and-send-scriptname-to-matlab-shell-buffer-and-execute)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (define-key matlab-mode-map (kbd "<f9>") 'send-current-line-or-region-line-by-line-to-matlab-shell-buffer-and-execute)
;;NOT DOOM ;;;  ;; DEBUG QUIT <F8>
;;NOT DOOM ;;;  (define-key matlab-mode-map (kbd "<f8>") 'matlab-dbquit)
;;NOT DOOM ;;;  ;; CLEAR BREAK POINTS current file
;;NOT DOOM ;;;  (define-key matlab-mode-map (kbd "<f7>") 'matlab-dbclear-all)
;;NOT DOOM ;;;  ;; EVALUATE/RUN SELECTION <F9>
;;NOT DOOM ;;;  (define-key matlab-mode-map (kbd "<f9>") 'send-current-region-to-matlab-shell-buffer-and-execute)
;;NOT DOOM ;;;  ;; EVALUATE/RUN SELECTION <F9>
;;NOT DOOM ;;;  ;; (define-key matlab-mode-map (kbd "<f7>") 'send-variable-at-cursor-matlab-shell-buffer-and-execute)
;;NOT DOOM ;;;  ;; JUMP TO CURRENT DEBUG POS <F11> (todo --> just for now because automatic not working flawlessly)
;;NOT DOOM ;;;  (define-key matlab-mode-map (kbd "<f11>") 'matlab-jump-to-current-debug-position)
;;NOT DOOM ;;;  ;;; END MATLAB COMODITIES
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; matlab shell key bindings (--> have to be implemented as hooks, since matlab-shell-mode-map does not exist before opening a matlab-shell()
;;NOT DOOM ;;;  (add-hook 'matlab-shell-mode-hook
;;NOT DOOM ;;;            (lambda ()
;;NOT DOOM ;;;              (define-key matlab-shell-mode-map (kbd "<f10>") 'matlab-dbstep)
;;NOT DOOM ;;;              (define-key matlab-shell-mode-map (kbd "<f8>") 'matlab-dbquit)
;;NOT DOOM ;;;              (define-key matlab-shell-mode-map (kbd "<f7>") 'matlab-dbclear-all)
;;NOT DOOM ;;;              (define-key matlab-shell-mode-map (kbd "<f6>") 'matlab-dbcont)
;;NOT DOOM ;;;              ;; set Alt-p for "go up" --> my own 'convenient convention' for all types of command shells
;;NOT DOOM ;;;              (define-key matlab-shell-mode-map (kbd "M-p") 'matlab-shell-previous-matching-input-from-input)
;;NOT DOOM ;;;              (define-key matlab-shell-mode-map (kbd "M-n") 'matlab-shell-next-matching-input-from-input)
;;NOT DOOM ;;;              ))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; color theme for matlab, defined by my own
;;NOT DOOM ;;;  ;; (load "color-theme-matlab.el")
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (if color-theme-buffer-local-switch
;;NOT DOOM ;;;  ;;     (add-hook 'matlab-mode-hook
;;NOT DOOM ;;;  ;;       (lambda nil (color-theme-buffer-local 'color-theme-matlab (current-buffer))))
;;NOT DOOM ;;;  ;;   )
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; END GENREAL STUFF ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * recentf (recent files)
;;NOT DOOM ;;; (use-package recentf
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;  ; Enable recentf mode
;;NOT DOOM ;;;  (recentf-mode t)
;;NOT DOOM ;;;  ; Show last 200 files (with helm-interface no problem, i have easily 100+ files open and want to quickly access them in future session)
;;NOT DOOM ;;;  (setq recentf-max-saved-items 200)
;;NOT DOOM ;;;  (setq recentf-max-menu-items 200)
;;NOT DOOM ;;;  ; Reset C-x C-r to display recently opened files
;;NOT DOOM ;;;  (global-set-key "\C-x\ \C-r" 'recentf-open-files)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * latex (auctex)
;;NOT DOOM ;;;  ;; somehow auctex does not load with (require 'auctex) (i don t like that and think the guys should do loading consistent with standard like other packages, but whatever..)
;;NOT DOOM ;;;  ;; but auctex-manual instructs like this
;;NOT DOOM ;;; ;; (use-package auctex
;;NOT DOOM ;;; ;;    :ensure t)
;;NOT DOOM ;;; ;; (require 'auctex)
;;NOT DOOM ;;; ;;t (load "auctex.el" nil t t)
;;NOT DOOM ;;; ;;t (load "latex.el" nil t t)
;;NOT DOOM ;;;  ;;(load "preview-latex.el" nil t t)

;; org-mode default bullet chars
(add-hook! org-mode
           ;; TODO "require superstar" -> how best in doom emacs
  (make-variable-buffer-local 'org-superstar-headline-bullets-list)
  (setq org-superstar-headline-bullets-list '(
                                              "◉"
                                              "○"
                                              "•"
                                              "★"
                                              "✸"
                                              "◆"
                                              "♣"
                                              "♠"
                                              "♥"
                                              "♦")))

;; toggle latex preview
(after! org
  (defvar org-latex-previews-toggled-on nil)
  ;; outcomment following: tried to be smart with buffer-local var, but not necessary and created bug-errors
  ;; (add-hook! org-mode
  ;; (make-variable-buffer-local org-latex-previews-toggled-on))
    (defun org-latex-preview-all ()
  (interactive)
  ;; (let ((current-prefix-arg 16)) (call-interactively 'org-latex-preview))
  (org-latex-preview '(16)))

(defun org-latex-clear-all ()
  (interactive)
  (org-latex-preview '(64)))


(defun org-latex-refresh-all ()
  (interactive)
  (org-latex-clear-all)
  (org-latex-preview-all))

(defun org-latex-preview-toggle-clear-preview-all ()
  (interactive)
  (cond ((equal org-latex-previews-toggled-on nil)
         (org-latex-preview-all)
         (setq org-latex-previews-toggled-on t))
	((equal org-latex-previews-toggled-on t)
         (org-latex-clear-all)
         (setq org-latex-previews-toggled-on nil))))

(map! :map 'org-mode-map :n "zp" 'org-latex-preview)
(map! :map 'org-mode-map :n "zP" 'org-latex-preview-toggle-clear-preview-all)
)

;;NOT DOOM ;;;
;;NOT DOOM ;;; ;; * latex short cuts for formatting (bold/italic/etc)
;;NOT DOOM ;;;  (defun js/latex-toggle-bold-region ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (my-toggle-marker-around-region "\\textbf{" "\\textbf{"  "}" "}")
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (evil-leader/set-key-for-mode 'lateX-mode  "jb" 'latex-toggle-bold-region)
;;NOT DOOM ;;;
;;NOT DOOM ;;; ;; * latex tables
;;NOT DOOM ;;; ;; ** quick align
;;NOT DOOM ;;;
;;NOT DOOM ;;; (defun latex-tabular-align ()
;;NOT DOOM ;;;   (interactive)
;;NOT DOOM ;;;   ;; * search for begin/end tabular
;;NOT DOOM ;;;   (save-excursion
;;NOT DOOM ;;;     (search-backward "\\begin{tabular")
;;NOT DOOM ;;;     (setq BEG (point))
;;NOT DOOM ;;;     (search-forward "\\end{tabular")
;;NOT DOOM ;;;     (setq END (point)))
;;NOT DOOM ;;;   ;; * align
;;NOT DOOM ;;;   (align BEG END))
;;NOT DOOM ;;;
;;NOT DOOM ;;; ;; bind
;;NOT DOOM ;;; ;; (general-define-key
;;NOT DOOM ;;; ;;  :states 'normal
;;NOT DOOM ;;; ;;  :keymaps 'LaTeX-mode-map
;;NOT DOOM ;;; ;;  :prefix ","
;;NOT DOOM ;;; ;;  "a" 'latex-tabular-align)
;;NOT DOOM ;;;
;;NOT DOOM ;;; ;; (my-local-leader1-def
;;NOT DOOM ;;; ;;   :states 'normal
;;NOT DOOM ;;; ;;   :keymaps 'LaTeX-mode-map
;;NOT DOOM ;;; ;;   "a" 'latex-tabular-align)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** hook latex with minor-outline-mode
;;NOT DOOM ;;;  (add-hook 'LaTeX-mode-hook 'outline-minor-mode)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (evil-define-minor-mode-key 'normal 'outline-minor-mode (kbd "TAB") 'org-cycle) ;; comment: org and outline go hand-in-hand, the org-function kind of "expand" the outline-functions, in pure outline-mode there is no toggling function
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** hook with TeX-fold-mode (the shit to hide figures/tables and stuff)
;;NOT DOOM ;;;  ;;   (does not conflict with outline-minor-mode, yeah)
;;NOT DOOM ;;;  ;;   usefull functions:
;;NOT DOOM ;;;  ;;                     go to figure/table and M-x TeX-fold-env
;;NOT DOOM ;;;  (add-hook 'LaTeX-mode-hook 'TeX-fold-mode)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;; ** F5 -> run pdflatex / F6 -> bibtex
(after! latex
(defun js/run-pdflatex-on-master-file ()
"This function just runs LaTeX (pdflatex in case of TeX-PDF-mode), without asking what command to run everytime."
(interactive)
;;save buffer
(save-buffer)
;; * option1:
(TeX-command "LaTeX" 'TeX-master-file nil)
;; * option2: (discarded)
;; (save-buffer)
;; (shell-command (format "pdflatex %s.tex" (TeX-master-file)))
;; * show compile window, where pointer is always at end
;; (TeX-recenter-output-buffer) ;; this did not work... try later (todo)
)
(define-key LaTeX-mode-map (kbd "<f5>") 'js/run-pdflatex-on-master-file)
(define-key LaTeX-mode-map (kbd "<f6>") 'run-bibtex-on-master-file)
)

;;NOT DOOM ;;;  (defun run-bibtex-on-master-file ()
;;NOT DOOM ;;;  "This function just runs LaTeX (pdflatex in case of TeX-PDF-mode), without asking what command to run everytime."
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;  (TeX-command "BibTeX" 'TeX-master-file nil)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** other handy short-cuts with leader-key
;;NOT DOOM ;;;  ;;T (evil-leader/set-key-for-mode 'LaTeX-mode "lv" 'TeX-view)
;;NOT DOOM ;;;  ;; ** color short-cuts
;;NOT DOOM ;;;  ;; todo: sth still wrong -> hello ->  \red{h}ello ↯↯↯
;;NOT DOOM ;;;  ;; (defun latex-toggle-red-region ()
;;NOT DOOM ;;;  ;;   (interactive)
;;NOT DOOM ;;;  ;;   (my-toggle-marker-around-region "\\red{" "\\red{"  "}" "}")
;;NOT DOOM ;;;  ;;   )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (evil-leader/set-key-for-mode 'latex-mode  "jb" 'org-toggle-bold-region)
;;NOT DOOM ;;;  ;; (evil-leader/set-key-for-mode 'latex-mode  "ji" 'org-toggle-italic-region)
;;NOT DOOM ;;;  ;; (evil-leader/set-key-for-mode 'latex-mode  "jc" 'org-toggle-code-region)
;;NOT DOOM ;;;  ;; (evil-leader/set-key-for-mode 'LaTeX-mode "j" 'latex-toggle-red-region)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; ** how to view pdf (setq TeX-view-program-list '(("Okular" "okular --unique %u")))
;;NOT DOOM ;;; ;;    TODO: revisit this! line (server-start) made emacs init halt until key press for some reason
;;NOT DOOM ;;;  ;; (add-hook 'LaTeX-mode-hook (lambda ()
;;NOT DOOM ;;;  ;;                   (add-to-list 'TeX-expand-list
;;NOT DOOM ;;;  ;;                        '("%u" Okular-make-url))))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (defun Okular-make-url () (concat
;;NOT DOOM ;;;  ;;                "file://"
;;NOT DOOM ;;;  ;;                (expand-file-name (funcall file (TeX-output-extension) t)
;;NOT DOOM ;;;  ;;                          (file-name-directory (TeX-master-file)))
;;NOT DOOM ;;;  ;;                "#src:"
;;NOT DOOM ;;;  ;;                (TeX-current-line)
;;NOT DOOM ;;;  ;;                (expand-file-name (TeX-master-directory))
;;NOT DOOM ;;;  ;;                "./"
;;NOT DOOM ;;;  ;;                (TeX-current-file-name-master-relative)))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (setq TeX-view-program-selection '((output-pdf "Okular")))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; *** setup viewer (okular) with synref
;;NOT DOOM ;;;  ;;;    how to use:
;;NOT DOOM ;;;  ;;     (https://tex.stackexchange.com/questions/161797/how-to-configure-emacs-and-auctex-to-perform-forward-and-inverse-search)
;;NOT DOOM ;;;  ;;;              go from emacs to okular ("forward search"): --> hit C-c C-v --> voila, okular opens exactly the position
;;NOT DOOM ;;;  ;;;              go from okular to emacs ("inverse search"): (mind, only works with emacsclient/daemon)  --> Shift-MouseLeft on position
;;NOT DOOM ;;;  ;;;     prerequisite - okular settings: simply: okular--> settings --> configure Okular --> Editor --> emacsclient
;;NOT DOOM ;;;  ;; (server-start)
;;NOT DOOM ;;;  ;; (setq TeX-view-program-selection '((output-pdf "Okular")))
;;NOT DOOM ;;;  ;; (setq TeX-source-correlate-mode t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** make more easy/natural to read
;;NOT DOOM ;;;  ;; *** break lines naturally
;;NOT DOOM ;;;  (add-hook 'LaTeX-mode-hook 'visual-line-mode)
;;NOT DOOM ;;;  ;; *** (did not work out) show prose in block text, more easy/natural to read (--> auto-fill-mode)
;;NOT DOOM ;;;  ;; (add-hook 'LaTeX-mode-hook 'auto-fill-mode)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; ** reftex
;;NOT DOOM ;;;  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
;;NOT DOOM ;;;  (setq reftex-plug-into-AUCTeX t)
;;NOT DOOM ;;;  ;;
;;NOT DOOM ;;;  (setq reftex-cite-format 'natbib)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (setq reftex-refstyle "\\autoref")
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; ** aspell
;;NOT DOOM ;;;  (setq-default ispell-program-name "aspell")
;;NOT DOOM ;;;  ;(setq ispell-program-name "aspell")
;;NOT DOOM ;;;       ; could be ispell as well, depending on your preferences ;
;;NOT DOOM ;;;  (setq ispell-dictionary "english") ;
;;NOT DOOM ;;;       ; this can obviously be set to any language your spell-checking program supports
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
;;NOT DOOM ;;;  (add-hook 'LaTeX-mode-hook 'flyspell-buffer)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; flymake
;;NOT DOOM ;;; (use-package flymake
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun flymake-get-tex-args (file-name) (list "pdflatex"
;;NOT DOOM ;;;     (list "-file-line-error" "-draftmode" "-interaction=nonstopmode" file-name)))
;;NOT DOOM ;;;  (add-hook 'LaTeX-mode-hook 'flymake-mode)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** misc settings
;;NOT DOOM ;;;       (setq TeX-parse-self t) ; Enable parse on load.
;;NOT DOOM ;;;       (setq TeX-auto-save t) ; Enable parse on save.
;;NOT DOOM ;;;       (setq TeX-save-query nil) ; Dont ask if to save every time, just save and run LaTeX
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;(require 'tex-mik)
;;NOT DOOM ;;;  (setq TeX-PDF-mode t) ; pdf mode (for preview latex would need to be true, but preview latex currently not used)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (setq-default TeX-master nil) ; Query for master file.
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; ** my latex-editing functions
;;NOT DOOM ;;;  (defun include-input-toggle ()
;;NOT DOOM ;;;  "This function toggles between include and input"
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;        (let ((occured)
;;NOT DOOM ;;;                        )
;;NOT DOOM ;;;           (save-excursion
;;NOT DOOM ;;;                (beginning-of-buffer)
;;NOT DOOM ;;;                (while (search-forward "\include{"  nil t)
;;NOT DOOM ;;;                       (replace-match "\input{" nil t)
;;NOT DOOM ;;;  		     (setq occured t)
;;NOT DOOM ;;;                )
;;NOT DOOM ;;;                (if (eq occured nil)
;;NOT DOOM ;;;                 (while (search-forward "\input{"  nil t)
;;NOT DOOM ;;;                       (replace-match "\include{" nil t)
;;NOT DOOM ;;;  		     (setq occured t)
;;NOT DOOM ;;;                  )
;;NOT DOOM ;;;                )
;;NOT DOOM ;;;           )
;;NOT DOOM ;;;        occured
;;NOT DOOM ;;;        )
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;  (defun view-with-texworks ()
;;NOT DOOM ;;;  "This function opens the main pdf file of the LaTeX-project with texworks."
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;  (shell-command "texworks c:/Users/Joe/Documents/Beruf/PUC/'Trabajo de investigacion'/Studienarbeit/Alembic_Final_Report.pdf"))
;;NOT DOOM ;;;  ;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun eps-convert-all-in-folder ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (setq pnglist (directory-files (file-name-directory buffer-file-name) nil "\\.png"))
;;NOT DOOM ;;;    (dolist (pngfile pnglist)
;;NOT DOOM ;;;      (setq filename (file-name-sans-extension pngfile))
;;NOT DOOM ;;;      (shell-command (format "sam2p %s.png %s.eps" filename filename))
;;NOT DOOM ;;;      ;; sam2p image.png image.eps
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;
;;NOT DOOM ;;;    (setq jpglist (directory-files (file-name-directory buffer-file-name) nil "\\.jpg"))
;;NOT DOOM ;;;    (dolist (jpgfile jpglist)
;;NOT DOOM ;;;      (setq filename (file-name-sans-extension jpgfile))
;;NOT DOOM ;;;      (shell-command (format "sam2p %s.jpg %s.eps" filename filename))
;;NOT DOOM ;;;      ;; sam2p image.jpg image.eps
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;
;;NOT DOOM ;;;    (setq pdflist (directory-files (file-name-directory buffer-file-name) nil "\\.pdf"))
;;NOT DOOM ;;;    (dolist (pdffile pdflist)
;;NOT DOOM ;;;      (setq filename (file-name-sans-extension pdffile))
;;NOT DOOM ;;;      (if (not (string-match "eps-converted-to" filename)) ;;unless is conversion of latex's "pdftoeps"-package
;;NOT DOOM ;;;  	(shell-command (format "sam2p %s.pdf %s.eps" filename filename))
;;NOT DOOM ;;;        ;; sam2p image.pdf image.eps
;;NOT DOOM ;;;        )
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun eps-convert-file (file)  ;;requires installation and path-variable-entry for "nircmd" program
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (shell-command (format "sam2p %s %s.eps" file (file-name-sans-extension file)))
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun paste-image-latex ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;  (setq label (read-string "Image label and file name: "))
;;NOT DOOM ;;;  (shell-command (format "nircmd clipboard saveimage %s.png" label))
;;NOT DOOM ;;;  (eps-convert-file (format "%s.png" label))
;;NOT DOOM ;;;  (setq caption (read-string "Caption: "))
;;NOT DOOM ;;;  (setq begin (point)) ;; save beginning
;;NOT DOOM ;;;  (insert "\\" "begin{figure}[H]\n"
;;NOT DOOM ;;;   	"\\" "centering\n"
;;NOT DOOM ;;;  	"\\" "includegraphics[keepaspectratio, height=150pt]{" label "}\n"
;;NOT DOOM ;;;  	"\\" "caption{" caption "}\n"
;;NOT DOOM ;;;  	"\\" "label{fig:" label "}\n"
;;NOT DOOM ;;;  	"\\" "end{figure}\n" )
;;NOT DOOM ;;;  (setq end (point)) ;; save end
;;NOT DOOM ;;;  (preview-region begin end)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (global-set-key (kbd "<f9>") 'paste-image-latex)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; *** Insert quickly most popular environments by easy short cuts (ctrl-shift-<...>)
;;NOT DOOM ;;;  (defun insert-latex-environment-align ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;  (LaTeX-environment-menu "align")
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;  (global-set-key (kbd "C-S-a") 'insert-latex-environment-align)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun insert-latex-environment-equation ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;  (LaTeX-environment-menu "equation")
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;  (global-set-key (kbd "C-S-e") 'insert-latex-environment-equation)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun insert-latex-environment-alignstar ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;  (LaTeX-environment-menu "align*")
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;  (global-set-key (kbd "C-c a") 'insert-latex-environment-alignstar)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun insert-latex-environment-alignstar ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;  (LaTeX-environment-menu "flalign*")
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;  (global-set-key (kbd "C-c f") 'insert-latex-environment-alignstar)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun insert-latex-environment-equationstar ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;  (LaTeX-environment-menu "equation*")
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;  (global-set-key (kbd "C-c e") 'insert-latex-environment-equationstar)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun insert-latex-environment-figure ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;     (setq full-image-file-name (read-file-name "Select image file: "))
;;NOT DOOM ;;;     (setq bare-image-file-name (file-name-nondirectory (file-name-sans-extension full-image-file-name)))
;;NOT DOOM ;;;  (setq image-file-name (file-name-nondirectory full-image-file-name))
;;NOT DOOM ;;;  (setq image-rel-file-name (file-relative-name full-image-file-name default-directory))
;;NOT DOOM ;;;  (eps-convert-file image-file-name);; convert to eps for preview
;;NOT DOOM ;;;  ;;(setq caption (read-string "Caption: "))
;;NOT DOOM ;;;  (setq begin (point)) ;; save beginning
;;NOT DOOM ;;;  (insert "\\" "begin{figure}[H]\n"
;;NOT DOOM ;;;   	"\\" "centering\n"
;;NOT DOOM ;;;  	"\\" "includegraphics[keepaspectratio,height=150pt]{" image-rel-file-name "}\n"
;;NOT DOOM ;;;  	"\\" "caption{ }\n"
;;NOT DOOM ;;;  	"\\" "label{fig:" bare-image-file-name "}\n"
;;NOT DOOM ;;;  	"\\" "end{figure}\n" )
;;NOT DOOM ;;;  (setq end (point)) ;; save end
;;NOT DOOM ;;;  (reftex-parse-all)  ;; parse reftex so that it can be referred to directly
;;NOT DOOM ;;;  ;(preview-region begin end)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;  (global-set-key (kbd "C-S-f") 'insert-latex-environment-figure)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun insert-latex-environment-table ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;  (LaTeX-environment-menu "table")
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;  (global-set-key (kbd "C-S-t") 'insert-latex-environment-table)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * misc
;;NOT DOOM ;;;  ;; quickly add relative path of some file
;;NOT DOOM ;;;  (defun find-file-insert-relative-path ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;   (setq file-name (read-file-name "Select file: "))
;;NOT DOOM ;;;  (setq rel-path (file-relative-name file-name))
;;NOT DOOM ;;;  (insert rel-path)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * convert latex to org (region -> headings to org-headers)
;;NOT DOOM ;;;  (defun convert-latex-to-org-region-to-clipboard ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    ;; function converts latex headers to org headers ( '\section{...}' --> '* ...' ; '\subsection{...}' --> '** ...' , etc.)
;;NOT DOOM ;;;    ;; * current region to string
;;NOT DOOM ;;;    (setq region_string (buffer-substring (mark) (point)))
;;NOT DOOM ;;;    ;; (setq region_string "\\section{hello}")
;;NOT DOOM ;;;    (let ()
;;NOT DOOM ;;;    ;; * search-replace headers
;;NOT DOOM ;;;    ;; ** level 1
;;NOT DOOM ;;;    ;; (message region_string) % elisp prints the "preceding backslash" so appears as double \\ but it actually isnt -> see:
;;NOT DOOM ;;;    ;; (insert region_string) # --> inserts "\section{hello}"
;;NOT DOOM ;;;    ;; var1 -> using replace-regexp-in-string
;;NOT DOOM ;;;    ;; *** replace leading "\section{"
;;NOT DOOM ;;;    ;; (setq region-string-converted (replace-regexp-in-string
;;NOT DOOM ;;;     ;; "[ \t\n]*\\\\section{" ;; think like this: this is actually just "\\" -> ONE escaped backslash
;;NOT DOOM ;;;     ;; "* " region_string))
;;NOT DOOM ;;;    ;; *** remove trailing }
;;NOT DOOM ;;;    ;; (setq region-string-converted (replace-regexp-in-string
;;NOT DOOM ;;;     ;; "}"
;;NOT DOOM ;;;     ;; "" region-string-converted))
;;NOT DOOM ;;;
;;NOT DOOM ;;;    ;; var2 -> using groups -> so get the parts in one \section{<heading>} = '\section{' + <heading> +'}'
;;NOT DOOM ;;;      ;; (replace-first-enclosing-pair-in-string region_string "\\\\section{" "}" "* " "")
;;NOT DOOM ;;;      (setq converted-string (replace-all-enclosing-pairs-in-string region_string "\\\\section{" "}" "* " ""))
;;NOT DOOM ;;;    ;; ** level 2
;;NOT DOOM ;;;      (setq converted-string (replace-all-enclosing-pairs-in-string converted-string "\\\\subsection{" "}" "** " ""))
;;NOT DOOM ;;;    ;; ** level 3
;;NOT DOOM ;;;      (setq converted-string (replace-all-enclosing-pairs-in-string converted-string "\\\\subsubsection{" "}" "*** " ""))
;;NOT DOOM ;;;    ;; * put converted string to clipboard, ready for pasting
;;NOT DOOM ;;;      (kill-new  converted-string)
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; test:
;;NOT DOOM ;;;  ;; \section{hello1}
;;NOT DOOM ;;;  ;; \section{hello2}
;;NOT DOOM ;;;  ;; ===>
;;NOT DOOM ;;;  ;; * hello1
;;NOT DOOM ;;;  ;; * hello2
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun replace-first-enclosing-pair-in-string (in-string old-begin old-end new-begin new-end)
;;NOT DOOM ;;;         (let (
;;NOT DOOM ;;;               ;; (in-string "hello, begin{exp1} my 1st expression end{exp1}, and here comes begin{exp1} my 2nd expression end{exp1}.")
;;NOT DOOM ;;;               ;; (old-begin "begin{exp1}")
;;NOT DOOM ;;;               ;; (old-end "end{exp1}")
;;NOT DOOM ;;;               ;; (new-begin "begin{exp2}")
;;NOT DOOM ;;;               ;; (new-end "end{exp2}")
;;NOT DOOM ;;;               )
;;NOT DOOM ;;;           ;; 1. with groups we can "dissect" the "<old-begin> <between> <old-end>" construct
;;NOT DOOM ;;;           ;;    regexp-groups:         begin           between           end
;;NOT DOOM ;;;           ;;                      _______^______        __^_         _____^_____
;;NOT DOOM ;;;           ;;                     /              \      /    \       /           \
;;NOT DOOM ;;;           (setq regexp (concat "\\(" old-begin "\\)" "\\(.*?\\)" "\\(" old-end "\\)"))
;;NOT DOOM ;;;  	 ;; side-note: "Note that ‘\\’ is needed in Lisp syntax to include a ‘\’ in the string, which is needed to deny the first star its special meaning in regexp syntax. See Regexp Backslash.)" https://www.gnu.org/software/emacs/manual/html_node/emacs/Options-for-Comments.html)
;;NOT DOOM ;;;
;;NOT DOOM ;;;           ;; debug..
;;NOT DOOM ;;;           ;; (setq old-begin "\\section{")
;;NOT DOOM ;;;           ;; (setq old-end "}")
;;NOT DOOM ;;;           ;; (setq in-string "\\section{hello}")
;;NOT DOOM ;;;           ;; (setq regexp (regexp-quote "\\section{hello}"))
;;NOT DOOM ;;;           ;; (string-match regexp in-string)
;;NOT DOOM ;;;           ;;; .. end debug
;;NOT DOOM ;;;           (when (string-match regexp in-string)
;;NOT DOOM ;;;               ;; (important note: the "?" makes the .* non-greedy! needed here
;;NOT DOOM ;;;             (setq the-whole-thing   (match-string 0 in-string))
;;NOT DOOM ;;;             (setq the-begin-thing   (match-string 1 in-string))
;;NOT DOOM ;;;             (setq the-between-thing (match-string 2 in-string))
;;NOT DOOM ;;;             (setq the-end-thing     (match-string 3 in-string))
;;NOT DOOM ;;;             ;; 2. now we can design "the-new-whole-thing"
;;NOT DOOM ;;;             (setq the-new-whole-thing (concat new-begin the-between-thing new-end))
;;NOT DOOM ;;;             ;; 3. and replace the old by the new whole thing in the total string
;;NOT DOOM ;;;             (setq result (replace-regexp-in-string (regexp-quote the-whole-thing) the-new-whole-thing in-string))
;;NOT DOOM ;;;           result)
;;NOT DOOM ;;;         ))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun replace-all-enclosing-pairs-in-string (in-string old-begin old-end new-begin new-end)
;;NOT DOOM ;;;         (let ((converted-string in-string))
;;NOT DOOM ;;;           ;; (setq in-string "hello, begin{exp1} my 1st expression end{exp1}, and here comes begin{exp1} my 2nd expression end{exp1}.")
;;NOT DOOM ;;;           ;; (setq converted-string in-string)
;;NOT DOOM ;;;           (setq continue t)
;;NOT DOOM ;;;           (while continue
;;NOT DOOM ;;;             (setq this-result (replace-first-enclosing-pair-in-string converted-string old-begin old-end new-begin new-end))
;;NOT DOOM ;;;             (if this-result
;;NOT DOOM ;;;                  (setq converted-string this-result)
;;NOT DOOM ;;;                  (setq continue nil)))
;;NOT DOOM ;;;           converted-string))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; test:
;;NOT DOOM ;;;  ;; (setq in-string "hello, begin{exp1} my 1st expression end{exp1}, and here comes begin{exp1} my 2nd expression end{exp1}.")
;;NOT DOOM ;;;  ;; (replace-first-enclosing-pair-in-string in-string "begin{exp1}" "end{exp1}" "begin{exp2}" "end{exp2}")
;;NOT DOOM ;;;  ;; (replace-all-enclosing-pairs-in-string in-string "begin{exp1}" "end{exp1}" "begin{exp2}" "end{exp2}")
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * c++
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** c++ -mode key bindings consistent (overwrite)
;;NOT DOOM ;;;  (define-key c++-mode-map "\M-k" 'windmove-up)
;;NOT DOOM ;;;  (define-key c++-mode-map "\M-h" 'windmove-left)
;;NOT DOOM ;;;  (define-key c++-mode-map "\M-l" 'windmove-right)
;;NOT DOOM ;;;  (define-key c++-mode-map "\M-j" 'windmove-down)
;;NOT DOOM ;;;
;;NOT DOOM ;;;

;;; * openfoam

(defun of-blockmesh-hex-points-to-print-faces ()
  (interactive)
  (setq grabbed (buffer-substring-no-properties (region-beginning) (region-end)))
  (setq grabbed-list (split-string grabbed))
  (setq indent-spaces "            ")
  (setq output (concat "\n"
                "            (" (nth 3 grabbed-list) " " (nth 2 grabbed-list) " " (nth 1 grabbed-list) " " (nth 0 grabbed-list) " ) // bottom \n"
                "            (" (nth 4 grabbed-list) " " (nth 5 grabbed-list) " " (nth 6 grabbed-list) " " (nth 7 grabbed-list) " ) // top \n"
                "            (" (nth 0 grabbed-list) " " (nth 4 grabbed-list) " " (nth 7 grabbed-list) " " (nth 3 grabbed-list) " ) // left \n"
                "            (" (nth 1 grabbed-list) " " (nth 2 grabbed-list) " " (nth 6 grabbed-list) " " (nth 5 grabbed-list) " ) // right \n"
                "            (" (nth 0 grabbed-list) " " (nth 1 grabbed-list) " " (nth 5 grabbed-list) " " (nth 4 grabbed-list) " ) // front \n"
                "            (" (nth 2 grabbed-list) " " (nth 3 grabbed-list) " " (nth 7 grabbed-list) " " (nth 6 grabbed-list) " ) // back \n"))
  (evil-exit-visual-state)
  (kill-new output))

;;NOT DOOM ;;;  (defun openfoam-dired-tutorials ()
;;NOT DOOM ;;;     (interactive)
;;NOT DOOM ;;;     (dired "/opt/OpenFOAM-6/tutorials")
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;  (defun openfoam-dired-applications ()
;;NOT DOOM ;;;     (interactive)
;;NOT DOOM ;;;     (dired "/opt/OpenFOAM-6/applications")
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;  (defun openfoam-dired-src ()
;;NOT DOOM ;;;     (interactive)
;;NOT DOOM ;;;     (dired "/opt/OpenFOAM-6/src")
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;Grosses Fazit:
;;NOT DOOM ;;;  ; konnte nicht shell-environment (bash_profile oder bashrc) in emacs-shell-prozess ausfuehren
;;NOT DOOM ;;;  ; hab s nicht hinbekommen login-option mitauszufuehren
;;NOT DOOM ;;;  ; --> Umweg ueber Emacs-interactive *shell*, eigene funktionen kopieren zeilen dort rein und fuehren sie aus
;;NOT DOOM ;;;  ; der ganze andere kram wird nicht mehr gebraucht
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ; purpose: execute shell-script in emacs line by line with <f3>
;;NOT DOOM ;;;  ; or execute region in script with <f4>
;;NOT DOOM ;;;  ; with emacs invoked shell "knowing" the openfoam environment
;;NOT DOOM ;;;  ; change openfoam version specific environment by changing value of variable ofvers
;;NOT DOOM ;;;  ;
;;NOT DOOM ;;;  ; prerequesite: the value of ofvers has to be implemented in ./bashrc as a function that sources the openfoam-version-environment
;;NOT DOOM ;;;  ; e.g. of240() { source /opt/openfoam240/etc/bashrc ; }
;;NOT DOOM ;;;  ; the alias-method does not work in executed scripts (effectively happening here) and is supposed to be outdated by shell-functions anyway, so better use function
;;NOT DOOM ;;;  ;
;;NOT DOOM ;;;  ; explanation of implementation:
;;NOT DOOM ;;;  ; the function sh-execute-region (defined in the sh-mode) has been modified, in order to not only execute region, but additionally source the openfoam-environment, see below.
;;NOT DOOM ;;;  ;
;;NOT DOOM ;;;  ; what i learned as background:
;;NOT DOOM ;;;  " sh-command-on-region          is implemented in sh-mode, uses shell-command-on-region,
;;NOT DOOM ;;;                                  with some extra stuff, did not understand this extra stuff
;;NOT DOOM ;;;                                  but probably is usefull, so i decided to use/modify this function
;;NOT DOOM ;;;
;;NOT DOOM ;;;    shell-command-on-region       uses effectively call-process-region
;;NOT DOOM ;;;                                  also has some additional stuff, i did not really understand,
;;NOT DOOM ;;;                                  but prob. usefull, defined in lisp/simple.el
;;NOT DOOM ;;;
;;NOT DOOM ;;;    call-process-region          uses call-process, before creates some temporary file, where all the
;;NOT DOOM ;;;                                  region is loaded and given as input to call-process
;;NOT DOOM ;;;
;;NOT DOOM ;;;    call-process                  is C-written elementary function, launching a shell-program, executing
;;NOT DOOM ;;;                                  an input file
;;NOT DOOM ;;;
;;NOT DOOM ;;;    FAZIT: i only had a chance to add sth to the region, because luckily shell-command-on-region can interpret alternatively the first argument start in (start end) as a string, so end will be ignored.
;;NOT DOOM ;;;  this way i could pack my string together (with concat) and pass it.
;;NOT DOOM ;;;  so no need to modify the shell-command-on-region or write my own temporary file (write my own call-process-region, ooh my gosh...!)"
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (setq ofvers "of240")
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun sh-execute-region-openfoam (start end &optional flag)
;;NOT DOOM ;;;    "Pass optional header and region to a subshell for noninteractive execution.
;;NOT DOOM ;;;  The working directory is that of the buffer, and only environment variables
;;NOT DOOM ;;;  are already set which is why you can mark a header within the script.
;;NOT DOOM ;;;
;;NOT DOOM ;;;  With a positive prefix ARG, instead of sending region, define header from
;;NOT DOOM ;;;  beginning of buffer to point.  With a negative prefix ARG, instead of sending
;;NOT DOOM ;;;  region, clear header."
;;NOT DOOM ;;;    (interactive "r\nP")
;;NOT DOOM ;;;    (if flag
;;NOT DOOM ;;;        (setq sh-header-marker (if (> (prefix-numeric-value flag) 0)
;;NOT DOOM ;;;  				 (point-marker)))
;;NOT DOOM ;;;      (if sh-header-marker
;;NOT DOOM ;;;  	(save-excursion
;;NOT DOOM ;;;  	  (let (buffer-undo-list)
;;NOT DOOM ;;;  	    (goto-char sh-header-marker)
;;NOT DOOM ;;;  	    (append-to-buffer (current-buffer) start end)
;;NOT DOOM ;;;  	    (shell-command-on-region (point-min)
;;NOT DOOM ;;;  				     (setq end (+ sh-header-marker
;;NOT DOOM ;;;  						  (- end start)))
;;NOT DOOM ;;;  				     sh-shell-file)
;;NOT DOOM ;;;  	    (delete-region sh-header-marker end)))
;;NOT DOOM ;;;       (setq regionstring (buffer-substring start end))
;;NOT DOOM ;;;       (setq start (concat ofvers "\n" regionstring) )
;;NOT DOOM ;;;       (shell-command-on-region start end "bash -l" ))) ;; If start is a string, then write-region writes or appends that string, rather than text from the buffer. end is ignored in this case.
;;NOT DOOM ;;;  )                                      ;;  bash with -l option --> login --> so it will read .bash_profile (--> includes bashrc) --> so the openfoam-environment sourcing functions are known
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; ** shell workflow openfoam
;;NOT DOOM ;;;  ;;; send to noninteractive shell (not "so" usefull, only for whole loops
;;NOT DOOM ;;;  (defun sh-execute-line-openfoam ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;  (move-beginning-of-line nil)
;;NOT DOOM ;;;  (setq beginofline (point))
;;NOT DOOM ;;;  (move-end-of-line nil)
;;NOT DOOM ;;;  (setq endofline (point))
;;NOT DOOM ;;;  (sh-execute-region-openfoam beginofline endofline)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun sh-send-region-to-shell ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;  (setq regionstring (buffer-substring (region-beginning) (region-end)))
;;NOT DOOM ;;;  (setq sendstring (concat regionstring "\n"))
;;NOT DOOM ;;;  ;(message sendstring)
;;NOT DOOM ;;;  (setq start sendstring)
;;NOT DOOM ;;;  (append-to-buffer "*shell*" start end)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; modified function from append-to-buffer
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun send-string-to-shell-buffer-and-execute (sendstring)
;;NOT DOOM ;;;    "execute region line by line in interactive shell (buffer *shell*)."
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;      ; get region into string
;;NOT DOOM ;;;      (save-excursion
;;NOT DOOM ;;;        (set-buffer (get-buffer-create "*shell*"))
;;NOT DOOM ;;;       (end-of-buffer)
;;NOT DOOM ;;;       (insert sendstring)
;;NOT DOOM ;;;       (comint-send-input) ;; execute
;;NOT DOOM ;;;       (end-of-buffer)
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun send-scriptname-to-shell-buffer-and-execute ()
;;NOT DOOM ;;;    "execute region line by line in interactive shell (buffer *shell*)."
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (save-buffer)
;;NOT DOOM ;;;      ; get script name (has to be done before save-excursion, since he then quits buffer)
;;NOT DOOM ;;;      (setq scriptname (file-name-nondirectory (file-name-sans-extension (buffer-file-name))))
;;NOT DOOM ;;;      (save-excursion
;;NOT DOOM ;;;        (set-buffer (get-buffer-create "*shell*"))
;;NOT DOOM ;;;       (end-of-buffer)
;;NOT DOOM ;;;       (insert (concat "./" scriptname))
;;NOT DOOM ;;;       (comint-send-input) ;; execute
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun send-current-line-to-shell-buffer-and-execute ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;  (move-beginning-of-line nil)
;;NOT DOOM ;;;  (setq beginofline (point))
;;NOT DOOM ;;;  (move-end-of-line nil)
;;NOT DOOM ;;;  (setq endofline (point))
;;NOT DOOM ;;;  (setq currentlinestring (buffer-substring beginofline endofline))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (send-string-to-shell-buffer-and-execute currentlinestring)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun send-current-region-line-by-line-to-shell-buffer-and-execute ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;     (save-excursion
;;NOT DOOM ;;;       ; get line numbers of region beginning/end
;;NOT DOOM ;;;       (setq beginning_line_number (line-number-at-pos (region-beginning)))
;;NOT DOOM ;;;       (setq ending_line_number (line-number-at-pos (region-end)))
;;NOT DOOM ;;;
;;NOT DOOM ;;;      (setq current_line_number beginning_line_number)
;;NOT DOOM ;;;      (goto-line beginning_line_number)
;;NOT DOOM ;;;      ;(message (format "%i" current_line_number) )
;;NOT DOOM ;;;        (while (< current_line_number ending_line_number)
;;NOT DOOM ;;;            (setq current_line_number (line-number-at-pos (point)))
;;NOT DOOM ;;;            (message (format "%i" current_line_number) )
;;NOT DOOM ;;;            (forward-line)
;;NOT DOOM ;;;            (send-current-line-to-shell-buffer-and-execute)
;;NOT DOOM ;;;        )
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun send-current-line-or-region-line-by-line-to-shell-buffer-and-execute ()
;;NOT DOOM ;;;  (interactive)
;;NOT DOOM ;;;     (if (use-region-p)
;;NOT DOOM ;;;       (send-current-region-line-by-line-to-shell-buffer-and-execute)
;;NOT DOOM ;;;       (send-current-line-to-shell-buffer-and-execute)
;;NOT DOOM ;;;     )
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun openfoam-shell-keys ()
;;NOT DOOM ;;;    (local-set-key (kbd "<f4>") 'send-current-line-or-region-line-by-line-to-shell-buffer-and-execute)
;;NOT DOOM ;;;    (local-set-key (kbd "<f5>") 'send-scriptname-to-shell-buffer-and-execute)
;;NOT DOOM ;;;  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (add-hook 'sh-mode-hook 'openfoam-shell-keys)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; original function (  http://repo.or.cz/w/emacs.git/blob/HEAD:/lisp/progmodes/sh-script.el )
;;NOT DOOM ;;;  ;; (defun sh-execute-region (start end &optional flag)
;;NOT DOOM ;;;  ;;   "Pass optional header and region to  subshell for noninteractive execution.
;;NOT DOOM ;;;  ;; The working directory is that of the buffer, and only environment variables
;;NOT DOOM ;;;  ;; are already set which is why you can mark a header within the script.
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; With a positive prefix ARG, instead of sending region, define header from
;;NOT DOOM ;;;  ;; beginning of buffer to point.  With a negative prefix ARG, instead of sending
;;NOT DOOM ;;;  ;; region, clear header."
;;NOT DOOM ;;;  ;;   (interactive "r\nP")
;;NOT DOOM ;;;  ;;   (if flag
;;NOT DOOM ;;;  ;;       (setq sh-header-marker (if (> (prefix-numeric-value flag) 0)
;;NOT DOOM ;;;  ;; 				 (point-marker)))
;;NOT DOOM ;;;  ;;     (if sh-header-marker
;;NOT DOOM ;;;  ;; 	(save-excursion
;;NOT DOOM ;;;  ;; 	  (let (buffer-undo-list)
;;NOT DOOM ;;;  ;; 	    (goto-char sh-header-marker)
;;NOT DOOM ;;;  ;; 	    (append-to-buffer (current-buffer) start end)
;;NOT DOOM ;;;  ;; 	    (shell-command-on-region (point-min)
;;NOT DOOM ;;;  ;; 				     (setq end (+ sh-header-marker
;;NOT DOOM ;;;  ;; 						  (- end start)))
;;NOT DOOM ;;;  ;; 				     sh-shell-file)
;;NOT DOOM ;;;  ;; 	    (delete-region sh-header-marker end)))
;;NOT DOOM ;;;  ;;       (shell-command-on-region start end (concat sh-shell-file " -")))))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** open-foam-workflow tipps
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * zoom frame on smaller monitor
;;NOT DOOM ;;;  ;;    status: no working solution, but no priority
;;NOT DOOM ;;;  ;; (require 'zoom-frm)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; *** move buffers - key bindings
;;NOT DOOM ;;; (use-package windmove
;;NOT DOOM ;;;   :ensure t)
;;
;;
;; (require 'framemove)
(load! "framemove")
(setq framemove-hook-into-windmove t)


;; (global-set-key (kbd "<C-up>")     'windmove-up)
;; (global-set-key (kbd "<C-down>")   'windmove-down)
;; (global-set-key (kbd "<C-left>")   'windmove-left)
;; (global-set-key (kbd "<C-right>")  'windmove-right)
;; * TOP priority window movement/handling with M/Alt

;; * "M is my leader" for prime-window/buffer management
(map! :map general-override-mode-map
        "M-k"  #'windmove-up
        "M-j"  #'windmove-down
        "M-h"  #'windmove-left
        "M-l"  #'windmove-right
        "M-0"  #'delete-window
        "M-1"  #'delete-other-windows
        "M-2"  #'split-window-below
        "M-3"  #'split-window-right
        "M-d"  #'kill-this-buffer-no-prompt ;; -> used in doom by evil-multiedit-match-symbol-and-next -> unbound below
        "M-y" #'previous-buffer
        "M-o" #'next-buffer
        "M-u" #'get-this-buffer-to-move
        "M-i" #'switch-to-buffer-to-move
        "M-b" #'consult-buffer)

;; unbind M-d -> so it works from general-override-mode-map (above)
(map! :map evil-normal-state-map
      "M-d"  nil)

(defun kill-this-buffer-no-prompt () (interactive) (kill-buffer nil))

(defun get-this-buffer-to-move ()
  (interactive)
  ;;(setq buffer-to-move-to-another-window (current-buffer))
  (kill-new (buffer-name))
  ;; (previous-buffer)
  (message (concat "buffer set to move: " (buffer-name))))

(defun switch-to-buffer-to-move ()
  (interactive)
  (setq buffer-name-to-move-to (current-kill 0))
  (message buffer-name-to-move-to)
  (switch-to-buffer buffer-name-to-move-to))

;; also affect org-mode -> this worked
;; this achieves C-j/h/k/l pushing up/down/left/right headings WITH subtree
;; (it s what I mostly do, so do these without shift-key)
(after! evil-org
(map! :map evil-org-mode-map
       :nvieomr "C-k" #'org-metaup
       :nvieomr "C-j" #'org-metadown
       :nvieomr "C-h" #'org-shiftmetaleft
       :nvieomr "C-l" #'org-shiftmetaright)
(map! :map evil-org-mode-map
       :nvieomr "C-S-k" #'org-shiftmetaup
       :nvieomr "C-S-j" #'org-shiftmetadown
       :nvieomr "C-S-h" #'org-metaleft
       :nvieomr "C-S-l" #'org-metaright)
       ;; todo :n "C-RET" #'org-metaright)
;; (map! :map evil-org-mode-map
;;        :nvieomr "C-k" nil
;;        :nvieomr "C-j" nil
;;        :nvieomr "C-h" nil
;;        :nvieomr "C-l" nil
;;        :nvieomr "C-S-k" nil
;;        :nvieomr "C-S-j" nil
;;        :nvieomr "C-S-h" nil
;;        :nvieomr "C-S-l" nil)
(map! :map evil-org-mode-map
       :nvieomr "M-k" nil
       :nvieomr "M-j" nil
       :nvieomr "M-h" nil
       :nvieomr "M-l" nil
       :nvieomr "M-K" nil ;; free for windmove general map
       :nvieomr "M-J" nil ;; free for windmove general map
       :nvieomr "M-H" nil ;; free for windmove general map
       :nvieomr "M-L" nil ;; free for windmove general map
       :nvieomr "M-S-k" nil
       :nvieomr "M-S-j" nil
       :nvieomr "M-S-h" nil
       :nvieomr "M-S-l" nil))

(after! term
(map! :map term-raw-map
        "M-k"  #'windmove-up
        "M-j"  #'windmove-down
        "M-h"  #'windmove-left
        "M-l"  #'windmove-right))


;;NOT DOOM ;;;  ;; tweek for org-mode, other
;; (define-key org-mode-map "\M-k" 'windmove-up)
;; (define-key org-mode-map "\M-h" 'windmove-left)
;; (define-key org-mode-map "\M-l" 'windmove-right)
;; (define-key org-mode-map "\M-j" 'windmove-down)



;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; tweak in term-mode, so these also work in term-windows:
;;NOT DOOM ;;;   (define-key term-raw-map "\M-k" 'windmove-up)
;;NOT DOOM ;;;   (define-key term-raw-map "\M-h" 'windmove-left)
;;NOT DOOM ;;;   (define-key term-raw-map "\M-l" 'windmove-right)
;;NOT DOOM ;;;   (define-key term-raw-map "\M-j" 'windmove-down)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; evil-like other bindings, that I like
;;NOT DOOM ;;;  ;; hmm.. maybe not yet, might by usefull for other stuff (-> outcommented)
;;NOT DOOM ;;;  ;; (define-key org-mode-map "L" 'org-shiftright)
;;NOT DOOM ;;;  ;; (define-key org-mode-map "H" 'org-shiftleft)
;;NOT DOOM ;;;  ;; (define-key org-mode-map "L" 'org-shiftdown)
;;NOT DOOM ;;;  ;; (define-key org-mode-map "K" 'org-shiftup)
;;NOT DOOM ;;;  ;;    - syntax for key with slash "\M-.." --> see explanation in lisp docu:
;;NOT DOOM ;;;  ;;         https://www.gnu.org/software/emacs/manual/html_node/elisp/Basic-Char-Syntax.html#Basic-Char-Syntax
;;NOT DOOM ;;;  ;;    - the most important thing in term-char-mode is actually the term-raw-map
;;NOT DOOM ;;;  ;;      --> here basically in a for loop for every key, e.g. a (97) is defined that, just this string shall be sent to the shell-process
;;NOT DOOM ;;;  ;;    - this means that exceptions from this are very easy, just add/alter key in term-raw-map
;;NOT DOOM ;;;  ;;    - the exception for the escape key is implemented in just this way actually:
;;NOT DOOM ;;;  ;;      term.el:912   (define-key term-raw-map term-escape-char term-raw-escape-map)
;;NOT DOOM ;;;  ;;      just leads to a second map where a new command can be executed (e.g. M-x)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * mode-line appearance
;;NOT DOOM ;;;  ;; set mode line to show full path of current file
;;NOT DOOM ;;;  ;; (setq-default mode-line-format
;;NOT DOOM ;;;  ;;    (list '((buffer-file-name " %f"
;;NOT DOOM ;;;  ;;               (dired-directory
;;NOT DOOM ;;;  ;;                dired-directory
;;NOT DOOM ;;;  ;;                 (revert-buffer-function " %b"
;;NOT DOOM ;;;  ;;                ("%b - Dir:  " default-directory)))))))
;;NOT DOOM ;;;  ;;; * ) set mode line appearance
;;NOT DOOM ;;;  ;;;    (has to come AFTER  color themes, don t ask why)
;;NOT DOOM ;;;  ;; don t ask why exactly, but the following (in order (!)) resulted nice in combi with zenburn
;;NOT DOOM ;;;  ;; i.e.  .) modest visual difference of current buffer's mode line
;;NOT DOOM ;;;  ;;       .) decent layout
;;NOT DOOM ;;;  ;;       .) harmonic colors with zenburn
;;NOT DOOM ;;;  ;; (require 'powerline)
;;NOT DOOM ;;;  ;; (require 'smart-mode-line)
;;NOT DOOM ;;;  ;; (sml/setup)
;;NOT DOOM ;;;  ;; (setq sml/no-confirm-load-theme t) ;; avoid being asked "wanna compile theme in elisp" (or so..) everytime
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * buffer/window navigation management
;;NOT DOOM ;;;  ;; ** better short cuts for previous / next buffer
;;NOT DOOM ;;;  (global-set-key (kbd "M-'") 'previous-buffer)
;;NOT DOOM ;;;  (global-set-key (kbd "M-\\") 'next-buffer)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;; * pdf-view
;;NOT DOOM ;;; (require 'pdf-view)
;;NOT DOOM ;;;
;;NOT DOOM ;;;   (setq pdf-info-epdfinfo-program "/usr/local/bin/epdfinfo")
;;NOT DOOM ;;;
;;NOT DOOM ;;;   (setq pdf-view-midnight-colors `(,(face-attribute 'default :foreground) .
;;NOT DOOM ;;;                                    ,(face-attribute 'default :background)))
;;NOT DOOM ;;;
;;NOT DOOM ;;;   (add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode))
;;NOT DOOM ;;;
;;NOT DOOM ;;;   (add-hook 'pdf-view-mode-hook (lambda ()
;;NOT DOOM ;;;                                   (pdf-view-midnight-minor-mode)))
;;NOT DOOM ;;;
;;NOT DOOM ;;;   (provide 'init-pdfview)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * quickly print variable to scratch buffer
;;NOT DOOM ;;;  (defun print-var-to-scratch-buffer (var)
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (with-current-buffer "*scratch*"
;;NOT DOOM ;;;      (end-of-buffer)
;;NOT DOOM ;;;      (insert (concat "\n\n" (prin1-to-string var)))
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (defun dummy-fun (arg)
;;NOT DOOM ;;;  ;;   (interactive)
;;NOT DOOM ;;;  ;;   ;; ;; (message org-structure-template-alist)
;;NOT DOOM ;;;  ;;   ;; (setq name_str "org-structure-template-alist")
;;NOT DOOM ;;;  ;;   ;; (setq x (intern-soft name_str))
;;NOT DOOM ;;;  ;;   ;; (message (symbol-value x))
;;NOT DOOM ;;;  ;;   (message arg)
;;NOT DOOM ;;;  ;;   )
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (debug-on-entry 'print-value-of-var-under-selection-to-scratch-buffer)
;;NOT DOOM ;;;  (cancel-debug-on-entry 'print-value-of-var-under-selection-to-scratch-buffer)
;;NOT DOOM ;;;  (defun print-value-of-var-under-selection-to-scratch-buffer ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    ;; read the selection AS VARIABLE into var
;;NOT DOOM ;;;    ;; (setq var (make-symbol "org-structure-template-alist"))
;;NOT DOOM ;;;    (setq var_string (buffer-substring (region-beginning) (region-end)))
;;NOT DOOM ;;;    (setq var (intern-soft var_string))
;;NOT DOOM ;;;    ;; (print-var-to-scratch-buffer var)
;;NOT DOOM ;;;    (setq symbolvalue (symbol-value var))
;;NOT DOOM ;;;    (if (setq var (intern-soft var_string))
;;NOT DOOM ;;;        (with-current-buffer "*scratch*"
;;NOT DOOM ;;;          (end-of-buffer)
;;NOT DOOM ;;;          ;; function "symbol-value" was necessary, otherwise not working (??? but ok)
;;NOT DOOM ;;;          ;; (insert var) ;;--> not working even though it works when using the variable (symbol), e.g. x, directly like this (insert x))
;;NOT DOOM ;;;          (insert (concat "\n\n value of variable '" var_string "':\n"))
;;NOT DOOM ;;;          (insert (prin1-to-string symbolvalue))
;;NOT DOOM ;;;         ;; (eval var_string)
;;NOT DOOM ;;;          ;; https://stackoverflow.com/questions/4651274/convert-symbol-to-a-string-in-elisp
;;NOT DOOM ;;;          )
;;NOT DOOM ;;;      ;; else
;;NOT DOOM ;;;      (message (concat "no such symbol exists with name: " var_string))
;;NOT DOOM ;;;      )
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * git-save
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; (defun git-save ()
;;NOT DOOM ;;;  ;;   (interactive)
;;NOT DOOM ;;;  ;;   ;; * update
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;   )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * async-await (needed to be able to wait for "external" shell commands)
;;NOT DOOM ;;;  (use-package async-await
;;NOT DOOM ;;;    :ensure t
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;; * async process behaviour
;; ** turn off 'pop-up' of the *Async Shell Command* buffer
(message "async buffer hide set...")
;; (add-to-list 'display-buffer-alist
;;   (cons "\\*Async Shell Command\\*.*" (cons #'display-buffer-no-window nil)))

;; (message (string display-buffer-alist))

;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * stopwatch
;;NOT DOOM ;;;  ;; (load (concat my_load_path "other_packages/stopwatch/stopwatch.el"))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * ssh clipboard
;;NOT DOOM ;;;  ;; ** user settings
;;NOT DOOM ;;;  (defvar ssh-clipboard-file "~/ssh_clipboard.txt")
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun ssh-clipboard-copy-string (str1)
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    ;; ** copy current region -> into string
;;NOT DOOM ;;;    (with-temp-file ssh-clipboard-file
;;NOT DOOM ;;;      ;; (insert-file-contents file)
;;NOT DOOM ;;;      ;; (not appending --> so outcommented)
;;NOT DOOM ;;;      (insert str1))
;;NOT DOOM ;;;      ;; "region copied to " ssh-clipboard-file "." ))
;;NOT DOOM ;;;    (cond ((myhost-is-server)
;;NOT DOOM ;;;           ;; (message "ssh-clipboard-copy: i m on myhost=mathe or hlrn")
;;NOT DOOM ;;;           )
;;NOT DOOM ;;;          ((myhost-is-local)
;;NOT DOOM ;;;           ;; (message "ssh-clipboard-copy: i m on myhost=local")
;;NOT DOOM ;;;           ;; * send it so ssh server
;;NOT DOOM ;;;           (setq path1 ssh-clipboard-file)
;;NOT DOOM ;;;           (message "sending (via rsync) ssh_clipboard.txt to all servers.")
;;NOT DOOM ;;;           (dolist (this-server-name my-server-machine-names)
;;NOT DOOM ;;;             (message (concat "sending ssh_clipboard.txt to server '" this-server-name "'..."))
;;NOT DOOM ;;;
;;NOT DOOM ;;;             ;; * i tried various options to execute command (and let server resolve '~' aka home-path)
;;NOT DOOM ;;;             ;; ** shell-command (problem: no asynchronous)
;;NOT DOOM ;;;             ;; (setq path2 (concat this-server-name ":'~'/")) ;; without ' quotes -> for start-process (circumvents kind of the shell string processing, so it s what the command will get and it "does not want quotes".
;;NOT DOOM ;;;             ;; (shell-command (concat "echo command will show like this in shell: " command-string))
;;NOT DOOM ;;;             ;; (setq command-string (concat "rsync --progress -va -I " path1 " " path2 ))
;;NOT DOOM ;;;             ;; (message (concat "executing command: '" command-string "' ..."))
;;NOT DOOM ;;;             ;; (shell-command command-string)
;;NOT DOOM ;;;             ;; ** async-shell-command (problem: complains about output-buffer, annoying)
;;NOT DOOM ;;;             ;; (async-shell-command command-string)
;;NOT DOOM ;;;             ;; ** start-process (problem: complains about output-buffer, annoying)
;;NOT DOOM ;;;             ;; (async-shell-command command-string nil nil)
;;NOT DOOM ;;;             ;; (setq output-buffer "foo")
;;NOT DOOM ;;;             ;; ;;                                                     "arg-components start here", no need for spaces
;;NOT DOOM ;;;             ;; ;;                                                        |
;;NOT DOOM ;;;             ;; ;;                                                        V
;;NOT DOOM ;;;             ;; (setq thisproc (start-process "process_name_dummy" output-buffer "rsync" "--progress" "-va" "-I" path1 path2))
;;NOT DOOM ;;;             ;;
;;NOT DOOM ;;;             ;; ** start-process-shell-command (this worked!)
;;NOT DOOM ;;;             (setq path2 (concat this-server-name ":'~'/"))
;;NOT DOOM ;;;             (setq command-string (concat "rsync --progress -va -I " path1 " " path2 ))
;;NOT DOOM ;;;             ;; (setq output-buffer nil)
;;NOT DOOM ;;;             (setq output-buffer "*ssh-clipboard-shell-ouptput*")
;;NOT DOOM ;;;             (start-process-shell-command "process_name_dummy" output-buffer command-string)
;;NOT DOOM ;;;             (message (concat "rsync'ed to ssh server (" this-server-name ")" ))))
;;NOT DOOM ;;;          (t
;;NOT DOOM ;;;           (message "myhost not set. set first: M-x set-myhost , or in shell with 'export MYHOST=mathe/hlrn/local/etc.'"))))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun ssh-clipboard-copy ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    ;; ** copy current region -> into string
;;NOT DOOM ;;;    (setq current-region-string (buffer-substring (mark) (point)))
;;NOT DOOM ;;;    (ssh-clipboard-copy-string current-region-string)
;;NOT DOOM ;;;    (message (concat "region copied to " ssh-clipboard-file "." )))
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun ssh-clipboard-paste ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    ;; if on local machine -> rsync ssh-clipboard from server first
;;NOT DOOM ;;;    (cond
;;NOT DOOM ;;;          ((myhost-is-server)
;;NOT DOOM ;;;           ;; (message "ssh-clipboard-copy: i m on myhost=mathe or hlrn")
;;NOT DOOM ;;;           )
;;NOT DOOM ;;;
;;NOT DOOM ;;;          ((myhost-is-local)
;;NOT DOOM ;;;           ;; (message "ssh-clipboard-copy: i m on myhost=local")
;;NOT DOOM ;;;           ;; * send it so ssh server
;;NOT DOOM ;;;           (setq path1 (concat "'" my-current-server-name ":~/ssh_clipboard.txt" "'")) ;; quote to make ~ convert to (correct) home only on server
;;NOT DOOM ;;;           (setq path2 "~/")
;;NOT DOOM ;;;           (setq command-string (concat "rsync --progress -va -I " path1 " " path2 ))
;;NOT DOOM ;;;           (shell-command command-string)
;;NOT DOOM ;;;           (message (concat "rsync'ed from ssh server (" my-current-server-name ")" )))
;;NOT DOOM ;;;          (t
;;NOT DOOM ;;;           (message "myhost not set. set first: M-x set-myhost , or in shell with 'export MYHOST=mathe/hlrn/laptop/phone/etc.'")))
;;NOT DOOM ;;;
;;NOT DOOM ;;;    ;; * read content into string
;;NOT DOOM ;;;    (with-temp-buffer
;;NOT DOOM ;;;      (insert-file-contents ssh-clipboard-file)
;;NOT DOOM ;;;      (setq ssh-clipboard-content (buffer-string)))
;;NOT DOOM ;;;    ;; * paste content
;;NOT DOOM ;;;    (insert ssh-clipboard-content))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun ssh-clipboard-term-paste ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (ssh-clipboard-update-ssh-clipboard-file)
;;NOT DOOM ;;;    (setq ssh-clipboard-string (ssh-clipboard-file-content-to-string))
;;NOT DOOM ;;;    (term-send-raw-string ssh-clipboard-string))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun ssh-clipboard-file-content-to-string ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    ;; * read content into string
;;NOT DOOM ;;;    (with-temp-buffer
;;NOT DOOM ;;;      (insert-file-contents ssh-clipboard-file)
;;NOT DOOM ;;;      (setq ssh-clipboard-content (buffer-string))))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (defun ssh-clipboard-update-ssh-clipboard-file ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    ;; if on local machine -> rsync ssh-clipboard from server first
;;NOT DOOM ;;;    (cond
;;NOT DOOM ;;;          ((myhost-is-server)
;;NOT DOOM ;;;           ;; (message "ssh-clipboard-copy: i m on myhost=mathe or hlrn")
;;NOT DOOM ;;;           )
;;NOT DOOM ;;;
;;NOT DOOM ;;;          ((myhost-is-local)
;;NOT DOOM ;;;           ;; (message "ssh-clipboard-copy: i m on myhost=local")
;;NOT DOOM ;;;           ;; * send it so ssh server
;;NOT DOOM ;;;           (setq path1 (concat "'" my-current-server-name ":~/ssh_clipboard.txt" "'")) ;; quote to make ~ convert to (correct) home only on server
;;NOT DOOM ;;;           (setq path2 "~/")
;;NOT DOOM ;;;           (setq command-string (concat "rsync --progress -va -I " path1 " " path2 ))
;;NOT DOOM ;;;           (shell-command command-string)
;;NOT DOOM ;;;           (message (concat "rsync'ed from ssh server (" my-current-server-name ")" )))
;;NOT DOOM ;;;          (t
;;NOT DOOM ;;;           (message "myhost not set. set first: M-x set-myhost , or in shell with 'export MYHOST=mathe/hlrn/laptop/phone/etc.'"))))
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** ssh-clipboard key bindings
;;NOT DOOM ;;;  ;;T (evil-leader/set-key "Y" 'ssh-clipboard-copy) ;; analogouns to y = vim yank
;;NOT DOOM ;;;  ;;T (evil-leader/set-key "P" 'ssh-clipboard-paste) ;; analogous to p = vim paste
;;NOT DOOM ;;;  ;; (global-set-key (kbd "<f1>") 'copy-current-path)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** ssh-clipboard copy path
;;NOT DOOM ;;;  (defun ssh-clipboard-copy-path ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (setq currentpath (copy-current-path))
;;NOT DOOM ;;;    (ssh-clipboard-copy-string currentpath)
;;NOT DOOM ;;;    (message (concat "copied path to ssh-clipboard: "  currentpath)))
;;NOT DOOM ;;;
(defun get-fullfilename ()
  (interactive)
    (cond
        ((equal major-mode 'dired-mode)
            ;; "workaround": use dired-copy-file-as-kill -> (normal) clipboard aka kill-ring -> get it from kill ring -> put it to string
            ;; (dired-copy-file-as-kill)
            ;; (setq filename (current-kill 0))
            ;; (setq currentpath (concat currentpath "/" filename))
            ;; (setq fullfilename (dired-file-name-at-point))
            (setq fullfilename (dired-get-filename))
            (setq currentpath fullfilename))
        (t
         (setq fullfilename (buffer-file-name)))))

;;NOT DOOM ;;;  (defun ssh-clipboard-copy-fullfilename ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (setq fullfilename (get-fullfilename))
;;NOT DOOM ;;;    (ssh-clipboard-copy-string fullfilename)
;;NOT DOOM ;;;    (message (concat "copied fullfilename to ssh-clipboard: "  fullfilename)))
;;NOT DOOM ;;;
(defun copy-fullfilename ()
  (interactive)
  (setq fullfilename (get-fullfilename))
  (kill-new fullfilename)
  (message (concat "copied fullfilename to clipboard: "  fullfilename)))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;  (evil-define-key 'normal term-raw-map (kbd "C-S-p") 'ssh-clipboard-term-paste)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** short cuts-concept for copy/paste  region/path/fullfilename
;;NOT DOOM ;;;  ;; *** normal clipboard
;;NOT DOOM ;;;  ;; a) copy region       ->
;;NOT DOOM ;;;  ;;                         files        ... "y" (copy)
;;NOT DOOM ;;;  ;; b) copy path         ->
;;NOT DOOM ;;;  ;;                         files        ... "leader + y" (copy)
;;NOT DOOM ;;;  ;; c) copy fullfilename ->
;;NOT DOOM ;;;  ;;                         dired/others ... "leader + u"
;;NOT DOOM ;;;  ;; d) paste             ->
;;NOT DOOM ;;;  ;;                         files        ... "p"
;;NOT DOOM ;;;  ;;                         term         ... "ctrl + p"
;;NOT DOOM ;;;  ;; e) change-path in clipboard
;;NOT DOOM ;;;  ;;                         files        ... "leader + p"
;;NOT DOOM ;;;  ;;                         term         ... "ctrl   + p"
;;NOT DOOM ;;;  ;;
;;NOT DOOM ;;;  ;; *** ssh-clipboard
;;NOT DOOM ;;;  ;; a) ssh-copy region   ->
;;NOT DOOM ;;;  ;;                         files        ... "leader + Y"
;;NOT DOOM ;;;  ;;                         (term        ... "CTRL + Y") <-- no use case
;;NOT DOOM ;;;  ;; b) ssh-copy path     ->
;;NOT DOOM ;;;  ;;                         (dired/others ... "leader + ?" ) <-- no use case
;;NOT DOOM ;;;  ;;                         (term         ... "CTRL + ?") <-- no use case
;;NOT DOOM ;;;  ;; c) ssh-copy filefullname  ->
;;NOT DOOM ;;;  ;;                         dired/others ... "leader + U"
;;NOT DOOM ;;;  ;;                         (term         ...  "CTRL + U") <-- no use case
;;NOT DOOM ;;;  ;; d) ssh-paste           ->
;;NOT DOOM ;;;  ;;                         files        ... "leader + P"
;;NOT DOOM ;;;  ;;                         term         ...  CTRL + P"
;;NOT DOOM ;;;  ;; e) (change-path in clipboard) <-- no use case
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** short cuts-implementation for copy/paste  region/path/fullfilename
;;NOT DOOM ;;;  ;; *** normal clipboard
;;NOT DOOM ;;;  ;; a) copy region       ->
;;NOT DOOM ;;;  ;;                         files        ... "y" (copy)
;;NOT DOOM ;;;  ;; IMPLEMENTED
;;NOT DOOM ;;;  ;;
;;NOT DOOM ;;;  ;; b) copy path         ->
;;NOT DOOM ;;;  ;;                         files        ... "leader + y" (copy)
;;NOT DOOM ;;;  ;;                         term         ... "ctrl   + alt + p"
;;NOT DOOM ;;;  ;; IMPLEMENTED
;;NOT DOOM ;;;   (evil-define-key 'normal term-raw-map (kbd "C-M-y") 'copy-current-path) ;; (kbd "C-P") is NOT working (interpreted same as "C-p" apparently)
;;NOT DOOM ;;;   (evil-define-key 'emacs term-raw-map (kbd "C-M-y") 'copy-current-path) ;; (kbd "C-P") is NOT working (interpreted same as "C-p" apparently)
;;NOT DOOM ;;;   (evil-define-key 'insert term-raw-map (kbd "C-M-y") 'copy-current-path) ;; (kbd "C-P") is NOT working (interpreted same as "C-p" apparently)
;;NOT DOOM ;;;  ;;
;;NOT DOOM ;;;  ;; c) copy fullfilename ->
;;NOT DOOM ;;;  ;;                         dired/others ... "leader + u"
;;NOT DOOM ;;;     ;;T (evil-leader/set-key "u" 'copy-fullfilename)
;;NOT DOOM ;;;  ;; d) paste             ->
;;NOT DOOM ;;;  ;;                         files        ... "p"
;;NOT DOOM ;;;  ;;                         term         ... "ctrl + p"
;;NOT DOOM ;;;  ;; IMPLEMENTED
;;NOT DOOM ;;;  ;;
;;NOT DOOM ;;;  ;; e) change-path in clipboard
;;NOT DOOM ;;;  ;;                         files        ... "leader + p"
;;NOT DOOM ;;;  ;;                         term         ... "ctrl   + alt + p"
;;NOT DOOM ;;;   (evil-define-key 'normal term-raw-map (kbd "C-M-p") 'change-dir-from-clipboard) ;; (kbd "C-P") is NOT working (interpreted same as "C-p" apparently)
;;NOT DOOM ;;;   (evil-define-key 'emacs term-raw-map (kbd "C-M-p") 'change-dir-from-clipboard) ;; (kbd "C-P") is NOT working (interpreted same as "C-p" apparently)
;;NOT DOOM ;;;   (evil-define-key 'insert term-raw-map (kbd "C-M-p") 'change-dir-from-clipboard) ;; (kbd "C-P") is NOT working (interpreted same as "C-p" apparently)
;;NOT DOOM ;;;  ;;
;;NOT DOOM ;;;  ;; *** ssh-clipboard
;;NOT DOOM ;;;  ;; a) ssh-copy region   ->
;;NOT DOOM ;;;  ;;                         files        ... "leader + Y"
;;NOT DOOM ;;;  ;;                         (term        ... "CTRL + Y") <-- no use case
;;NOT DOOM ;;;  ;; IMPLEMENTED
;;NOT DOOM ;;;  ;;
;;NOT DOOM ;;;  ;; b) (ssh-copy path)  <-- no use case
;;NOT DOOM ;;;  ;;                         (also shortcut difficult to find: leader+Y/ctrl+Y/leader+y taken)
;;NOT DOOM ;;;  ;;                         (dired/others ... "leader + ?" ) <-- no use case
;;NOT DOOM ;;;  ;;                         (term         ... "CTRL + ?") <-- no use case
;;NOT DOOM ;;;  ;;
;;NOT DOOM ;;;  ;; c) ssh-copy filefullname  ->
;;NOT DOOM ;;;  ;;                         dired/others ... "leader + U"
;;NOT DOOM ;;;  ;;                         (term         ...  "CTRL + U") <-- no use case
;;NOT DOOM ;;;     ;;T (evil-leader/set-key "U" 'ssh-clipboard-copy-fullfilename)
;;NOT DOOM ;;;  ;;
;;NOT DOOM ;;;  ;; d) ssh-paste           ->
;;NOT DOOM ;;;  ;;                         files        ... "leader + P"
;;NOT DOOM ;;;  ;;                         term         ...  CTRL + P"
;;NOT DOOM ;;;  ;; IMPLEMENTED
;;NOT DOOM ;;;  ;;
;;NOT DOOM ;;;  ;; e) (change-path in clipboard) <-- no use case
;;NOT DOOM ;;;  ;;
;;NOT DOOM ;;;  ;; **** term-mode
;;NOT DOOM ;;;   (evil-define-key 'normal term-raw-map (kbd "P") 'ssh-clipboard-term-paste)
;;NOT DOOM ;;;   (evil-define-key 'normal term-raw-map (kbd "C-S-p") 'ssh-clipboard-term-paste) ;; (kbd "C-P") is NOT working (interpreted same as "C-p" apparently)
;;NOT DOOM ;;;   (evil-define-key 'emacs term-raw-map (kbd "C-S-p") 'ssh-clipboard-term-paste) ;; (kbd "C-P") is NOT working (interpreted same as "C-p" apparently)
;;NOT DOOM ;;;   (evil-define-key 'insert term-raw-map (kbd "C-S-p") 'ssh-clipboard-term-paste) ;; (kbd "C-P") is NOT working (interpreted same as "C-p" apparently)
;;NOT DOOM ;;;  ;; **** dired-mode
;;NOT DOOM ;;;   (evil-define-key 'normal dired-mode-map (kbd "C-S-y") 'ssh-clipboard-copy) ;; (kbd "C-P") is NOT working (interpreted same as "C-p" apparently)
;;NOT DOOM ;;;   (evil-define-key 'emacs dired-mode-map (kbd "C-S-y") 'ssh-clipboard-copy) ;; (kbd "C-P") is NOT working (interpreted same as "C-p" apparently)
;;NOT DOOM ;;;   (evil-define-key 'insert dired-mode-map (kbd "C-S-y") 'ssh-clipboard-copy) ;; (kbd "C-P") is NOT working (interpreted same as "C-p" apparently)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * frequently used unicode characters
;;NOT DOOM ;;;  ;; ** docu/instruction -> how to get the code of a character
;;NOT DOOM ;;;  ;;    - copy the symbol (e.g. from browser) to an emacs buffer ;;    - type 'C-x =' (M-x what-cursor-position, or also M-x describe-char) , -> it will give you the unicode number in decimal/octal/hex
;;NOT DOOM ;;;  ;;    - copy hex-code form minibuffer (e.g. for ↯ -> minibuffer: Char ↯ (8623, #o20657, #x21af, file, ... )
;;NOT DOOM ;;;  ;;                                                                         ^        ^       ^
;;NOT DOOM ;;;  ;;                                                                         |        |       |
;;NOT DOOM ;;;  ;;                                                                       decimal  octal   hexadecimal
;;NOT DOOM ;;;  ;;                                                                       (8623)   (20657   (21af)
;;NOT DOOM ;;;  ;;                                                                                          ^^^^
;;NOT DOOM ;;;  ;;                                                                                          ||||__ hex1
;;NOT DOOM ;;;  ;;                                                                                          |||___ hex2
;;NOT DOOM ;;;  ;;                                                                                          ||____ hex3
;;NOT DOOM ;;;  ;;                                                                                          |_____ hex4
;;NOT DOOM ;;;  ;;                                                                                        -> hex5/6/7/8 are "empty" or 0  --> full UTF-8 (4 bytes, 8 hex) number is 000021af
;;NOT DOOM ;;;  ;;
;;NOT DOOM ;;;  ;;    - take the hex number (e.g. #x21af for "↯"), "fill up" with 0's until hex8 and prefix with "\U" -> "\U<hex8>...<hex2><hex1>, e.g. \U000021af"
;;NOT DOOM ;;;  ;;    - (above works for *all* utf-8 symbols. but if you have an ascii, i.e. only two hex, i.e. 1 byte, e.g. #x61 for "a", you can also use "small" prefix "\u"  and only "fill up" 0's till hex4: "\u<hex4><hex3><hex2><hex1>", e.g. "\u0061")
;;NOT DOOM ;;;  ;;    - how to print it with elisp?
;;NOT DOOM ;;;  ;;      -- use hexadecimal value:  (insert "\u21af"), mind: always 4 chars, preceed with 0's e.g. for 'a' (61) --> (insert "\u0061")
;;NOT DOOM ;;;  ;;      -- use decimal value: don t know...
;;NOT DOOM ;;;  ;; ** background on unicode and UTF-8
;;NOT DOOM ;;;  ;;    - utf-8 DOES not (generally) have 8 bits
;;NOT DOOM ;;;  ;;    - it is a "variable-width character encoding" (wikipedia)
;;NOT DOOM ;;;  ;;    - that means, it uses either 1 byte ( = 8 bits = *256 values* = *two hex* (16*16)) , or 2 bytes (16 bits), or 3 bytes(24 bits), or 4 bytes (32 bits).
;;NOT DOOM ;;;  ;;      -- 1 byte : 0xxxxxxx                             -> all 128 ascii characters
;;NOT DOOM ;;;  ;;      -- 2 bytes: 110xxxxx 10xxxxxx                    -> latin, greek, arabic, hebrew, etc.
;;NOT DOOM ;;;  ;;      -- 3 bytes: 1110xxxx 10xxxxxx 10xxxxxx           -> chinese, japanese, etc.
;;NOT DOOM ;;;  ;;      -- 4 bytes: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx  -> grinning cats, etc.
;;NOT DOOM ;;;  ;;      -- the binary number                  : <byte4> <byte3> <byte2> <byte1>
;;NOT DOOM ;;;  ;;      -- but the UTF-8 format (*reverse!*)  : <byte1> <byte2> <byte3> <byte4> (*reverse!*)
;;NOT DOOM ;;;  ;;    - a bit of "human-machine-confusion" -> read number/bytes "left to right" or "right to left" ???
;;NOT DOOM ;;;  ;;      -- first of all "right to left - thinking" can be misleading. it s coming from when we count from low to high numbers -> then we go right to left:  001, 002, 003, etc. or in binary: 001,010,011,100,101,etc.
;;NOT DOOM ;;;  ;;      -- however "counting-direction" does not have to be "read-direction", i think the read direction is from left to right. i.e. when reading 0xxxxxxx, we first read the "1st" bit. and it immediately tells us that we have an ASCII character.
;;NOT DOOM ;;;  ;;      -- so the most significant bits "IN ONE BYTE" are the first ones
;;NOT DOOM ;;;  ;;      -- one byte is counted "right to left" as we know it from decimal, i.e. 00000001 = 1, 00000010 = 2, etc.
;;NOT DOOM ;;;  ;;      -- however, when it comes to "READING MULTIPLE BYTES" the "SIGNIFICANCE HIERARCHY IS REVERSE (!!!)
;;NOT DOOM ;;;  ;;      -- i.e. the "1st byte" is the "LEAST SIGNIFICANT BYTE" (!!!)
;;NOT DOOM ;;;  ;;      -- fazit: this is great for UTF-8 reading efficiency -> we immediately know if we re dealing with ascii from the first bit of the *first byte* (!)
;;NOT DOOM ;;;  ;;          BUT: the "REAL" binary number would be BYTE4 BYTE3 BYTE2 BYTE1 (!)
;;NOT DOOM ;;;  ;;          so: composing the real number of an UTF8-character, we d have to reverse order these bytes.
;;NOT DOOM ;;;  ;;    - so NOT ALL possible numbers of 4 bytes (= (2**8)**4 = 4,294,967,296 ) are used
;;NOT DOOM ;;;  ;;    - so the total number of characters is: 2**7 + 2**(5+6) + 2**(4+6+6) + 2**(3+6+6+6) = 2.16 Mio characters, this is sufficient for all currently valid registered unicode characters (=1.11 Mio)
;;NOT DOOM ;;;  ;;    - because only some "x's" are left free. but by this the leading bits of the bytes can be used to predetermine if we re dealing with ascii (1 byte), latin (2 bytes), asian (3 bytes), or extra stuff (4 bytes).
;;NOT DOOM ;;;  ;;    - it is backward compatible with ASCII (first 128 characters, i.e. first 7 bits) are equal to ascii. so EVERY ASCII test is VALID UTF-8-encoded unicode AS WELL(!).
;;NOT DOOM ;;;  ;;    - how to enter in emacs:
;;NOT DOOM ;;;  ;;    -- 1 byte or 2 byte unicode character --> use "\u<byte2><byte1> always type TWO (!) bytes, that means precede "00" when ascii.
;;NOT DOOM ;;;  ;;                                       (insert "\u <2nd byte as two hex> <1st byte as two hex> )
;;NOT DOOM ;;;  ;;                                       e.g. for 'a' (insert "\u0061")
;;NOT DOOM ;;;  ;;    -- 3 byte or 4 byte unicode character -> use capital \U : "\U<byte4><byte3><byte2>byte1>
;;NOT DOOM ;;;  ;;         ( u can also use capital \U for ascii, but have to preceed with THREE "empty" 00 bytes. e.g. (insert "\U00000061) ;; -> "a"

;; * special characters, fast input via "M-,"
;; first unbind "M-," -> so it does not complain
(map! :map (global-map anaconda-mode-map)
      "M-,"  nil)
(general-create-definer js/specialchardef :prefix "M-,")
;; g -> Greek
;; m -> Math
;; c -> special Chars

;; others: US-International-AltGr
;; s  -> ß
;; y  -> ü
;; p  -> ö
;; q  -> ä

;; ** US-international chars => "M-," ≙ "AltGr"
(defun js/insert-unicode-umlaut-u ()
  ;; ü
  (interactive)
  (insert "\U000000FC"))
(js/specialchardef "y" #'js/insert-unicode-umlaut-u)

(defun js/insert-unicode-umlaut-a ()
  ;; ä
  (interactive)
  (insert "\U000000E4"))
(js/specialchardef "q" #'js/insert-unicode-umlaut-a)


(defun js/insert-unicode-umlaut-o ()
  ;; ö
  (interactive)
  (insert "\U000000f6"))
(js/specialchardef "p" #'js/insert-unicode-umlaut-o)

(defun js/insert-unicode-umlaut-sz ()
  ;; ß
  (interactive)
  (insert "\U000000df"))
(js/specialchardef "s" #'js/insert-unicode-umlaut-sz)




;; ** contradiction ↯
(defun js/insert-unicode-contradiction ()
  ;; inserts a contradiction-symbol ↯
  (interactive)
  ;; (insert (char-from-name "DOWNWARDS ZIGZAG ARROW"))
  ;; (insert "\u21af")
  (insert "\U000021af")
  )

(defun js/insert-unicode-arrow ()
  ;; ➜
  (interactive)
  (insert "\U0000279C"))

(defun js/insert-unicode-Arrow ()
  ;; ➔
  (interactive)
  (insert "\U00002794"))
(js/specialchardef ">" #'js/insert-unicode-Arrow)
(js/specialchardef "RET" #'js/insert-unicode-Arrow)

(defun js/insert-unicode-approx ()
  ;; ≈
  (interactive)
  (insert "\U00002248"))
(js/specialchardef "m a" #'js/insert-unicode-approx)

(defun js/insert-unicode-Delta ()
  ;; Δ
  (interactive)
  (insert "\U00000394"))
(js/specialchardef "g D" #'js/insert-unicode-Delta)


(defun js/insert-unicode-lambda ()
  ;; λ
  (interactive)
  (insert "\U000003BB"))
(js/specialchardef "g l" #'js/insert-unicode-lambda)

(defun js/insert-unicode-corresponds ()
  ;; ≙
  (interactive)
  (insert "\U00002259"))
(js/specialchardef "m c" #'js/insert-unicode-corresponds)


(defun js/insert-unicode-sqrt ()
  ;; √
  (interactive)
  (insert "\U0000221A"))
(js/specialchardef "m s" #'js/insert-unicode-sqrt)

(defun js/insert-unicode-tab ()
  ;; 	(TAB)
  (interactive)
  (insert "\U00000009")
  )
(js/specialchardef "TAB" #'js/insert-unicode-tab)

;; ** dot "multiply"
(defun js/insert-unicode-dot ()
  ;; inserts a contradiction-symbol ↯
  (interactive)
  (insert "\U000000B7")
  )

(defun js/insert-unicode-mu ()
  ;; μ
  (interactive)
  (insert "\U000003BC")
  )
(js/specialchardef "g m" #'js/insert-unicode-mu)

(defun js/insert-unicode-int ()
  ;; ∫
  (interactive)
  (insert "\U0000222B")
  )

(defun js/insert-unicode-dot ()
  ;; ·
  (interactive)
  (insert "\U000000B7")
  )
(js/specialchardef
        "." #'js/insert-unicode-dot)
(js/specialchardef
        "m d" #'js/insert-unicode-dot)


(defun js/insert-unicode-rho ()
  ;; ρ
  (interactive)
  (insert "\U000003C1")
  )
(js/specialchardef
        "g r" #'js/insert-unicode-rho)


(defun js/insert-unicode-inf ()
  ;; ∞
  (interactive)
  (insert "\U0000221E")
  )
(js/specialchardef
        "m f" #'js/insert-unicode-inf)

(defun js/insert-unicode-theta ()
  ;; inserts a contradiction-symbol ↯
  (interactive)
  ;; (insert (char-from-name "DOWNWARDS ZIGZAG ARROW"))
  ;; (insert "\u21af")
  (insert "\U000003B8")
  )

(defun js/insert-unicode-omega ()
  ;; inserts a contradiction-symbol ↯
  (interactive)
  ;; (insert (char-from-name "DOWNWARDS ZIGZAG ARROW"))
  ;; (insert "\u21af")
  (insert "\U000003C9")
  )
(js/specialchardef "g o" #'js/insert-unicode-omega)


(defun js/insert-unicode-epsilon ()
  ;; ε
  (interactive)
  (insert "\U000003B5")
  )
(js/specialchardef "g e" #'js/insert-unicode-epsilon)

(defun js/insert-unicode-circled-dot ()
  ;; ⊙
  (interactive)
  (insert "\U00002299"))

(defun js/insert-unicode-cross ()
  ;; ⨯
  (interactive)
  (insert "\U00002A2F"))


(defun js/insert-unicode-nabla ()
  ;; ∇
  (interactive)
  (insert "\U00002207")
  )
(js/specialchardef "m N" #'js/insert-unicode-nabla)

(defun js/insert-unicode-Omega ()
  ;; Ω
  (interactive)
  (insert "\U000003A9")
  )
(js/specialchardef "O" #'js/insert-unicode-Omega)


(defun js/insert-unicode-squared ()
  ;; ²
  (interactive)
  (insert "\U000000B2")
  )
(js/specialchardef "2" #'js/insert-unicode-squared)

(defun js/insert-unicode-cubed ()
  ;; ³
  (interactive)
  (insert "\U000000B3"))
(js/specialchardef "3" #'js/insert-unicode-cubed)



(defun js/insert-unicode-phi ()
  ;; φ
  (interactive)
  (insert "\U000003C6"))
(js/specialchardef "g f" #'js/insert-unicode-phi)

(defun js/insert-unicode-pi ()
  ;; π
  (interactive)
  (insert "\U000003C0"))
(js/specialchardef "g p" #'js/insert-unicode-pi)

(defun js/insert-unicode-tau ()
  ;; τ
  (interactive)
  (insert "\U000003C4"))
(js/specialchardef "g t" #'js/insert-unicode-tau)

(defun js/insert-unicode-sigma ()
  (interactive)
  (insert "\U000003C3"))
(js/specialchardef "g s" #'js/insert-unicode-sigma)


(defun js/insert-unicode-psi ()
  (interactive)
  (insert "\U000003C8"))
(js/specialchardef "g y" #'js/insert-unicode-psi)

(defun js/insert-unicode-omega ()
  (interactive)
  (insert "\U000003C9"))

(defun js/insert-unicode-kappa ()
  (interactive)
  (insert "\U000003BA"))
(js/specialchardef "g k" #'js/insert-unicode-kappa)

(defun js/insert-unicode-lambda ()
  (interactive)
  (insert "\U000003BB"))

(defun js/insert-unicode-nu ()
  (interactive)
  (insert "\U000003BD"))
(js/specialchardef "g n" #'js/insert-unicode-nu)

(defun js/insert-unicode-xi ()
  (interactive)
  (insert "\U000003BE"))
(js/specialchardef "g x" #'js/insert-unicode-xi)

(defun js/insert-unicode-div ()
  ;; ÷
  (interactive)
  (insert "\U000000F7"))
(defun js/insert-unicode-mult ()
  ;; ×
  (interactive)
  (insert "\U000000D7"))



(defun js/insert-unicode-alpha ()
  (interactive)
  (insert "\U000003B1"))

(defun js/insert-unicode-beta ()
  (interactive)
  (insert "\U000003B2"))
(js/specialchardef "g b" #'js/insert-unicode-beta)

(defun js/insert-unicode-gamma ()
  (interactive)
  (insert "\U000003B3"))
(js/specialchardef "g g" #'js/insert-unicode-gamma)

(defun js/insert-unicode-delta ()
  ;; δ
  (interactive)
  (insert "\U000003B4"))
(js/specialchardef "g d" #'js/insert-unicode-delta)


(defun js/insert-unicode-sum ()
  ;; ∑
  (interactive)
  (insert "\U00002211")
  )
(js/specialchardef "m S" #'js/insert-unicode-sum)

(defun js/insert-unicode-tau ()
  ;; τ
  (interactive)
  (insert "\U000003C4"))
(js/specialchardef "g t" #'js/insert-unicode-tau)

(defun js/insert-unicode-zeta ()
  ;; ζ
  (interactive)
  (insert "\U000003B6"))
(js/specialchardef "g z" #'js/insert-unicode-zeta)

(defun js/insert-unicode-eta ()
  ;; η
  (interactive)
  (insert "\U000003B7"))
(js/specialchardef "g h" #'js/insert-unicode-eta)

;; latin equivalents for greek letters (➜ choose my key-combos)
;; Α 	α 	Alpha 	a
;; Β 	β 	Beta 	b
;; Γ 	γ 	Gamma 	g
;; Δ 	δ 	Delta 	d
;; Ε 	ε 	Epsilon 	e
;; Ζ 	ζ 	Zeta 	z
;; Η 	η 	Eta 	h
;; Θ 	θ 	Theta 	th
;; Ι 	ι 	Iota 	i
;; Κ 	κ 	Kappa 	k
;; Λ 	λ 	Lambda 	l
;; Μ 	μ 	Mu 	m
;; Ν 	ν 	Nu 	n
;; Ξ 	ξ 	Xi 	x
;; Ο 	ο 	Omicron 	o
;; Π 	π 	Pi 	p
;; Ρ 	ρ 	Rho 	r
;; Σ 	σ,ς * 	Sigma 	s
;; Τ 	τ 	Tau 	t
;; Υ 	υ 	Upsilon 	u
;; Φ 	φ 	Phi 	ph
;; Χ 	χ 	Chi 	ch
;; Ψ 	ψ 	Psi 	ps
;; Ω 	ω 	Omega 	o

(defun js/insert-unicode-sub-i ()
  ;; ᵢ
  (interactive)
  (insert "\U00001D62"))
(js/specialchardef "m i" #'js/insert-unicode-sub-i)

(defun js/insert-unicode-circle-dot()
  ;; ⊙
  (interactive)
  (insert "\U00002299"))

(defun js/insert-unicode-circle-cross()
  ;; ⨂
  (interactive)
  (insert "\U00002A02"))

(defun js/insert-unicode-degree ()
  ;; °
  (interactive)
  (insert "\U000000B0")
  )
(js/specialchardef "c d" #'js/insert-unicode-degree)

(defun js/insert-unicode-Checkmark ()
  (interactive)
  ;; (insert "\U00002713") ;; ✓
  (insert "\U00002705")) ;; ✅

(defun js/insert-unicode-checkmark ()
  (interactive)
  ;; ✓
  (insert "\U00002713"))
;; ;;NOT DOOM ;;;
;; ;;NOT DOOM ;;;  (defun insert-char-pencil ()
;; ;;NOT DOOM ;;;    ;; inserts a pencil-symbol ✎
;; ;;NOT DOOM ;;;    (interactive)
;; ;;NOT DOOM ;;;    ;; (insert (char-from-name "DOWNWARDS ZIGZAG ARROW"))
;; ;;NOT DOOM ;;;    ;; (insert "\u21af")
;; ;;NOT DOOM ;;;    (insert "\U0000270e")
;; ;;NOT DOOM ;;;    )
;; ;;NOT DOOM ;;;
;; ;;NOT DOOM ;;;
;; ;;NOT DOOM ;;;  ;; (insert "\U0000270E")✎
;; ;;NOT DOOM ;;;  ;; (insert "\U0000270f")✏
;; ;;NOT DOOM ;;;  ;; (insert "\U00002710")✐
;; ;;NOT DOOM ;;;  ;; (insert "\U00002711")✑
;; ;;NOT DOOM ;;;  ;; (insert "\U00002712")✒
;; ;;NOT DOOM ;;;
;; ;;NOT DOOM ;;;

;; * termux android

;; ** paste from android-clipboard
(defun android-paste-clipboard ()
  (interactive)
  (setq output (shell-command-to-string "termux-clipboard-get"))
  (setq clipboard-string output) ;; in case no error occured, could be checked before
  (insert clipboard-string)
)

;; ** put frequent things to clipboard
(defun android-copy-to-clipboard ()
  (interactive)
  (setq region-string (region-to-string))
  (setq command-string (concat "termux-clipboard-set '" region-string "'"))
  (async-shell-command command-string)
  )
(defun my-phone-number-to-clipboard ()
  (interactive)
  (setq my-phone-number "+4917657978870")
  (setq command-string (concat "termux-clipboard-set '" my-phone-number "'"))
  (async-shell-command command-string)
  )
(defvar my-email-address "johannes.sacher@googlemail.com")
(defun copy-to-clipboard-my-email ()
  (interactive)
  (setq my-phone-number my-email-address)
  (setq command-string (concat "termux-clipboard-set '" my-phone-number "'"))
  (async-shell-command command-string)
  )

(defun my-address-to-clipboard ()
  (interactive)
  (setq my-address "Fanningerstr. 52 10635 Berlin")
  (setq command-string (concat "termux-clipboard-set '" my-phone-number "'"))
  (async-shell-command command-string)
  )

(defun android-go-to-camera-directory ()
  (interactive)
  (setq camera-pics-dir "/storage/0000-0000/DCIM/Camera/")
  (dired camera-pics-dir)
  )

(defun android-go-to-screenshots-directory ()
  (interactive)
  (setq screenshots-dir "/storage/emulated/0/DCIM/Screenshots")
  (dired screenshots-dir)
  )

(defun latest-screenshot-pic-get-file-name ()
  (interactive)
  ;; get current dir
  (setq current-path (get-current-path))
  ;; get cam pics dir
  (setq screenshots-dir "/storage/emulated/0/DCIM/Screenshots")
  ;; get file name latest
  (setq all-files (directory-files screenshots-dir))
  (setq latest-pic-file (car (last all-files)))
  (setq latest-pic-file-fullname (concat screenshots-dir latest-pic-file))
  (message (concat "latest screenshot file:" latest-pic-file-fullname))
  latest-pic-file)

(defun latest-camera-pic-get-file-name ()
  (interactive)
  ;; get current dir
  (setq current-path (get-current-path))
  ;; get cam pics dir
  (setq camera-pics-dir "/storage/0000-0000/DCIM/Camera/")
  ;; (setq camera-pics-dir "/home/johannes/dummy_camera_pics/")
  ;; get file name latest
  (setq all-files (directory-files camera-pics-dir))
  (setq latest-pic-file (car (last all-files)))
  (setq latest-pic-file-fullname (concat camera-pics-dir latest-pic-file))
  latest-pic-file)

(defun latest-camera-pic-get-file-fullname ()
  (interactive)
  ;; get current dir
  (setq current-path (get-current-path))
  ;; get cam pics dir
  (setq camera-pics-dir "/storage/0000-0000/DCIM/Camera/")
  ;; (setq camera-pics-dir "/home/johannes/dummy_camera_pics/")
  ;; get file name latest
  (setq all-files (directory-files camera-pics-dir))
  (setq latest-pic-file (car (last all-files)))
  (setq latest-pic-file-fullname (concat camera-pics-dir latest-pic-file))
  latest-pic-file-fullname)

(defun latest-camera-pic-copy-to-currentdir ()
  (interactive)
  ;; get current dir
  (setq current-path (get-current-path))
  ;; get cam pics dir
  (setq camera-pics-dir "/storage/0000-0000/DCIM/Camera/")
  ;; (setq camera-pics-dir "/home/johannes/dummy_camera_pics/")
  ;; get file name latest
  (setq all-files (directory-files camera-pics-dir))
  (setq latest-pic-file (car (last all-files)))
  (setq latest-pic-file-fullname (concat camera-pics-dir latest-pic-file))
  (message latest-pic-file-fullname)
  ;; copy
  (copy-file latest-pic-file-fullname current-path t)
  )

(defun org-insert-latest-camera-pic () ;; --> insert image after after shooting a photo with camera (working only on mobile phone))
  (interactive)
  ;; copy to current dir
  (latest-camera-pic-copy-to-currentdir)
  ;; make reference in org-file
  (setq filename (latest-camera-pic-get-file-name))
  (end-of-line)
  (newline)
  (insert (concat "[[file:" filename "]]"))
  ;; (org-redisplay-inline-images)
  )

(defun org-insert-latest-screenshot-pic () ;; --> insert image after after shooting a photo with camera (working only on mobile phone))
  (interactive)
  ;; copy to current dir
  (latest-camera-pic-copy-to-currentdir)
  ;; make reference in org-file
  (setq filename (latest-screenshot-pic-get-file-name))
  (end-of-line)
  (newline)
  (insert (concat "[[file:" filename "]]"))
  ;; (org-redisplay-inline-images)
  )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * auto-complete
;;NOT DOOM ;;; (require 'auto-complete-config)
;;NOT DOOM ;;;  (ac-config-default)
;;NOT DOOM ;;;  (set-face-attribute 'ac-selection-face t :background "deep sky blue" :foreground "black")
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (set-face-attribute 'popup-menu-selection-face t :inherit 'default :background "cyan" :foreground "black")
;;NOT DOOM ;;;  (set-face-attribute 'popup-scroll-bar-foreground-face t :background "deep sky blue")
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * if debug on start-up (-> disable now debug for session)
;;NOT DOOM ;;;  (if debug-only-on-start-up
;;NOT DOOM ;;;    (setq debug-on-error nil)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * image viewing (imagemagick)
;;NOT DOOM ;;;  ;; ** image-set-size (not built-in (!) --> 100% 200% etc)
;;NOT DOOM ;;;  (defun image-set-size ()
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    ;; (setq new_scale (read-number "resizing -> enter new scale: "))
;;NOT DOOM ;;;    ;; (let* ((image (image--get-imagemagick-and-warn))
;;NOT DOOM ;;;    ;;        (new-image (image--image-without-parameters image))
;;NOT DOOM ;;;    ;;        (scale (image--current-scaling image new-image)))
;;NOT DOOM ;;;    ;;   (setcdr image (cdr new-image))
;;NOT DOOM ;;;    ;;   (plist-put (cdr image) :scale new_scale)))
;;NOT DOOM ;;;    (image-transform-set-scale)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** no line numbers
;;NOT DOOM ;;;  (add-hook 'image-mode-hook
;;NOT DOOM ;;;            (lambda ()
;;NOT DOOM ;;;              (display-line-numbers-mode -1)))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** evil key bindings
;;NOT DOOM ;;;  (evil-define-key 'normal image-mode-map (kbd "n") 'image-next-file)
;;NOT DOOM ;;;  (evil-define-key 'normal image-mode-map (kbd "p") 'image-previous-file)
;;NOT DOOM ;;;  (evil-define-key 'normal image-mode-map (kbd "r") 'image-rotate)
;;NOT DOOM ;;;  (evil-define-key 'normal image-mode-map (kbd "+") 'image-increase-size)
;;NOT DOOM ;;;  (evil-define-key 'normal image-mode-map (kbd "=") 'image-increase-size)
;;NOT DOOM ;;;  (evil-define-key 'normal image-mode-map (kbd "-") 'image-decrease-size)
;;NOT DOOM ;;;  (evil-define-key 'normal image-mode-map (kbd "s") 'image-save)
;;NOT DOOM ;;;  (evil-define-key 'normal image-mode-map (kbd "w") 'image-transform-fit-to-width)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  (evil-define-key 'normal org-mode-map (kbd "TAB") 'org-cycle)
;;NOT DOOM ;;;  ;; o               image-save
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; +               image-increase-size
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; -               image-decrease-size
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; r               image-rotate
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; n               image-next-file
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; o               image-save
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; p               image-previous-file
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; C-c             Prefix Command
;;NOT DOOM ;;;  ;; RET             image-toggle-animation
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; SPC             image-scroll-up
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; +               image-increase-size
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; -               image-decrease-size
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; 0               digit-argument
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; <               beginning-of-buffer
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; >               end-of-buffer
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; ?               describe-mode
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; F               image-goto-frame
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; a               Prefix Command
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; b               image-previous-frame
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; f               image-next-frame
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; g               revert-buffer
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; h               describe-mode
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; k               image-kill-buffer
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; n               image-next-file
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; o               image-save
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; p               image-previous-file
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; q               quit-window
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; r               image-rotate
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; DEL             image-scroll-down
;;NOT DOOM ;;;  ;;   (that binding is currently shadowed by another mode)
;;NOT DOOM ;;;  ;; S-SPC           image-scroll-down
;;NOT DOOM ;;;  ;; <remap>         Prefix Command
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; <remap> <backward-char>         image-backward-hscroll
;;NOT DOOM ;;;  ;; <remap> <beginning-of-buffer>   image-bob
;;NOT DOOM ;;;  ;; <remap> <end-of-buffer>         image-eob
;;NOT DOOM ;;;  ;; <remap> <forward-char>          image-forward-hscroll
;;NOT DOOM ;;;  ;; <remap> <left-char>             image-backward-hscroll
;;NOT DOOM ;;;  ;; <remap> <move-beginning-of-line>
;;NOT DOOM ;;;  ;;                                 image-bol
;;NOT DOOM ;;;  ;; <remap> <move-end-of-line>      image-eol
;;NOT DOOM ;;;  ;; <remap> <next-line>             image-next-line
;;NOT DOOM ;;;  ;; <remap> <previous-line>         image-previous-line
;;NOT DOOM ;;;  ;; <remap> <right-char>            image-forward-hscroll
;;NOT DOOM ;;;  ;; <remap> <scroll-down>           image-scroll-down
;;NOT DOOM ;;;  ;; <remap> <scroll-down-command>   image-scroll-down
;;NOT DOOM ;;;  ;; <remap> <scroll-left>           image-scroll-left
;;NOT DOOM ;;;  ;; <remap> <scroll-right>          image-scroll-right
;;NOT DOOM ;;;  ;; <remap> <scroll-up>             image-scroll-up
;;NOT DOOM ;;;  ;; <remap> <scroll-up-command>     image-scroll-up
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; C-c C-c         image-toggle-display
;;NOT DOOM ;;;  ;; C-c C-x         image-toggle-hex-display
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * mucke
;;NOT DOOM ;;;  (defun mucke-new-song-folder ()
;;NOT DOOM ;;;    "creates song folder/file in default mucke folder (currently ~/org/mucke), and opens it in INSERT mode"
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (setq owd default-directory)
;;NOT DOOM ;;;    ;; make folder in mucke
;;NOT DOOM ;;;    (cd (concat (substitute-in-file-name "$HOME") "/org/mucke"))
;;NOT DOOM ;;;    (setq artist-song-name (read-string "Enter Artist_SongNamr (e.g. 'MichaelJackson_BillieJean'):"))
;;NOT DOOM ;;;    (make-directory artist-song-name)
;;NOT DOOM ;;;    ;; make hidden org folder
;;NOT DOOM ;;;    (cd artist-song-name)
;;NOT DOOM ;;;    (message default-directory)
;;NOT DOOM ;;;    (setq song-file (create-hidden-org-file-folder artist-song-name))
;;NOT DOOM ;;;    ;; (cd owd)
;;NOT DOOM ;;;    ;; visit song-file so you can directly edit
;;NOT DOOM ;;;    (find-file song-file)
;;NOT DOOM ;;;    ;; paste android clipboard
;;NOT DOOM ;;;    (if (equal myhost "phone")
;;NOT DOOM ;;;    (android-paste-clipboard))
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * sound
;;NOT DOOM ;;;  ;; ** disable annoying bell sound
;;NOT DOOM ;;;  (setq ring-bell-function 'ignore)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * expand-region
;;NOT DOOM ;;; (use-package expand-region
;;NOT DOOM ;;;   :ensure t)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ** expand-region -> evil-mode shortcut -> visual mode map: "v" -> expand region / instead of exit visual mode
(map! :map evil-visual-state-map "v" 'er/expand-region)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * sudo-edit
;;NOT DOOM ;;;  (defun sudo-edit (&optional arg)
;;NOT DOOM ;;;    "Edit currently visited file as root.
;;NOT DOOM ;;;
;;NOT DOOM ;;;  With a prefix ARG prompt for a file to visit.
;;NOT DOOM ;;;  Will also prompt for a file to visit if current
;;NOT DOOM ;;;  buffer is not visiting a file."
;;NOT DOOM ;;;    (interactive "P")
;;NOT DOOM ;;;    (if (or arg (not buffer-file-name))
;;NOT DOOM ;;;        (find-file (concat "/sudo:root@localhost:"
;;NOT DOOM ;;;                           (ido-read-file-name "Find file(as root): ")))
;;NOT DOOM ;;;      (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))


;; * draft-horse-term
(defvar draft-horse-term-buffer-name "*draft-horse-term*")
(defun draft-horse-term-init ()
  "Start a terminal-emulator in a new buffer (non sticky and call it  '*draft-horse-term*')"
  (interactive)
  (setq program "/bin/bash")
  (setq term-ansi-buffer-name (concat draft-horse-term-buffer-name))
  (setq term-ansi-buffer-name (term-ansi-make-term term-ansi-buffer-name program))

  (switch-to-buffer term-ansi-buffer-name)

  (set-buffer term-ansi-buffer-name)
  (term-mode)
  (term-char-mode)

  ;; Historical baggage.  A call to term-set-escape-char used to not
  ;; undo any previous call to t-s-e-c.  Because of this, ansi-term
  ;; ended up with both C-x and C-c as escape chars.  Who knows what
  ;; the original intention was, but people could have become used to
  ;; either.   (Bug#12842)
  (let (term-escape-char)
    ;; I wanna have find-file on C-x C-f -mm
    ;; your mileage may definitely vary, maybe it's better to put this in your
    ;; .emacs ...
    (term-set-escape-char ?\C-x))
  )

(defun draft-horse-term ()
  (interactive)
  ;; initiate if not already exists
  (if (not (get-buffer draft-horse-term-buffer-name))
      (draft-horse-term-init)
      )
  ;; switch to that buffer
  (switch-to-buffer draft-horse-term-buffer-name)
  )

(map! :leader
    :desc "draft horse term" "oh" #'draft-horse-term )

;;NOT DOOM ;;;
;;NOT DOOM ;;;  (js/leader-def "z" 'draft-horse-term)
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * tutorials
;;NOT DOOM ;;;  ;; ;; ** match groups
;;NOT DOOM ;;;  ;; (let
;;NOT DOOM ;;;  ;;   ((this-string "The quick brown fox jumped quickly."))
;;NOT DOOM ;;;  ;;   (string-match "quick" this-string)
;;NOT DOOM ;;;  ;;   (string-match "\\(qu\\)\\(ick\\)" this-string)
;;NOT DOOM ;;;  ;;   ;; (match-string 0 "The quick brown fox jumped quickly.")
;;NOT DOOM ;;;  ;;   ;; (match-string 1 "The quick brown fox jumped quickly.")
;;NOT DOOM ;;;  ;;   (match-string 1 this-string))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; ** repace (sub)string in string
;;NOT DOOM ;;;  ;; (let ((this-string "foo.buzz"))
;;NOT DOOM ;;;  ;; (replace-regexp-in-string (regexp-quote ".") "bar" this-string)) ;; => foobarbuzz
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; ** replace "pair around something"
;;NOT DOOM ;;;  ;; (let ((this-string "hello, begin{exp1} my 1st expression end{exp1}, and here comes begin{exp1} my 2nd expression end{exp1}."))
;;NOT DOOM ;;;  ;;   ;; 1. with groups we can "dissect" the "<begin> <between> <end>" construct
;;NOT DOOM ;;;  ;;   (string-match "\\(begin{exp1}\\)\\(.*?\\)\\(end{exp1}\\)." this-string)
;;NOT DOOM ;;;  ;;   ;; (important note: the "?" makes the .* non-greedy! needed here
;;NOT DOOM ;;;  ;;   (setq the-whole-thing   (match-string 0 this-string))
;;NOT DOOM ;;;  ;;   (setq the-begin-thing   (match-string 1 this-string))
;;NOT DOOM ;;;  ;;   (setq the-between-thing (match-string 2 this-string))
;;NOT DOOM ;;;  ;;   (setq the-end-thing     (match-string 3 this-string))
;;NOT DOOM ;;;  ;;   ;; 2. now we can design "the-new-whole-thing"
;;NOT DOOM ;;;  ;;   (setq the-new-whole-thing (concat "begin{exp2}" the-between-thing "end{exp2}"))
;;NOT DOOM ;;;  ;;   ;; ;; 3. and replace the old by the new whole thing in the total string
;;NOT DOOM ;;;  ;;   (replace-regexp-in-string (regexp-quote the-whole-thing) the-new-whole-thing this-string)
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * move position to number in clipboard
;;NOT DOOM ;;;  ;; * aliases for unintuitively named functions
;;NOT DOOM ;;;  (defun move-curser-to-buffer-position-in-clipboard ()
;;NOT DOOM ;;;  ;; just an alias for goto-char
;;NOT DOOM ;;;    (interactive)
;;NOT DOOM ;;;    (setq POSITION (string-to-number (current-kill 0)))
;;NOT DOOM ;;;    (goto-char POSITION)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;  (defun move-curser-to-buffer-position-alias (POSITION)
;;NOT DOOM ;;;  ;; just an alias for goto-char
;;NOT DOOM ;;;    (interactive "nType position (integer):")
;;NOT DOOM ;;;    (goto-char POSITION)
;;NOT DOOM ;;;    )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * short-cuts (universal concept) for REPL/ debug / etc.
;;NOT DOOM ;;;  ;; ** send to REPL current fun. def. (i.e. evaluate current function in elisp)
;;NOT DOOM ;;;  ;;T (evil-leader/set-key-for-mode 'elisp-mode "tf" 'eval-defun)
;;NOT DOOM ;;;  ;; send to REPL current line (removing leading white spaces)
;;NOT DOOM ;;;  ;; send to REPL current region
;;NOT DOOM ;;;  ;; send to REPL var under point
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; =======
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; * tutorials
;;NOT DOOM ;;;  ;; ;; ** match groups
;;NOT DOOM ;;;  ;; (let
;;NOT DOOM ;;;  ;;   ((this-string "The quick brown fox jumped quickly."))
;;NOT DOOM ;;;  ;;   (string-match "quick" this-string)
;;NOT DOOM ;;;  ;;   (string-match "\\(qu\\)\\(ick\\)" this-string)
;;NOT DOOM ;;;  ;;   ;; (match-string 0 "The quick brown fox jumped quickly.")
;;NOT DOOM ;;;  ;;   ;; (match-string 1 "The quick brown fox jumped quickly.")
;;NOT DOOM ;;;  ;;   (match-string 1 this-string))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; ** repace (sub)string in string
;;NOT DOOM ;;;  ;; (let ((this-string "foo.buzz"))
;;NOT DOOM ;;;  ;; (replace-regexp-in-string (regexp-quote ".") "bar" this-string)) ;; => foobarbuzz
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; ;; ** replace "pair around something"
;;NOT DOOM ;;;  ;; (let ((this-string "hello, begin{exp1} my 1st expression end{exp1}, and here comes begin{exp1} my 2nd expression end{exp1}."))
;;NOT DOOM ;;;  ;;   ;; 1. with groups we can "dissect" the "<begin> <between> <end>" construct
;;NOT DOOM ;;;  ;;   (string-match "\\(begin{exp1}\\)\\(.*?\\)\\(end{exp1}\\)." this-string)
;;NOT DOOM ;;;  ;;   ;; (important note: the "?" makes the .* non-greedy! needed here
;;NOT DOOM ;;;  ;;   (setq the-whole-thing   (match-string 0 this-string))
;;NOT DOOM ;;;  ;;   (setq the-begin-thing   (match-string 1 this-string))
;;NOT DOOM ;;;  ;;   (setq the-between-thing (match-string 2 this-string))
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;;   (setq the-end-thing     (match-string 3 this-string))
;;NOT DOOM ;;;  ;;   ;; 2. now we can design "the-new-whole-thing"
;;NOT DOOM ;;;  ;;   (setq the-new-whole-thing (concat "begin{exp2}" the-between-thing "end{exp2}"))
;;NOT DOOM ;;;  ;;   ;; ;; 3. and replace the old by the new whole thing in the total string
;;NOT DOOM ;;;  ;;   (replace-regexp-in-string (regexp-quote the-whole-thing) the-new-whole-thing this-string)
;;NOT DOOM ;;;  ;;   )
;;NOT DOOM ;;;
;;NOT DOOM ;;;  ;; * lisp
;;NOT DOOM ;;;  ;; (evil-leader/set-key "<RET>" 'eval-expression)
;;NOT DOOM ;;;
;;NOT DOOM ;;; (defun js/org-table-csv ()
;;NOT DOOM ;;;   (interactive)
;;NOT DOOM ;;; (org-table-export (format "%s.csv" name) "orgtbl-to-csv"))
;;NOT DOOM ;;;
;; * hide/show modeline
(defvar js/modeline-format-temp mode-line-format
  "saves current modeline format as backup, to be restored after js/hide-mode-line js/show-mode-line")
(defun js/hide-mode-line ()
    (interactive)
    (setq js/modeline-format-temp mode-line-format)
    (setq mode-line-format nil))

(defun js/set-mode-line-str (str)
    (interactive)
    (setq js/modeline-format-temp mode-line-format)
    (setq mode-line-format str))

(defun js/show-mode-line ()
    (interactive)
    (setq mode-line-format js/modeline-format-temp))

;;NOT DOOM ;;; ;; * evil vim customization
;;NOT DOOM ;;; ;; ** 4 -> insert white space
;;NOT DOOM ;;;  (define-key evil-normal-state-map (kbd "4") 'js/insert-white-space)
;;NOT DOOM ;;;
;;NOT DOOM ;;; (defun js/insert-white-space ()
;;NOT DOOM ;;;   (interactive)
;;NOT DOOM ;;;   (insert " "))
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;; * scale fontsize (per frame)
(defvar js/frame-font-scale-factor)
(setq js/frame-font-scale-factor 1.2)
(defun js/frame-font-size-increase ()
  (interactive)
  (setq current-frame-fontsize (face-attribute 'default :height (selected-frame)))
  (set-face-attribute 'default (selected-frame) :height  (round (* js/frame-font-scale-factor current-frame-fontsize)))
)

(defun js/frame-font-size-decrease ()
  (interactive)
  (setq current-frame-fontsize (face-attribute 'default :height (selected-frame)))
  (set-face-attribute 'default (selected-frame) :height  (round (/ current-frame-fontsize js/frame-font-scale-factor)))
)

(global-set-key (kbd "M-+") 'js/frame-font-size-increase)
(after! undo-fu)
(map! :map undo-fu-mode-map
       "M-_" nil) ;; first gotto eliminate in higher priority key map
(global-set-key (kbd "M-_") #'js/frame-font-size-decrease)

(global-set-key (kbd "M-+") #'js/frame-font-size-increase)

(after! term
(map! :map term-raw-map
        "M-+"  #'js/frame-font-size-increase
        "M-_"  #'js/frame-font-size-decrease))

;;NOT DOOM ;;; ;; * set transparency
;;NOT DOOM ;;; (set-frame-parameter (selected-frame) 'alpha '(92 . 92)) ;; 90 90 refers to when active/when inactive
;;NOT DOOM ;;; (add-to-list 'default-frame-alist '(alpha . (92 . 92))) ;; make it also for new frames
;;NOT DOOM ;;; ;; (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
;;NOT DOOM ;;; ;; (add-to-list 'default-frame-alist '(fullscreen . maximized))
;;NOT DOOM ;;;
;;NOT DOOM ;;; ;; * EXWM window manager (this might go into some EXWM.el later)
;;NOT DOOM ;;;   (if (equal (getenv "WINDOW_MANAGER") "exwm");; env.-var set in .xinitrc_exwm
;;NOT DOOM ;;;       ;; (load "my_exwm_desktop.el")
;;NOT DOOM ;;;       (load "my_exwm_desktop1.el")
;;NOT DOOM ;;;     ;; (load "my_exwm_desktop_defaultconfig.el")
;;NOT DOOM ;;;   )
;;NOT DOOM ;;;
;;NOT DOOM ;;; ;; * misc stuff (order later)
;;NOT DOOM ;;; (if (equal myhost "phone")
;;NOT DOOM ;;;     (global-set-key (kbd "<f2>") 'android-paste-clipboard))
;;NOT DOOM ;;;
;;NOT DOOM ;;; ;; (defun js/org-insert-link-from-android-clipboard ()
;;NOT DOOM ;;; ;;   (interactive)
;;NOT DOOM ;;; ;;   (insert "[[")
;;NOT DOOM ;;; ;;   (android-paste-clipboard)
;;NOT DOOM ;;; ;;   (insert "][]]")
;;NOT DOOM ;;; ;;   (backward-char)
;;NOT DOOM ;;; ;;   (backward-char)
;;NOT DOOM ;;; ;;   (evil-insert-state))
;;NOT DOOM ;;;
;;NOT DOOM ;;; ;; (defun js/org-insert-link-from-android-clipboard (text)
;;NOT DOOM ;;; ;;   (interactive "sLink text: ")
;;NOT DOOM ;;; ;;   (insert "[[")
;;NOT DOOM ;;; ;;   (android-paste-clipboard)
;;NOT DOOM ;;; ;;   (insert "][")
;;NOT DOOM ;;; ;;   (insert text)
;;NOT DOOM ;;; ;;   (insert "]]"))
;;NOT DOOM ;;;
;;NOT DOOM ;;;
;;NOT DOOM ;;; (defun js/org-insert-link-from-clipboard (text)
;;NOT DOOM ;;;   (interactive "sLink text: ")
;;NOT DOOM ;;;   (insert "[[")
;;NOT DOOM ;;;   (cond ((equal myhost "laptop")
;;NOT DOOM ;;; 	 (yank))
;;NOT DOOM ;;; 	((equal myhost "laptop")
;;NOT DOOM ;;; 	 (android-paste-clipboarda)))
;;NOT DOOM ;;;   (insert "][")
;;NOT DOOM ;;;   (insert text)
;;NOT DOOM ;;;   (insert "]]"))
;;NOT DOOM ;;;
;;NOT DOOM ;;; ;; ;; * quick window config store/restore
;;NOT DOOM ;;; ;; (defvar window-config-list nil)
;;NOT DOOM ;;; ;; (defun window-config-store ()
;;NOT DOOM ;;; ;;   (interactive)
;;NOT DOOM ;;; ;;   (setq currwinconf (current-window-configuration))
;;NOT DOOM ;;; ;;   (add-to-list window-config-list currwinconf))
;;NOT DOOM ;;;
;;NOT DOOM ;;; ;; (defun window-config-restore ()
;;NOT DOOM ;;; ;;   (interactive)
;;NOT DOOM ;;; ;;   (setq currwinconf (current-window-configuration))
;;NOT DOOM ;;; ;;   (setq window-config-shuffle-list
;;NOT DOOM ;;; ;;   (add-to-list window-config-list winconf))
;;NOT DOOM ;;;
;;NOT DOOM ;;; ;; * treemacs
;;NOT DOOM ;;;   (add-hook 'treemacs-mode-hook
;;NOT DOOM ;;;             (lambda nil (display-line-numbers-mode -1)))
;;NOT DOOM ;;;

;; * launch external program
(defun efs/run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))
(defun js/launch-app-command (command)
  (interactive "sApp command: ")
  ;; (message (concat "your command was: " command))
  (efs/run-in-background command))

(map! :leader
      :desc "Launch (terminal) command" ">" #'js/launch-app-command)

;; * org color words
(defface org-red-face '((nil :foreground "red")) "org red face")
(font-lock-add-keywords 'org-mode '(("\\\\red{.*}" . 'org-red-face)))

;; * orgify (my own package for orgified-file-concept)
;; each file can be "orgified", simply means: put it file.ext in folder file.ext
;; folder can contain file.ext.org file, with "connective data/id" and meta-data/description/wiki
(defun orgify-dired-open ()
                   (interactive)
                   (setq filename (dired-get-file-for-visit)))

;; * org-present
;; ** increase latex preview size also
(defvar js/org-latex-preview-scale-default 2.0)
(defvar js/org-latex-preview-scale-treeslide 3.0)
;; (add-hook! org-tree-slide-mode
;;            ;; (message "org-tree-slide-mode hook executing..")
;;            (js/org-latex-preview-scale-set-treeslide))

(defun js/org-latex-preview-scale-set-default ()
  (interactive)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale js/org-latex-preview-scale-default))
  (org-latex-refresh-all))

(defun js/org-latex-preview-scale-decrease ()
  "decreases latex preview font by 20%"
  (interactive)
  (setq js/org-latex-preview-scale-default (* 0.8 js/org-latex-preview-scale-default))
  (setq org-format-latex-options (plist-put org-format-latex-options :scale js/org-latex-preview-scale-default))
  (org-latex-refresh-all))

(defun js/org-latex-preview-scale-increase ()
  "decreases latex preview font by 20%"
  (interactive)
  (setq js/org-latex-preview-scale-default (* 1.2 js/org-latex-preview-scale-default))
  (setq org-format-latex-options (plist-put org-format-latex-options :scale js/org-latex-preview-scale-default))
  (org-latex-refresh-all))


(defun js/org-latex-preview-scale-set-treeslide ()
  (interactive)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale js/org-latex-preview-scale-treeslide))
  (org-latex-refresh-all))

;; ** presentation startup script
(setq org-tree-slide-play-hook nil)
(add-hook! 'org-tree-slide-play-hook
           (lambda () (message "slide-play-hooks executing..."))
           #'js/org-latex-preview-scale-set-treeslide
           (lambda () (setq inhibit-message t)) ;; inhibit for presentation
           (lambda () (interactive) (js/set-mode-line-str ("BASF Aufgabe: Stabilisierung Füllstände Turmreaktor - Analyse/Lösungskonzepte | Johannes Sacher | johannes.sacher@googlemail.com | 8.11.2021")))
           (lambda () (message "slide-play-hooks executed."))
  )

;; ** presentation stop script
(add-hook! 'org-tree-slide-stop-hook
           #'js/org-latex-preview-scale-set-default
           (lambda () (setq inhibit-message nil)) ;; inhibit for presentation
           )

(add-hook! 'org-tree-slide-next-hook
  #'(org-latex-refresh-all))

;; kind of "start-up" script when slide is loaded
(setq org-tree-slide-after-narrow-hook nil)
(add-hook! 'org-tree-slide-after-narrow-hook
           #'org-latex-refresh-all
           (lambda () (interactive) (js/set-mode-line-str ("BASF Aufgabe: Stabilisierung Füllstände Turmreaktor - Analyse/Lösungskonzepte | Johannes Sacher | johannes.sacher@googlemail.com | 8.11.2021"))))
           ;; (lambda () (message "org-tree-slide-after-narrow-hook executing.."))

(after! org-tree
;; (org-tree-slide-presentation-profile)
;; (org-tree-slide-simple-profile)
;; (org-tree-slide-narrowing-control-profile)
)

;; * orgify
(defun js/orgify-dired-open-orgified-file ()
  (interactive)
  ;; get orgified-file name under cursor
  ;; open
  )

(map! :map dired-mode-map
      :n ">" #'js/orgify-dired-open-orgified-file)

(map! :leader
      :desc "M-x" "x" #'execute-extended-command
      )
;; * org mode - add todo-keywords
(after! org
(custom-declare-face '+org-todo-current  '((t (:inherit (bold error org-todo)))) "")
(setq org-todo-keywords (append  org-todo-keywords '((sequence
                                                    "CRNT(c)"  ; The task that is in work currently
                                                    "|"  ;; (after "|" tells org-mode -> following do not require action)
                                                    "CNCD(C)"  ; The task is canceled
                                                    "POST(P)"  ; The task was postponed, but not canceled
                                                    "PROG(g)"  ; was in progressed, but not finished
                                                    "BEST(b)"  ; best choice /  chosen
                                                    "DISC(D)"  ; discarded
                                                    ))))
(setq org-todo-keyword-faces (append  org-todo-keyword-faces '(
                                                    ("CRNT" :foreground "orange" :weight bold)
                                                    ("CNCD" . +org-todo-cancel)
                                                    ("POST" . +org-todo-cancel)
                                                    ("BEST" . +org-todo-todo)
                                                    ("DISC" . +org-todo-done)
                                                    ("PROG" . +org-todo-onhold)
                                                    ))))

;; * matlab term
;; (workaround..)
;; (after! matlab
  (require 'term)
  ;; )

;; * Latex
(defun js/latex-reftex-reparse ()
  (interactive)
  ;; (let ((current-prefix-arg 16)) (call-interactively 'org-latex-preview))
  (reftex-reparse-document))


;; * doc-view
(map! :map doc-view-mode-map
      :n "M-n" #'doc-view-next-page
      :n "M-p" #'doc-view-previous-page)

(add-hook 'doc-view-mode-hook
  (lambda ()
    ;; (define-key evil-normal-state-local-map "<right>" #'doc-view-next-page)
    ;; (define-key evil-normal-state-local-map "<left>" #'doc-view-previous-page)
    (define-key evil-normal-state-local-map "j" #'doc-view-next-page)
    (define-key evil-normal-state-local-map "k" #'doc-view-previous-page)
    (define-key evil-normal-state-local-map "n" #'doc-view-next-page)
    (define-key evil-normal-state-local-map "p" #'doc-view-previous-page)
    (define-key evil-normal-state-local-map "l" #'doc-view-next-page)
    (define-key evil-normal-state-local-map "h" #'doc-view-previous-page)))


;; * fu-spell

;; ** [not working] disable for all = default
;; (global-spell-fu-mode -1)

;; ** disable for certain modes
(add-hook 'org-mode-hook
     (lambda () (spell-fu-mode -1)))


;; * repeat command shortcut
(map! :leader
      :desc "repeat last command" "z" #'repeat-complex-command)

;; * workaround -> add ~/$HOME/bin to PATH (i think this is only necessary when doom envvar file is used, maybe not necessary when turned off)
(setenv "PATH" (concat (substitute-in-file-name "$HOME/bin")
                       ":"
                       (getenv "PATH")))



;; * EIN jupyter notebooks
;; ** inline images
(map! :leader
      "oe" #'ein:run
      "oE" #'ein:stop)
;; from reddit user
;; (after! ein
(defun js/ein-quirk-init ()
  "subsitute this later with (after! ein [...]) which still does not work"
  (interactive)

(setq ein:worksheet-enable-undo t); very useful to undo a change
(setq ein:output-area-inlined-images t); this one outputs the images directly in the emacs buffer, for me it's the perfect behaviour since I don't wand to switch programs to see the outputs of my matplotlib functions and stuff.
                           ;       for the emacs experience inline plotting :

;; mpl.rcParams["figure.facecolor"] = "white"
;; mpl.rcParams["axes.facecolor"] = "white"
;; mpl.rcParams["savefig.facecolor"] = "white"

;; This is if you are like me using a dark/black theme in emacs and plotting stuff with matplotlib, you will maybe have some _issues_ because the background will be inivisble, wo this snippet just forces all matplotlib outputs to be white.

;;     To automatically reload your custom libraries:

;; ​

;; %load_ext autoreload
;; %autoreload 2

;; this is more a jupyter tip, this auto reloads your custom modules, if you make changes in them, without having to reload the whole notebook.

;;     Remember to save the notebook regularly ! there is no autosave here.
;;     all my keybindings (very ugly code, I was planning to update it soon haha, but it's working). The real strengh of ein for me is the ability to control the WHOLE notebook from your text editor, so instead of scrolling with your mouse for hours to go back on the top of your notebook in JupyterLab, here in few keybindins you can jump anywhere haha. I also need to mention that I am an Evil user.

;; ​
;;
(map! :leader
      :map ein:notebook-mode-map
      :n "fs" #'ein:notebook-save-notebook-command-km
      )
(map! :map ein:notebook-mode-map
      ;; na klar:
      ;; wir haben local leader doch mit z und g!!
      ;; go up cell g-k
      ;; copy cell z-y
      ;; paste cell z-p
      ;; kill cell z-d
      ;; move/promote cells C-hjkl like org mode
      ;;
      ;;
       :n "zs" #'ein:notebook-save-notebook-command-km
       ;; :n "zy" #'ein:worksheet-copy-cell-km
       :n "zy" #'ein:worksheet-copy-cell ;; did work out for multiple cells
       :n "zp" #'ein:worksheet-yank-cell-km
       ;; :n "zd" #'ein:worksheet-kill-cell-km ;; did work out for multiple cells
       :n "zd" #'ein:worksheet-kill-cell
       :n "zb" #'ein:worksheet-insert-cell-below-km
       :n "za" #'ein:worksheet-insert-cell-above-km
       ;; :n "C-h" #'ein:notebook-worksheet-open-prev-or-last-km
       :n "gj" #'ein:worksheet-goto-next-input-km
       :n "gk" #'ein:worksheet-goto-prev-input-km
       :n "g;" #'ein:pytools-jump-back-command
       ;; :n "C-l" #'ein:notebook-worksheet-open-next-or-first-km
       ;; :n "M-H" #'ein:notebook-worksheet-move-prev-km
       :n "zj" #'ein:worksheet-move-cell-down-km
       :n "zk" #'ein:worksheet-move-cell-up-km
       ;; :n "M-L" #'ein:notebook-worksheet-move-next-km
       ;; :n "??" #'ein:worksheet-toggle-output-km
       :n "zt" #'ein:worksheet-toggle-cell-type-km
       ;; :n  "R" #'ein:worksheet-rename-sheet-km
       ;; :n  #'ein:worksheet-execute-cell-and-goto-next-km
       ;; :n "C-c x"#'ein:worksheet-clear-output-km
       ;; :n "C-c X"#'ein:worksheet-clear-all-output-km
       ;; :n "C-o" #'ein:console-open-km
       ;; :n "C-K" #'ein:worksheet-merge-cell-km
       ;; :n "C-J" #'spacemacs/ein:worksheet-merge-cell-next-km
       ;; :n "M-s" #'ein:worksheet-split-cell-at-point-km
       ;; :n "C-s" #'ein:notebook-save-notebook-command-km
       ;; :n "C-r" #'ein:notebook-rename-command-km
       ;; :n "M-1" #'ein:notebook-worksheet-open-1th-km
       ;; :n "M-2" #'ein:notebook-worksheet-open-2th-km
       ;; :n "M-3" #'ein:notebook-worksheet-open-3th-km
       ;; :n "M-4" #'ein:notebook-worksheet-open-4th-km
       ;; :n "M-5" #'ein:notebook-worksheet-open-5th-km
       ;; :n "M-6" #'ein:notebook-worksheet-open-6th-km
       ;; :n "M-7" #'ein:notebook-worksheet-open-7th-km
       ;; :n "M-8" #'ein:notebook-worksheet-open-8th-km
       ;; :n "M-9" #'ein:notebook-worksheet-open-last-km
       ;; :n  "+" #'ein:notebook-worksheet-insert-next-km
       ;; :n  "-" #'ein:notebook-worksheet-delete-km
       ;; :n "M-X" #'ein:notebook-close-km
       ;; :n "M-u" #'ein:worksheet-change-cell-type-km
       ;; :n "M-S" #'ein:notebook-save-notebook-command-km
       ;; :n "C-c q" #'ein:notebook-kernel-interrupt-command-km
       ;; :n "M-9" #'ein:notebook-worksheet-open-last-km
       ;; :n   "+" #'ein:notebook-worksheet-insert-next-km
       ;; :n   "-" #'ein:notebook-worksheet-delete-km
       ;; :n "M-X" #'ein:notebook-close-km
       ;; :n "M-u" #'ein:worksheet-change-cell-type-km
       ;; :n "M-S" #'ein:notebook-save-notebook-command-km
       ;; :n "C-c c" #'ein:worksheet-execute-cell-and-goto-next-km
       ;; :n "C-c a" #'ein:worksheet-execute-all-cell-km
       ;; :n "C-c q" #'ein:notebook-kernel-interrupt-command-km
       :n "zl" #'org-latex-preview
)


(map! :map ein:notebook-mode-map
      :leader
      :desc "execute cell" "cc" #'ein:worksheet-execute-cell-km
      :desc "execute cell" "cC" #'ein:worksheet-execute-all-cells
      :desc "execute cell" "cA" #'ein:worksheet-execute-all-cells-above
      :desc "execute cell" "cB" #'ein:worksheet-execute-all-cells-below
      :desc "execute cell" "cx" #'ein:worksheet-execute-cell-and-goto-next-km
      )
;; But yeah, even if I really prefer editing my notebooks on ein than on my browser, I do see also some negative aspects and drawbacks:

;;     I don't have autocompletion. It's not a big deal, but I really appreciate also having LSP mode helping me when I'm editing regular python scripts.
;;     It's a little buggy. Like not really problematic once you know where are the problems, but they are here. Among them there is :

;;     Having to press <ESC> every time I open a notebook to have my keybindings working
;;     Unable to delete the last line of the cell using dd (Evil command) this issue
;;     Can sometime (with HUUGE notebooks) hangs for quite some time, and also crash
;;
(defun js/ein:open-notebook-in-browser-with-jupyter-notebook ()
  (interactive)
  ())

(defun js/buffer-name-to-clipboard ()
  (interactive)
  (setq this-buffer-name (buffer-name))
  (message (concat "copied to clipboard (buffer name): " this-buffer-name))
  (kill-new this-buffer-name))
)


;; * yank - overwrite - stuff
;; in some situations i wanna just overwrite what's "under the yank"
;;
;; this for rectangle yank:
;; (put 'yank-rectangle 'delete-selection 'yank)
;; (put 'yank-rectangle 'delete-selection 'yank)
(defun js/yank-replace ()
  (interactive)
  (delete-char (length (current-kill 0)))
  (yank)
  )

;; copy region and leave blank spaces
;; (defun js/cut-blank ()
;;   (interactive)
;;   (delete-char (length (current-kill 0)))
;;   (yank)
;;   )

(map! "M-P" #'js/yank-replace)

;; * flycheck , disable for c++
(setq flycheck-global-modes nil)
;; (add-hook! 'c++-mode
;;   (lambda () (flycheck-mode -1))

;; * test
;; (defun test ()
;;   (interactive)
;;   (setq buf1 ())
;;   )
