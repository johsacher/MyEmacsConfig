
;; * TODOs
;; ** better mode-line color inactive window light-grey (?), active --> black??
;; ** combine org/headline with major-mode in programming-language --> fold/unfold capability sections / short-cuts new-heading / sub-heading etc.

;; * debug on start-up
(setq debug-only-on-start-up t)
(if debug-only-on-start-up
  (setq debug-on-error t)
  )

;; * machine distinction mechanism (server-/local-machines)
;; * get machine, we re on
(setq myhost (getenv "MYHOST"))
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
(require 'use-package)
;; ** quelpa-usapackage -> enables you to update source of package from github and recompile on the fly by adding ":quelpa" key-word to use-package:  "(use-package <package-name> :quelpa <other stuff>)
;; (setq myhost (getenv "MYHOST"))
;; (cond 
;;  ((equal myhost "phone") (message "on phone -> quelpa not set"))
;;  (t (progn
;; (quelpa
;;  '(quelpa-use-package
;;    :fetcher git
;;    :url "https://github.com/quelpa/quelpa-use-package.git"))
;; (require 'quelpa-use-package)
;; )))

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
(message system-name)
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


;;; * GENERAL SETTINGS

;; * detect machine name
(defvar machine-name)  
(cond
  ((equal system-name "johannes-ThinkPad-L380-Yoga")
   (setq machine-name "laptop")
   )
  (t
   (setq machine-name "unknown")
   )
  )


;; ** suppress "spamy" auto-revert messages
(setq auto-revert-verbose nil)

;; ** title (play around -> tribute to emacs)
(setq frame-title-format '("I ❤ Emacs I ❤ Emacs I ❤ Emacs I ❤ Emacs I ❤ Emacs ❤ I"))

; ** global line number mode on
(global-display-line-numbers-mode)
; ** scroll bar off
(if (display-graphic-p)
    (scroll-bar-mode -1) 
  )
;; ** tool bar off
(tool-bar-mode -1)

;; ** menu bar off
(menu-bar-mode -1)

;; ** highlight corresponding parenthesis
(show-paren-mode t)

;; ** rainbow delimiters
(require 'rainbow-delimiters)
(rainbow-delimiters-mode t)

;;; * )  my packages ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;-----------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; * gsyn dependency
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
  (setq current-git-top-level-absolute-path (gsyn-find-main-git-directory-of-current-file))
  (setq command-string (concat "gsyn " current-git-top-level-absolute-path))
  (message (concat "git-synchronization launched ... (executed: " command-string ")"))
  (async-shell-command command-string))

(evil-leader/set-key ":" 'gsyn)

;;;+) MELPA packages - make them available (some very good additional package list)
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line


;;; * evil - load/ general
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
;;; use alternative for ESC
(require 'key-chord)
(key-chord-mode 1)

(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
(key-chord-define evil-visual-state-map "jk" 'evil-normal-state)
(key-chord-define evil-replace-state-map "jk" 'evil-normal-state)

(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
;; (key-chord-define evil-visual-state-map "jj" 'evil-normal-state) # this has nasty effect, commented out
(key-chord-define evil-replace-state-map "jj" 'evil-normal-state)

;; ** search string under visual selection (commonly used also by vimmers) 
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
  (defun kill-this-buffer-no-prompt () (interactive) (kill-buffer nil))
  (evil-leader/set-key "k" 'kill-this-buffer-no-prompt)
  (evil-leader/set-key "s" 'save-buffer) 
  (evil-leader/set-key "f" 'helm-find) 
  (evil-leader/set-key "d" 'dired-go-current-buffer) 
  (evil-leader/set-key "g" 'helm-swoop) ; only dired -> helm-rg ( ack / ag / rg --> ag did not work , rg works (if installed)
  ;; (evil-leader/set-key "p" 'helm-projectile-find-file) ;; -> "p" ssh-clipboard-paste, defined there
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


;; * drag-stuff (evilized)
;; ( this is already a bit "tweaking" of evil mode )
(define-key evil-normal-state-map (kbd "C-j") 'drag-stuff-down)
(define-key evil-normal-state-map (kbd "C-k") 'drag-stuff-up)
(define-key evil-normal-state-map (kbd "C-h") 'drag-stuff-left)
(define-key evil-normal-state-map (kbd "C-l") 'drag-stuff-right)

;; * planet-mode (my org extension)
(load (concat my_load_path "planet/planet.el"))

;; ** save git mode default 
(planet-git-save-turn-on)

          
;; ** default initial view (levels)
(add-hook 'planet-mode-hook
         (lambda ()
           ;; (outline-show-all)
           ))
(defun org-show-3-levels ()
  (interactive)
  (org-content 3))
(add-hook 'org-mode-hook
  (lambda ()
    (define-key org-mode-map "\C-cm" 'org-show-two-levels)))

;;


;;; * elisp mode
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (auto-complete-mode)
            (rainbow-delimiters-mode t)
            ))
;; ** debugging
;; *** comments: two options in emacs: debug (old) ;  edebug -> better, interactive, "matlab-like", just a 'little overhead' --> need to perform 'instrumentalization' before every debugging...
;; *** --> just hit 'SPC-/'
;; *** more convenient short-cut for instrumentalize function: than "C-u C-M-x"!
(evil-leader/set-key-for-mode 'emacs-lisp-mode "/" 'instrumentalize-fun) 
(defun instrumentalize-fun ()
  (interactive)
  ;; (edebug-eval-defun t)
  (eval-defun t) ;; argument can be any --> effect is to instrumentalize for edebug
  )
;;; *** 
(evil-define-key 'normal edebug-mode-map (kbd "n") 'edebug-next-mode)
(evil-define-key 'normal edebug-mode-map (kbd "F10") 'edebug-next-mode)

(evil-define-key 'normal edebug-mode-map (kbd "q") 'top-level)
(evil-define-key 'normal edebug-mode-map (kbd "F8") 'top-level)

;;; * bash (=shell-script-mode)
(add-hook 'shell-script-mode-hook
          (lambda ()
            (auto-complete-mode)
            (rainbow-delimiters-mode t)
            ))

;;; * c++
(add-hook 'c++-mode-hook
          (lambda ()
            (auto-complete-mode)
            (rainbow-delimiters-mode t)
            ))

;;; * python
(add-hook 'python-mode-hook
          (lambda ()
            (auto-complete-mode)
            (rainbow-delimiters-mode t)
            ))

(autoload 'pylint "pylint")
(add-hook 'python-mode-hook 'pylint-add-menu-items)
(add-hook 'python-mode-hook 'pylint-add-key-bindings)

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
  )
;; SET BREAKPOINT <F12>
(require 'python)
(define-key python-mode-map
  (kbd "<f12>") 'python-set-break-point-current-line)


;;; * english-german-translator
(defvar english-german-translator-buffer-name "*english-german-translator*")


(defun english-german-translator-init ()
  (interactive)
  "currently: Start eww-buffer with dict.cc in a new buffer."
  (interactive)
  (eww "dict.cc")
  (rename-buffer english-german-translator-buffer-name)
  (english-german-translator-move-point-to-input-field)
  )

(defun get-point-position ()
  (interactive)
  (setq current_pos (point))
  (message current_pos)
  current_pos)

(defun english-german-translator-move-point-to-input-field ()
  (interactive)
  (goto-char 332)
  )

(defun english-german-translator ()
  (interactive)
  ;; initiate if not already exists
  (if (not (get-buffer english-german-translator-buffer-name))
      (english-german-translator-init)
      )
  ;; switch to that buffer
  (switch-to-buffer english-german-translator-buffer-name)
  (english-german-translator-move-point-to-input-field)
  ;; (switch-to-buffer english-german-translator-buffer-name)
  ;; (english-german-translator-move-point-to-input-field)
  ;; (switch-to-buffer english-german-translator-buffer-name)
  ;; (english-german-translator-move-point-to-input-field)
  ;; (switch-to-buffer english-german-translator-buffer-name)
  ;; (english-german-translator-move-point-to-input-field)
  )

;;; * ipython-calculator (my)
;; todo: if not exists --> create ansi-term (non-sticky), enter ipython, and rename *ipython-calculator*
(defvar ipython-calculator-buffer-name "*ipython-calculator*")

(defun ipython-calculator-init ()
  (interactive)
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


  ;; * execute ipython
  (comint-send-string ipython-calculator-buffer-name "ipython\n")
  )


(defun ipython-calculator ()
  (interactive)
  ;; initiate if not already exists
  (if (not (get-buffer ipython-calculator-buffer-name))
      (ipython-calculator-init)
      )
  ;; switch to that buffer
  (switch-to-buffer ipython-calculator-buffer-name)
  )

(evil-leader/set-key "a" 'ipython-calculator) 

(defvar python-calculator-mode-map
  (let ((m (make-sparse-keymap))) ;; i think this achieves a "local key binding" for the buffer
    (define-key m (kbd "M-p") 'term-send-up)
    m))

(define-minor-mode python-calculator-mode
  :initial-value nil
  :lighter " py-calc"
  :keymap python-calculator-mode-map
  :group 'python-calculator
  :global nil)

;;; * org-mode

;; make sure we have the latest package of org
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

;; ** fix TAB -> org-cycle for android phone
(evil-define-key 'normal org-mode-map (kbd "TAB") 'org-cycle)

;; ** redisplay inline images comfy key
(evil-leader/set-key "or" 'org-redisplay-inline-images)

;; ** always redisplay inline images after ctrl-c-ctrl-c
(advice-add 'org-ctrl-c-ctrl-c :after 'org-redisplay-inline-images)

;; ** org bullets
(require 'org-bullets)
(add-hook 'org-mode-hook
          (lambda nil (org-bullets-mode 1)))
(setq org-bullets-bullet-list
  '(;;; Large
    "◉"
    ;;""
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

;; ** disable line-numbers
 (add-hook 'org-mode-hook
           (lambda nil (display-line-numbers-mode -1)))

 (add-hook 'org-mode-hook
           (lambda nil
             (org-bullets-mode 1)
             ))
(require 'org-install)

;; ** clock in/out settings 
;; *** change todo state "CLOCKED IN..." / "", for clocked in headings
(defvar org-todo-state-on-clock-in-saved)
(setq org-todo-state-on-clock-in-saved "")
(add-hook 'org-clock-in-hook
         (lambda ()
           ;; save old state (in global variable)
           (setq org-todo-state-on-clock-in-saved (org-get-todo-state))
           (org-todo "CLOCKED IN...")
          ))

(add-hook 'org-clock-out-hook
         (lambda ()
           (org-set-todo-state-before-clocked)
           (message "my org clock out:")
           (message (concat "current todo state: " (org-get-todo-state))) 
           (message (concat "old/new todo state:" org-todo-state-on-clock-in-saved))
          ))

(defun org-set-todo-state-before-clocked ()
  (interactive)
  (org-todo org-todo-state-on-clock-in-saved)
  )

(defun org-get-todo-state ()
  (interactive)
  (setq components (org-heading-components))
  ;; (message (nth 2 components))
  (setq todo-state (nth 2 components))
  todo-state)

(defun org-print-todo-state ()
  (interactive)
  (setq components (org-heading-components))
  (setq todo-state (nth 2 components))
  (message (concat "current todo state: " todo-state))
  )

;; ** show distribution of clocked time per tag
(require 'org-table)
(require 'org-clock)

(defun clocktable-by-tag/shift-cell (n)
  (let ((str ""))
    (dotimes (i n)
      (setq str (concat str "| ")))
    str))

(defun clocktable-by-tag/insert-tag (params)
  (let ((tag (plist-get params :tags)))
    (insert "|--\n")
    (insert (format "| %s | *Tag time* |\n" tag))
    (let ((total 0))
  (mapcar
       (lambda (file)
     (let ((clock-data (with-current-buffer (find-file-noselect file)
                 (org-clock-get-table-data (buffer-name) params))))
       (when (> (nth 1 clock-data) 0)
         (setq total (+ total (nth 1 clock-data)))
         (insert (format "| | File *%s* | %.2f |\n"
                 (file-name-nondirectory file)
                 (/ (nth 1 clock-data) 60.0)))
         (dolist (entry (nth 2 clock-data))
           (insert (format "| | . %s%s | %s %.2f |\n"
                   (org-clocktable-indent-string (nth 0 entry))
                   (nth 1 entry)
                   (clocktable-by-tag/shift-cell (nth 0 entry))
                   (/ (nth 3 entry) 60.0)))))))
       (org-agenda-files))
      (save-excursion
    (re-search-backward "*Tag time*")
    (org-table-next-field)
    (org-table-blank-field)
    (insert (format "*%.2f*" (/ total 60.0)))))
    (org-table-align)))

(defun org-dblock-write:clocktable-by-tag (params)
  (insert "| Tag | Headline | Time (h) |\n")
  (insert "|     |          | <r>  |\n")
  (let ((tags (plist-get params :tags)))
    (mapcar (lambda (tag)
          (setq params (plist-put params :tags tag))
          (clocktable-by-tag/insert-tag params))
        tags)))

(provide 'clocktable-by-tag)

;; ** links in org-mode
;; *** copy url to clipboard and stuff
;; --> best way -> just M-x org-toggle-link-display , and copy url with evil "yi]"

;; ** evaluate code snippets in org
;; *** don t confirm every time
(setq org-confirm-babel-evaluate nil)
;; *** add languages: C++/C
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (C . t);; This enables Babel to process C, C++ and D source blocks.
   (python . t);; 
   (matlab . t);; 
   (latex . t);; 
   (emacs-lisp . t);; 
   (shell . t);; (sh . t) does not work (docum. faulty)
   ) 
 )

;; *** add quick-templates (<s <TAB> / 
;; delete all that crap and do my own
;; add c++
(setq org-structure-template-alist nil)
;; (add-to-list 'org-structure-template-alist '("s" "#+BEGIN_SRC\n?\n#+END_SRC")) ;; default
(add-to-list 'org-structure-template-alist '("s" "#+begin_src\n?\n#+end_src")) ;; default
(add-to-list 'org-structure-template-alist '("c" "#+begin_src C++\n?\n#+end_src")) ;; c++
(add-to-list 'org-structure-template-alist '("C" "#+begin_src C\n?\n#+end_src")) ;; C
(add-to-list 'org-structure-template-alist '("p" "#+begin_src python\n?\n#+end_src")) ;; python
(add-to-list 'org-structure-template-alist '("b" "#+begin_src bash\n?\n#+end_src")) ;; bash
;; default content of org-structure-template-alist:
;; (
;; ("s" "#+BEGIN_SRC ?
;; #+END_SRC") ("e" "#+BEGIN_EXAMPLE
;; ?
;; #+END_EXAMPLE") ("q" "#+BEGIN_QUOTE
;; ?
;; #+END_QUOTE") ("v" "#+BEGIN_VERSE
;; ?
;; #+END_VERSE") ("V" "#+BEGIN_VERBATIM
;; ?
;; #+END_VERBATIM") ("c" "#+BEGIN_CENTER
;; ?
;; #+END_CENTER") ("C" "#+BEGIN_COMMENT
;; ?
;; #+END_COMMENT") ("l" "#+BEGIN_EXPORT latex
;; ?
;; #+END_EXPORT") ("L" "#+LaTeX: ") ("h" "#+BEGIN_EXPORT html
;; ?
;; #+END_EXPORT") ("H" "#+HTML: ") ("a" "#+BEGIN_EXPORT ascii
;; ?
;; #+END_EXPORT") ("A" "#+ASCII: ") ("i" "#+INDEX: ?") ("I" "#+INCLUDE: %file ?"))

;; ** org-mode toggle bold/italic
(defun org-toggle-bold-region ()
  (interactive)
  (my-toggle-marker-around-region "*" "\*"  "*" "\*")
  )

(defun org-toggle-red-region ()
  (interactive)
  (my-toggle-marker-around-region "=" "="  "=" "=")
  )

(defun org-toggle-underlined-region ()
  (interactive)
  (my-toggle-marker-around-region "_" "_"  "_" "_")
  )
(defun org-toggle-italic-region ()
  (interactive)
  (my-toggle-marker-around-region "/" "\/" "/" "\/")
  )
;; todo: rethink these, already reserverd for other stuff
;; (evil-leader/set-key "ob" 'org-toggle-bold-region)
;; (evil-leader/set-key "oi" 'org-toggle-italic-region)
;; (evil-leader/set-key "or" 'org-toggle-red-region)

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

;; ** org latex export (settings and tweaks)

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

;; *** (? check) enable enumerations with a./b./c.
(setq org-list-allow-alphabetical t)

;; *** org-ref (--> citation management & pdflatex export)
(use-package org-ref
   :ensure t)
;; *** org export --> has to run bibtex also
(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))

(setq org-latex-prefer-user-labels t)

;; *** my latex pdf export with hooked command from option #+export_pdf_hook (short-cut to f5) 
;;   (wrote this for automatic syncing on compilation in first place
;;   like so: #+export_pdf_hook: rclone sync {} googledrive:ExistenzGruendungSacherFlitz)
(defun org-export-latex-pdf-with-hook ()
  (interactive)
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
(define-key org-mode-map (kbd "<f5>") 'org-export-latex-pdf-with-hook)  

;; ** evil org
(require 'evil-org)
(setq org-M-RET-may-split-line nil)

;;; ** make tab key work as org-cycle in terminal
(evil-define-key 'normal evil-jumper-mode-map (kbd "TAB") nil)

(add-hook 'org-mode-hook
          (lambda ()
            (org-indent-mode)
            (visual-line-mode)))


;; ** paste image from clipboard in org-mode
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
   ;; * determine filename
   (if (not filebasename)
       (setq filebasename (read-string "Org-file-name (without .org-extension):"))
     )

   ;; * path
   (if (not path) ;; default --> put to current path
        (setq path (get-current-path))
     )
   ;; (if not already exists) create the hidden (dotted) folder with same name of org file
     (setq new-directory-full-name (concat (file-name-as-directory path) "." filebasename ".org"))
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

;; ** default LATEX_HEADER

;; *** allow bindings to work "#BIND+ ..."
(setq org-export-allow-bind-keywords t)
;; (not code, just doc here)

;; #+title: <title>
;; #
;; # options:
;; #+options: num:t
;; #+options: toc:t
;; #+options: H:2
;; #
;; # itemize all bullets
;; #+LATEX_HEADER: \renewcommand{\labelitemi}{$\bullet$}
;; #+LATEX_HEADER: \renewcommand{\labelitemii}{$\bullet$}
;; #+LATEX_HEADER: \renewcommand{\labelitemiii}{$\bullet$}
;; #+LATEX_HEADER: \renewcommand{\labelitemiv}{$\bullet$}

;; #+BIND: org-latex-image-default-width ".98\\linewidth"
;; # or
;; #+BIND: org-latex-image-default-width "9cm"

;; # other export language (mind "for technical reasons" has to be first english than ngerman, otherwise english, whyever.. latex-"bug")
;; #+LATEX_HEADER: \usepackage[english, ngerman]{babel}


;; ** make sure emacs visits the target of a link (otherwise currentpath is wrong -> problem with pasting images)
(setq find-file-visit-truename t)

;; org-mode inline images appearance
(setq org-image-actual-width 300) ;; --> makes images more readable, for closer look, just open in image viewer

;; ** org mode startup appearance
;; *** org mode pretty entities (arrows and stuff)
;; (setq org-pretty-entities t)
(setq org-pretty-entities nil)
;; *** show inline images 
(setq org-startup-with-inline-images t)

;; ** emphasis markers -> outcommented -> decided to not mess around with that, since this belongs to org-mode convention!
;; --> need another solution to highlight important text with background (red/green/etc.) -> todo
;; (setq org-hide-emphasis-markers t)                            
;; (setq org-emphasis-alist   
;; (quote (("*" bold)
;; ("/" italic)
;; ("_" underline)
;; ("=" (:foreground "white" :background "red"))
;; ("|" (:foreground "white" :background "green"))
;; ("!" (:foreground "white" :background "green"))
;; ("&" (:foreground "white" :background "green"))
;; ("\\" (:foreground "white" :background "green"))
;; ("°" (:foreground "white" :background "green"))
;; (">" (:foreground "white" :background "green"))
;; ("?" (:foreground "white" :background "green"))
;; ("€" (:foreground "white" :background "green"))
;; ("~" org-verbatim verbatim)
;; ("+"
;; (:strike-through t))
;; )))
;; ( org-set-emph-re) 

;; ** add some new labels
(setq org-todo-keywords
      '((sequence
         "DONE"
         "CANCELLED"
         "DEFERRED"
         "ANSWERED"
         "QUESTION"
         "DONEBEFORE"
         "NEXTDAY"
         "BESTCHOICE"
         "DISCARDED"
         "PROGRESS..."
         "CLOCKED IN..."
         "CURRENT..."
         "WAITING"
         "TODO"
         )))

  (setq org-todo-keyword-faces
    '(("PROJ" :background "blue" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("TODO" :background "red1" :foreground "white" :weight bold :box (:line-width 2 :style released-button))
      ("QUESTION" :background "orange" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("NEXT" :background "red1" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("CURRENT..." :background "orange" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("CLOCKED IN..." :background "orange" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("DISCARDED" :background "grey" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("WAITING" :background "yellow" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("PROGRESS..." :background "yellow" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("DEFERRED" :background "green" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("DONEBEFORE" :background "grey" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("NEXTDAY" :background "pink" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("DELEGATED" :background "gold" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("MAYBE" :background "gray" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("APPT" :background "red1" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("DONE" :background "forest green" :weight bold :box (:line-width 2 :style released-button))
      ("BESTCHOICE" :background "forest green" :weight bold :box (:line-width 2 :style released-button))
      ("ANSWERED" :background "forest green" :weight bold :box (:line-width 2 :style released-button))
      ("CANCELLED" :background "lime green" :foreground "black" :weight bold :box (:line-width 2 :style released-button))))

;; evil org-mode
;; (evil-leader/set-key-for-mode 'org-mode "l" 'org-preview-latex-fragment)
;; (evil-leader/set-key "l" 'org-preview-latex-fragment) 

;; ** basic behaviour - new headings
(defun myorg-new-heading-enter-insert-state ()
  (interactive)
  (org-insert-heading)
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

;; ** copy/paste - behavior
(evil-define-key 'insert org-mode-map (kbd "C-p") 'evil-paste-after)
;; ** basic navigation, consistent evil
(evil-define-key 'normal org-mode-map (kbd "L") 'org-shiftright)
(evil-define-key 'normal org-mode-map (kbd "RET") 'myorg-new-heading-enter-insert-state)
(evil-define-key 'insert org-mode-map (kbd "M-RET") 'myorg-meta-return-enter-insert-state)
(evil-define-key 'normal org-mode-map (kbd "M-RET") 'myorg-meta-return-enter-insert-state)
(evil-define-key 'normal org-mode-map (kbd "H") 'org-shiftleft)
(evil-define-key 'normal org-mode-map (kbd "C-K") 'org-shiftup)
(evil-define-key 'normal org-mode-map (kbd "C-J") 'org-shiftdown) ;; leave "J" for joining lines

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

;;; * outshine mode (org-mode outlining in code-files)
;; TODOS:
;; ** still having multiple comment fields leads to problems, e.g. "### ** heading", at the moment he needs "# ** header" to work fully
;; ** still can t expand sublevels, when trailing white spaces
;; ** better colors
;;    i d like to keep regular code color, just add a little "sth", prepend and format the leading stars rather, or not at all. maybe just make code bold.
;; 
;; ** functions to format properly headings
;; *** "***heading" -> "*** heading"
 ;; " s/\(\*++\)\([^ *]\{1\}\)/; \1 \2/g")
;; *** "%%*" --> "%% *"
;; (setq myhost (getenv "MYHOST"))
;; (cond 
;;  ((equal myhost "phone") (message "on phone -> quelpa not set"))
;;  (t (progn
;;       (message "no phone")
;;       (use-package outshine
;; 	:quelpa (outshine :fetcher github :repo "alphapapa/outshine"))
;;       )))





(setq my-black "#1b1b1e")
;; (custom-theme-set-faces
;;  ;; you may have to get the color-theme-name right:
;;  'zenburn ; will not work when you change theme -> "unknown color theme error"
;;  `(outline-1 ((t (:height 1.25 :background "#268bd2"
;;                           :foreground ,my-black :weight bold))))
;;  `(outline-2 ((t (:height 1.15 :background "#2aa198"
;;                           :foreground ,my-black :weight bold))))
;;  `(outline-3 ((t (:height 1.05 :background "#b58900"
;;                           :foreground ,my-black :weight bold)))))

;;; * term / terminal / ansi-term
;; ** use my own term version: stickyterm (slightly modified ansi-term)
(require 'term) ;; stickyterm builds on /requires term (variables etc. -> load term before


;;
 (load "stickyterm.el")
 (global-set-key (kbd "<f12>") 'stickyterm-noninteractive)
(evil-leader/set-key "7" 'stickyterm-noninteractive)

(require 'term)
;; (if color-theme-buffer-local-switch
 (add-hook 'term-mode-hook
           (lambda nil (color-theme-buffer-local 'color-theme-dark-laptop (current-buffer))))
 ;; )

 (add-hook 'term-mode-hook
           (lambda nil (display-line-numbers-mode -1)))
;; ** Alt-p --> map to arrow-up always 
;; ( reason: ipython, I could n t achieve ipython remapping of "Alt-p"= "up", so I achieved it with this kind of workaround: the terminal-emulator / ipython "does not see" Alt-p coming, emacs will translate it to "up" before. so i get the desired behaviour and don t have to tediously use arrow keys)
;; IMPLICATION (!): all desired terminal behaviour on "Alt-p" has to be bound BOTH for (a) arrow up (so it ll work in emacs) and (b) also for "Alt-p" (i.e. .inputrc etc.), so I ll also get the behaviour outside emacs' term-mode, like normal shell.
 (evil-define-key 'emacs term-raw-map (kbd "M-p") 'term-send-up)
 (evil-define-key 'emacs term-raw-map (kbd "M-n") 'term-send-down)

;; ** short cut for term-paste
 (evil-define-key 'normal term-raw-map (kbd "p") 'term-paste)
 (evil-define-key 'normal term-raw-map (kbd "C-p") 'term-paste)
 (evil-define-key 'emacs term-raw-map (kbd "C-p") 'term-paste)
 (evil-define-key 'instert term-raw-map (kbd "C-p") 'term-paste)

;; ** switch only between (term char with emacs-state) and (term line with normal-state)
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
;; ** evil term
 (evil-define-key 'normal term-raw-map (kbd "RET") 'term-send-raw)
 (evil-define-key 'normal term-raw-map (kbd "h") 'term-send-left)
 (evil-define-key 'normal term-raw-map (kbd "l") 'term-send-right)
 (evil-define-key 'normal term-raw-map (kbd "k") 'term-send-up)
 (evil-define-key 'normal term-raw-map (kbd "j") 'term-send-down)
 (evil-define-key 'normal term-raw-map (kbd "x") 'term-send-del)

;; ** term color theme
;; (how did I get it from customization? -> customized in menue, then copied from custem.el ("custom-set-faces ...") and formatted 
(set-face-attribute 'term nil :background "black" :foreground "white")
;; (set-face-attribute 'term-color-back nil :background "black" :foreground "white")
;; (set-face-attribute 'term-bold nil :background "black")
(set-face-attribute 'term-color-white nil :background "black" :foreground "white")
(set-face-attribute 'term-color-blue nil :background "#5fafd7" :foreground "#5fafd7")
(set-face-attribute 'term-color-green nil :background "#a1db00" :foreground "#a1db00")


;; *** make initial state for term emacs-state
;; this did not work:
 ;; (add-hook 'term-mode-hook
           ;; (lambda nil (evil-emacs-state)))
;; this did work:
(evil-set-initial-state 'term-mode 'emacs)

;; ** tramp connection to hlrn (fast command)
;; *** still have problem that it hangs on "waiting for prompts from remote shell..." 
;; -> could not solve it, tried like this
;; (exec-path-from-shell-initialize)
;; (setq exec-path-from-shell-check-startup-files nil)
;; (setq exec-path-from-shell nil)
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

(evil-define-minor-mode-key 'normal 'iresize-mode (kbd "K") 'enlarge-window)
(evil-define-minor-mode-key 'normal 'iresize-mode (kbd "J") 'shrink-window)
(evil-define-minor-mode-key 'normal 'iresize-mode (kbd "L") 'enlarge-window-horizontally)
(evil-define-minor-mode-key 'normal 'iresize-mode (kbd "H") 'shrink-window-horizontally)
;; fast (double) resize
(evil-define-minor-mode-key 'normal 'iresize-mode (kbd "k") 'enlarge-window-4)
(evil-define-minor-mode-key 'normal 'iresize-mode (kbd "j") 'shrink-window-4)
(evil-define-minor-mode-key 'normal 'iresize-mode (kbd "l") 'enlarge-window-horizontally-4)
(evil-define-minor-mode-key 'normal 'iresize-mode (kbd "h") 'shrink-window-horizontally-4)

(defun shrink-window-horizontally-2 ()
  (interactive)
  (shrink-window-horizontally 2)
  )
(defun enlarge-window-horizontally-2 ()
  (interactive)
  (enlarge-window-horizontally 2)
  )
(defun shrink-window-2 ()
  (interactive)
  (shrink-window 2)
  )
(defun enlarge-window-2 ()
  (interactive)
  (enlarge-window 2)
  )

(defun shrink-window-horizontally-3 ()
  (interactive)
  (shrink-window-horizontally 3)
  )
(defun enlarge-window-horizontally-3 ()
  (interactive)
  (enlarge-window-horizontally 3)
  )
(defun shrink-window-3 ()
  (interactive)
  (shrink-window 3)
  )
(defun enlarge-window-3 ()
  (interactive)
  (enlarge-window 3)
  )

(defun shrink-window-horizontally-4 ()
  (interactive)
  (shrink-window-horizontally 4)
  )
(defun enlarge-window-horizontally-4 ()
  (interactive)
  (enlarge-window-horizontally 4)
  )
(defun shrink-window-4 ()
  (interactive)
  (shrink-window 4)
  )
(defun enlarge-window-4 ()
  (interactive)
  (enlarge-window 4)
  )

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



;;; * general COLOR THEMES ;;;;;;;;;;;;;
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

;; ** personal (general) customization of faces (comments light green, etc.)
(set-face-attribute 'font-lock-comment-face nil :foreground "light green")
(set-face-attribute 'font-lock-keyword-face nil :foreground "SkyBlue1" :weight 'bold)
(set-face-attribute 'font-lock-string-face nil :foreground "hot pink")


;; **
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



;;; * WINDOW / BUFFER NAVIGATION STUFF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ** copy/paste path between buffers (terminal/dired)
(load "copy-paste-paths.el")
(evil-add-hjkl-bindings dired-mode-map 'emacs) 
;; copy current path key bindings
(global-set-key (kbd "<f1>") 'copy-current-path)
(require 'dired)
(define-key dired-mode-map (kbd "<f1>") 'copy-current-path) 

(global-set-key (kbd "<f2>") 'change-dir-from-clipboard)
(define-key dired-mode-map (kbd "<f2>") 'change-dir-from-clipboard)

;; *** this got sooo usefull/frequent -> bind also to evil leader (prime positions spc-y/ spc-p )
(evil-leader/set-key "y" 'copy-current-path) ;; analogouns to y = vim yank
(evil-leader/set-key "p" 'change-dir-from-clipboard) ;; analogouns to p = vim yank

;; copy current filename (e.g. execute in matlab command window)
(global-set-key (kbd "<f9>") 'copy-current-file-name-no-extension)


;;; ** avy/ace jump 
(require 'avy)
(evil-leader/set-key "j" 'avy-goto-char-2) ;; 'avy-goto-char
(evil-leader/set-key "m" 'avy-goto-char) 

                
(setq dired-recursive-copies 'always)
(setq dired-dwim-target t) ;; do what i mean --> automatic "inteligent" copy location etc.

;;; * ) quickly move buffer to another window
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


;;; * dired

;; ** hide details by default
(add-hook 'dired-mode-hook
          (lambda ()
            (dired-hide-details-mode)
            (display-line-numbers-mode -1)
            (dired-sort-toggle-or-edit)))


;; ** dired omit files
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
;; ** add option to list directories first
;;(setq dired-listing-switches "-aBhl  --group-directories-first")

;; ** open in dired with external applications --> see '* open with external applications' (below)

;; ;;; * ) dired "options" (minor-modes)
;; ;;;--------------------------------------------
;; ;;    .) open recent directories
;; (global-set-key (kbd "C-x C-d") 'dired-recent-dirs-ivy-bjm) ;; see definition recent_dirs.el

;; ** create empty file ( = bash's touch)
(defun dired-create-new-empty-file ()
   (interactive)
   ;; create the hidden (dotted) folder with same name of org file
   (setq filename (read-string "file-name:"))
   (setq file-full-name (concat  (dired-current-directory) "/" filename))
   (with-temp-buffer (write-file file-full-name))
)

;; * helm-rg
(require 'helm-rg)
(setq helm-rg-default-extra-args '("--hidden"))
;; only makes sence in dired buffers, for others-> helm-soop
(evil-leader/set-key-for-mode 'dired-mode "g" 'helm-rg) ;
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

;; ** dired short cut s: go frequent places -> "go home" / "go $WORK" / bookmarks / etc.
(defun dired-go-home ()
  (interactive)
  (dired (substitute-in-file-name "$HOME"))
  )

(defun dired-go-work ()
  (interactive)
  (dired (substitute-in-file-name "$WORK"))
  )

(defun dired-go-fast ()
  (interactive)
  (dired (substitute-in-file-name "$FAST"))
  )

(evil-leader/set-key "hh" 'dired-go-home)
(evil-leader/set-key "hw" 'dired-go-work)
(evil-leader/set-key "hf" 'dired-go-fast) ;; for mathe-cluster
(defun dired-go-mucke ()
  (interactive)
  (dired (concat (substitute-in-file-name "$HOME") "/org/mucke/basking_project")))
  
(evil-leader/set-key "hm" 'dired-go-mucke)
(evil-leader/set-key "hb" 'helm-bookmarks)


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
 (define-key dired-mode-map (kbd "Y") 'dired-ranger-copy)
 (define-key dired-mode-map (kbd "X") 'dired-ranger-move)
 (define-key dired-mode-map (kbd "P") 'dired-ranger-paste)


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


;; * )  by hitting enter -> exit narrow-mode and enter file/dir
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

;; * open with external applications (in dired/ org-mode links / etc.)
(require 'openwith)
(openwith-mode t)
(setq openwith-associations '(
                              ("\\.xoj\\'" "xournal" (file))
                              ("\\.pdf\\'" "okular" (file))
                              ))

;;; * save desktop sessions
;;    (require 'session)
;;    (add-hook 'after-init-hook 'session-initialize)
;;(desktop-save-mode 1)


;; * sticky buffers (make possible for window to "stick" to its buffer)
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
;;       * dele
;;       ted the term.elc file (not sure if this was necessary)
;;       * renamed to mod_term.el and put to my load path (on dropbox)
;;       * --> this effectively overwrites the usual term.el
;;       * --> available for all my emacs computers



;;; * ) copy current buffer path clipboard
(defun cp-fullpath-of-current-buffer ()
  "copy full path into clipboard"
  (interactive)
  (when buffer-file-name
    (setq filepath (file-name-directory buffer-file-name))
    (kill-new  filepath)
    (message (concat "copied current file path: " filepath   ))))

;;; * ) ido-mode
;; (require 'ido)
    ;; (ido-mode t)


;; * helm
(require 'helm)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)

;; ** helm describe modes
(require 'helm-describe-modes)
(global-set-key [remap describe-mode] #'helm-describe-modes)
;; (setq helm-display-function 'helm-display-buffer-in-own-frame
;;         helm-display-buffer-reuse-frame nil
;;         helm-use-undecorated-frame-option nil)

;; ** helm window
;; *** option1 (full frame)
;; (setq helm-full-frame t)
;; (setq helm-autoresize-max-height 0)
;; (setq helm-autoresize-min-height 20)
;; (setq shackle-rules '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :ratio 0.4)))
;; (setq helm-buffer-max-length 70) ;; file name column width

;; *** option2 (half frame, show only current buffer aside)
;; (setq helm-split-window-in-side-p nil)
;; (helm-autoresize-mode t)
;; (setq helm-autoresize-max-height 50)
;; (setq helm-autoresize-min-height 50)
;; (setq shackle-rules '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :ratio 0.4)))
;; (setq helm-buffer-max-length 70) ;; file name column width

;; *** option3 (half frame, show all buffers aside, compressed)
(add-to-list 'display-buffer-alist
             '("\\`\\*helm"
               (display-buffer-in-side-window)
               (window-height . 0.4)))
(setq helm-display-function #'display-buffer)

;;; * projectile
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)
(setq projectile-indexing-method 'native)  
(setq projectile-enable-caching t) 
(setq helm-exit-idle-delay 0)


;;; * matlab



;;; ** Matlab matlab-emacs project;;
load-path
(setq path_to_matlab_emacs (concat my_load_path "matlab-emacs-src")) ;; the init file folder contains also all manual packages
(add-to-list 'load-path path_to_matlab_emacs)
(load-library "matlab-load")
(load-library "matlab")

(matlab-cedet-setup)

(add-hook 'matlab-mode-hook
          (lambda nil (auto-complete-mode)
            (rainbow-delimiters-mode t)
            ))

(add-hook 'M-shell-mode-hook
 	     (lambda nil (company-mode)))

;; ;; turn off auto-fill-mode
;; ;; (still does not work --> todo)

(add-hook 'matlab-mode-hook
 	     (lambda nil (auto-fill-mode -1)))

;; ** personal color theme manipulation
(set-face-attribute 'matlab-unterminated-string-face t :foreground "dark blue" :underline t)


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
    (matlab-shell-end-of-buffer) ;; scroll down always
)

(defun matlab-shell-end-of-buffer ()
  (interactive)
    ; get region into string
    ;; (save-excursion
      ;; (set-buffer (get-buffer-create "*MATLAB*")) 
      (setq current-buffer (buffer-name))
      (setq matlab-shell-window (get-buffer-window "*MATLAB*"))
      (save-excursion
        (set-buffer (get-buffer-create "*MATLAB*")) 
        (setq end-point-matlab-shell (point-max)))
      (set-window-point matlab-shell-window end-point-matlab-shell)
      ;; (switch-to-buffer "*MATLAB*")
      ;; (comint-send-input "")
      ;; (switch-to-buffer current-buffer)
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

(defun save-and-send-scriptname-to-matlab-shell-buffer-and-execute ()
  (interactive)
  (save-buffer)
  (send-scriptname-to-matlab-shell-buffer-and-execute)
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
(define-key matlab-mode-map (kbd "<f5>") 'save-and-send-scriptname-to-matlab-shell-buffer-and-execute)  

;; (define-key matlab-mode-map (kbd "<f9>") 'send-current-line-or-region-line-by-line-to-matlab-shell-buffer-and-execute)
;; DEBUG QUIT <F8>
(define-key matlab-mode-map (kbd "<f8>") 'matlab-dbquit)
;; CLEAR BREAK POINTS current file
(define-key matlab-mode-map (kbd "<f7>") 'matlab-dbclear-all)
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
            (define-key matlab-shell-mode-map (kbd "<f7>") 'matlab-dbclear-all)
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

;;; * recentf (recent files) 
(require 'recentf)
; Enable recentf mode
(recentf-mode t)
; Show last 200 files (with helm-interface no problem, i have easily 100+ files open and want to quickly access them in future session) 
(setq recentf-max-saved-items 200)
(setq recentf-max-menu-items 200)
; Reset C-x C-r to display recently opened files
(global-set-key "\C-x\ \C-r" 'recentf-open-files)


;;; * latex (auctex) 
;; somehow auctex does not load with (require 'auctex) (i don t like that and think the guys should do loading consistent with standard like other packages, but whatever..)
;; but auctex-manual instructs like this
(load "auctex.el" nil t t)
(load "latex.el" nil t t)
;;(load "preview-latex.el" nil t t)


;; ** hook latex with minor-outline-mode
(add-hook 'LaTeX-mode-hook 'outline-minor-mode)

(evil-define-minor-mode-key 'normal 'outline-minor-mode (kbd "TAB") 'org-cycle) ;; comment: org and outline go hand-in-hand, the org-function kind of "expand" the outline-functions, in pure outline-mode there is no toggling function

;; ** hook with TeX-fold-mode (the shit to hide figures/tables and stuff)
;;   (does not conflict with outline-minor-mode, yeah)
;;   usefull functions:
;;                     go to figure/table and M-x TeX-fold-env 
(add-hook 'LaTeX-mode-hook 'TeX-fold-mode)


;; ** F5 -> run pdflatex / F6 -> bibtex
(defun run-pdflatex-on-master-file ()
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

(define-key LaTeX-mode-map (kbd "<f5>") 'run-pdflatex-on-master-file)  
(define-key LaTeX-mode-map (kbd "<f6>") 'run-bibtex-on-master-file)  

(defun run-bibtex-on-master-file ()
"This function just runs LaTeX (pdflatex in case of TeX-PDF-mode), without asking what command to run everytime."
(interactive)
(TeX-command "BibTeX" 'TeX-master-file nil)
)


;;; ** how to view pdf (setq TeX-view-program-list '(("Okular" "okular --unique %u")))
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

;;; *** setup viewer (okular) with synref
;;;    how to use:
;;     (https://tex.stackexchange.com/questions/161797/how-to-configure-emacs-and-auctex-to-perform-forward-and-inverse-search)
;;;              go from emacs to okular ("forward search"): --> hit C-c C-v --> voila, okular opens exactly the position
;;;              go from okular to emacs ("inverse search"): (mind, only works with emacsclient/daemon)  --> Shift-MouseLeft on position
;;;     prerequisite - okular settings: simply: okular--> settings --> configure Okular --> Editor --> emacsclient 
(server-start)
(setq TeX-view-program-selection '((output-pdf "Okular")))
(setq TeX-source-correlate-mode t)

;; ** make more easy/natural to read
;; *** break lines naturally
(add-hook 'LaTeX-mode-hook 'visual-line-mode)  
;; *** (did not work out) show prose in block text, more easy/natural to read (--> auto-fill-mode)
;; (add-hook 'LaTeX-mode-hook 'auto-fill-mode)  

;;; ** reftex
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
(setq reftex-plug-into-AUCTeX t)
;;
(setq reftex-cite-format 'natbib)

(setq reftex-refstyle "\\autoref")

;;; ** aspell
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

;; ** misc settings
     (setq TeX-parse-self t) ; Enable parse on load.
     (setq TeX-auto-save t) ; Enable parse on save.
     (setq TeX-save-query nil) ; Dont ask if to save every time, just save and run LaTeX

;;(require 'tex-mik)
(setq TeX-PDF-mode t) ; pdf mode (for preview latex would need to be true, but preview latex currently not used)
	
(setq-default TeX-master nil) ; Query for master file.

;;; ** my latex-editing functions
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

;;; *** Insert quickly most popular environments by easy short cuts (ctrl-shift-<...>)
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

;; * misc
;; quickly add relative path of some file
(defun find-file-insert-relative-path ()
(interactive)
 (setq file-name (read-file-name "Select file: "))
(setq rel-path (file-relative-name file-name))
(insert rel-path)
)

;;; * c++

;; ** c++ -mode key bindings consistent (overwrite)
(define-key c++-mode-map "\M-k" 'windmove-up)
(define-key c++-mode-map "\M-h" 'windmove-left)
(define-key c++-mode-map "\M-l" 'windmove-right)
(define-key c++-mode-map "\M-j" 'windmove-down)


;;; * openfoam 
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

;;; ** shell workflow openfoam
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

;; ** open-foam-workflow tipps 

;; * zoom frame on smaller monitor
;;    status: no working solution, but no priority
;; (require 'zoom-frm)


;; * move buffers - key bindings
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

;; * mode-line appearance
;; set mode line to show full path of current file
;; (setq-default mode-line-format
;;    (list '((buffer-file-name " %f"
;;               (dired-directory
;;                dired-directory
;;                 (revert-buffer-function " %b"
;;                ("%b - Dir:  " default-directory))))))) 
;;; * ) set mode line appearance
;;;    (has to come AFTER  color themes, don t ask why)
;; don t ask why exactly, but the following (in order (!)) resulted nice in combi with zenburn
;; i.e.  .) modest visual difference of current buffer's mode line
;;       .) decent layout  
;;       .) harmonic colors with zenburn 
;; (require 'powerline)
;; (require 'smart-mode-line)
;; (sml/setup)
;; (setq sml/no-confirm-load-theme t) ;; avoid being asked "wanna compile theme in elisp" (or so..) everytime


;; * buffer/window navigation management
;; ** better short cuts for previous / next buffer
(global-set-key (kbd "M-'") 'previous-buffer)
(global-set-key (kbd "M-\\") 'next-buffer)

;;; * pdf-view
(require 'pdf-view)
 
 (setq pdf-info-epdfinfo-program "/usr/local/bin/epdfinfo")
 
 (setq pdf-view-midnight-colors `(,(face-attribute 'default :foreground) .
                                  ,(face-attribute 'default :background)))
 
 (add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode))
 
 (add-hook 'pdf-view-mode-hook (lambda ()
                                 (pdf-view-midnight-minor-mode)))
 
 (provide 'init-pdfview)


;;; * quickly print variable to scratch buffer
(defun print-var-to-scratch-buffer (var)
  (interactive)
  (with-current-buffer "*scratch*"
    (end-of-buffer)
    (insert (concat "\n\n" (prin1-to-string var)))
    )
  )

;; (defun dummy-fun (arg)
;;   (interactive)
;;   ;; ;; (message org-structure-template-alist)
;;   ;; (setq name_str "org-structure-template-alist")
;;   ;; (setq x (intern-soft name_str))
;;   ;; (message (symbol-value x))
;;   (message arg)
;;   )


(debug-on-entry 'print-value-of-var-under-selection-to-scratch-buffer)
(cancel-debug-on-entry 'print-value-of-var-under-selection-to-scratch-buffer)
(defun print-value-of-var-under-selection-to-scratch-buffer ()
  (interactive)
  ;; read the selection AS VARIABLE into var
  ;; (setq var (make-symbol "org-structure-template-alist"))
  (setq var_string (buffer-substring (region-beginning) (region-end)))
  (setq var (intern-soft var_string))
  ;; (print-var-to-scratch-buffer var)
  (setq symbolvalue (symbol-value var))
  (if (setq var (intern-soft var_string))
      (with-current-buffer "*scratch*"
        (end-of-buffer)
        ;; function "symbol-value" was necessary, otherwise not working (??? but ok)
        ;; (insert var) ;;--> not working even though it works when using the variable (symbol), e.g. x, directly like this (insert x))
        (insert (concat "\n\n value of variable '" var_string "':\n"))
        (insert (prin1-to-string symbolvalue))
       ;; (eval var_string)
        ;; https://stackoverflow.com/questions/4651274/convert-symbol-to-a-string-in-elisp
        )
    ;; else
    (message (concat "no such symbol exists with name: " var_string))
    )
  )


;; * git-save

;; (defun git-save ()
;;   (interactive)
;;   ;; * update

;;   )

;; * async-await (needed to be able to wait for "external" shell commands)
(use-package async-await
  :ensure t
  )

;; * async process behaviour
;; ** turn off 'pop-up' of the *Async Shell Command* buffer
(add-to-list 'display-buffer-alist
  (cons "\\*Async Shell Command\\*.*" (cons #'display-buffer-no-window nil)))


;; * stopwatch
;; (load (concat my_load_path "other_packages/stopwatch/stopwatch.el"))

;; * ssh clipboard
;; ** user settings
(defvar ssh-clipboard-file "~/ssh_clipboard.txt")

(defun ssh-clipboard-copy-string (str1) 
  (interactive)
  ;; ** copy current region -> into string
  (with-temp-file ssh-clipboard-file
    ;; (insert-file-contents file)
    ;; (not appending --> so outcommented)
    (insert str1))
    ;; "region copied to " ssh-clipboard-file "." ))
  (cond ((myhost-is-server)
         ;; (message "ssh-clipboard-copy: i m on myhost=mathe or hlrn")
         )
        ((myhost-is-local)
         ;; (message "ssh-clipboard-copy: i m on myhost=local")
         ;; * send it so ssh server
         (setq path1 ssh-clipboard-file)
         (message "sending (via rsync) ssh_clipboard.txt to all servers.")
         (dolist (this-server-name my-server-machine-names)
           (message (concat "sending ssh_clipboard.txt to server '" this-ssh-server-name "'..."))

           ;; * i tried various options to execute command (and let server resolve '~' aka home-path)
           ;; ** shell-command (problem: no asynchronous)
           ;; (setq path2 (concat this-ssh-server-name ":'~'/")) ;; without ' quotes -> for start-process (circumvents kind of the shell string processing, so it s what the command will get and it "does not want quotes".
           ;; (shell-command (concat "echo command will show like this in shell: " command-string))
           ;; (setq command-string (concat "rsync --progress -va -I " path1 " " path2 ))
           ;; (message (concat "executing command: '" command-string "' ..."))
           ;; (shell-command command-string)
           ;; ** async-shell-command (problem: complains about output-buffer, annoying)
           ;; (async-shell-command command-string)
           ;; ** start-process (problem: complains about output-buffer, annoying)
           ;; (async-shell-command command-string nil nil)
           ;; (setq output-buffer "foo")
           ;; ;;                                                     "arg-components start here", no need for spaces
           ;; ;;                                                        |
           ;; ;;                                                        V
           ;; (setq thisproc (start-process "process_name_dummy" output-buffer "rsync" "--progress" "-va" "-I" path1 path2))
           ;; 
           ;; ** start-process-shell-command (this worked!)
           (setq path2 (concat this-server-name ":'~'/")) 
           (setq command-string (concat "rsync --progress -va -I " path1 " " path2 ))
           ;; (setq output-buffer nil)
           (setq output-buffer "*ssh-clipboard-shell-ouptput*")
           (start-process-shell-command "process_name_dummy" output-buffer command-string)
           (message (concat "rsync'ed to ssh server (" this-server-name ")" ))))
        (t
         (message "myhost not set. set first: M-x set-myhost , or in shell with 'export MYHOST=mathe/hlrn/local/etc.'"))))



(defun ssh-clipboard-copy () 
  (interactive)
  ;; ** copy current region -> into string
  (setq current-region-string (buffer-substring (mark) (point)))
  (ssh-clipboard-copy-string current-region-string)
  (message (concat "region copied to " ssh-clipboard-file "." )))
         

(defun ssh-clipboard-paste ()
  (interactive)
  ;; if on local machine -> rsync ssh-clipboard from server first
  (cond
        ((myhost-is-server)
         ;; (message "ssh-clipboard-copy: i m on myhost=mathe or hlrn")
         )

        ((myhost-is-local)
         ;; (message "ssh-clipboard-copy: i m on myhost=local")
         ;; * send it so ssh server
         (setq path1 (concat "'" my-current-server-name ":~/ssh_clipboard.txt" "'")) ;; quote to make ~ convert to (correct) home only on server
         (setq path2 "~/")
         (setq command-string (concat "rsync --progress -va -I " path1 " " path2 ))
         (shell-command command-string)
         (message (concat "rsync'ed from ssh server (" my-current-server-name ")" )))
        (t
         (message "myhost not set. set first: M-x set-myhost , or in shell with 'export MYHOST=mathe/hlrn/laptop/phone/etc.'")))

  ;; * read content into string
  (with-temp-buffer
    (insert-file-contents ssh-clipboard-file)
    (setq ssh-clipboard-content (buffer-string)))
  ;; * paste content
  (insert ssh-clipboard-content))

(defun ssh-clipboard-copy-path ()
  (interactive)
 (setq currentpath (copy-current-path))
 (ssh-clipboard-copy-string currentpath)
 (message (concat "copied path to ssh-clipboard: "  currentpath))
 currentpath)

;; ** ssh-clipboard key bindings
(evil-leader/set-key "Y" 'ssh-clipboard-copy) ;; analogouns to y = vim yank
(evil-leader/set-key "P" 'ssh-clipboard-paste) ;; analogous to p = vim paste
;; (global-set-key (kbd "<f1>") 'copy-current-path)


;; * frequently used unicode characters
;; ** docu/instruction -> how to get the code of a character
;;    - copy the symbol (e.g. from browser) to an emacs buffer ;;    - type 'C-x =' (M-x what-cursor-position, or also M-x describe-char) , -> it will give you the unicode number in decimal/octal/hex
;;    - copy hex-code form minibuffer (e.g. for ↯ -> minibuffer: Char ↯ (8623, #o20657, #x21af, file, ... ) 
;;                                                                         ^        ^       ^
;;                                                                         |        |       |
;;                                                                       decimal  octal   hexadecimal
;;                                                                       (8623)   (20657   (21af)
;;                                                                                          ^^^^
;;                                                                                          ||||__ hex1
;;                                                                                          |||___ hex2
;;                                                                                          ||____ hex3
;;                                                                                          |_____ hex4
;;                                                                                        -> hex5/6/7/8 are "empty" or 0  --> full UTF-8 (4 bytes, 8 hex) number is 000021af  
;;
;;    - take the hex number (e.g. #x21af for "↯"), "fill up" with 0's until hex8 and prefix with "\U" -> "\U<hex8>...<hex2><hex1>, e.g. \U000021af"
;;    - (above works for *all* utf-8 symbols. but if you have an ascii, i.e. only two hex, i.e. 1 byte, e.g. #x61 for "a", you can also use "small" prefix "\u"  and only "fill up" 0's till hex4: "\u<hex4><hex3><hex2><hex1>", e.g. "\u0061")
;;    - how to print it with elisp?
;;      -- use hexadecimal value:  (insert "\u21af"), mind: always 4 chars, preceed with 0's e.g. for 'a' (61) --> (insert "\u0061")
;;      -- use decimal value: don t know...
;; ** background on unicode and UTF-8
;;    - utf-8 DOES not (generally) have 8 bits
;;    - it is a "variable-width character encoding" (wikipedia)
;;    - that means, it uses either 1 byte ( = 8 bits = *256 values* = *two hex* (16*16)) , or 2 bytes (16 bits), or 3 bytes(24 bits), or 4 bytes (32 bits). 
;;      -- 1 byte : 0xxxxxxx                             -> all 128 ascii characters
;;      -- 2 bytes: 110xxxxx 10xxxxxx                    -> latin, greek, arabic, hebrew, etc. 
;;      -- 3 bytes: 1110xxxx 10xxxxxx 10xxxxxx           -> chinese, japanese, etc.
;;      -- 4 bytes: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx  -> grinning cats, etc.
;;      -- the binary number                  : <byte4> <byte3> <byte2> <byte1>
;;      -- but the UTF-8 format (*reverse!*)  : <byte1> <byte2> <byte3> <byte4> (*reverse!*)
;;    - a bit of "human-machine-confusion" -> read number/bytes "left to right" or "right to left" ???
;;      -- first of all "right to left - thinking" can be misleading. it s coming from when we count from low to high numbers -> then we go right to left:  001, 002, 003, etc. or in binary: 001,010,011,100,101,etc.
;;      -- however "counting-direction" does not have to be "read-direction", i think the read direction is from left to right. i.e. when reading 0xxxxxxx, we first read the "1st" bit. and it immediately tells us that we have an ASCII character.
;;      -- so the most significant bits "IN ONE BYTE" are the first ones
;;      -- one byte is counted "right to left" as we know it from decimal, i.e. 00000001 = 1, 00000010 = 2, etc.
;;      -- however, when it comes to "READING MULTIPLE BYTES" the "SIGNIFICANCE HIERARCHY IS REVERSE (!!!)
;;      -- i.e. the "1st byte" is the "LEAST SIGNIFICANT BYTE" (!!!)
;;      -- fazit: this is great for UTF-8 reading efficiency -> we immediately know if we re dealing with ascii from the first bit of the *first byte* (!)
;;          BUT: the "REAL" binary number would be BYTE4 BYTE3 BYTE2 BYTE1 (!)
;;          so: composing the real number of an UTF8-character, we d have to reverse order these bytes.
;;    - so NOT ALL possible numbers of 4 bytes (= (2**8)**4 = 4,294,967,296 ) are used
;;    - so the total number of characters is: 2**7 + 2**(5+6) + 2**(4+6+6) + 2**(3+6+6+6) = 2.16 Mio characters, this is sufficient for all currently valid registered unicode characters (=1.11 Mio)
;;    - because only some "x's" are left free. but by this the leading bits of the bytes can be used to predetermine if we re dealing with ascii (1 byte), latin (2 bytes), asian (3 bytes), or extra stuff (4 bytes).
;;    - it is backward compatible with ASCII (first 128 characters, i.e. first 7 bits) are equal to ascii. so EVERY ASCII test is VALID UTF-8-encoded unicode AS WELL(!).
;;    - how to enter in emacs:
;;    -- 1 byte or 2 byte unicode character --> use "\u<byte2><byte1> always type TWO (!) bytes, that means precede "00" when ascii.
;;                                       (insert "\u <2nd byte as two hex> <1st byte as two hex> )
;;                                       e.g. for 'a' (insert "\u0061")
;;    -- 3 byte or 4 byte unicode character -> use capital \U : "\U<byte4><byte3><byte2>byte1>
;;         ( u can also use capital \U for ascii, but have to preceed with THREE "empty" 00 bytes. e.g. (insert "\U00000061) ;; -> "a"
;; ** contradiction ↯
(defun insert-char-contradiction ()
  ;; inserts a contradiction-symbol ↯
  (interactive)
  ;; (insert (char-from-name "DOWNWARDS ZIGZAG ARROW"))
  ;; (insert "\u21af")
  (insert "\U000021af")
  )

(defun insert-char-pencil ()
  ;; inserts a pencil-symbol ✎
  (interactive)
  ;; (insert (char-from-name "DOWNWARDS ZIGZAG ARROW"))
  ;; (insert "\u21af")
  (insert "\U0000270e")
  )


;; (insert "\U0000270E")✎
;; (insert "\U0000270f")✏
;; (insert "\U00002710")✐
;; (insert "\U00002711")✑
;; (insert "\U00002712")✒


;; * termux android

;; ** paste from android-clipboard
(defun android-paste-clipboard () 
  (interactive)
  (setq output (shell-command-to-string "termux-clipboard-get"))
  (setq clipboard-string output) ;; in case no error occured, could be checked before
  (insert clipboard-string)
)

;; ** put frequent things to clipboard
(defun my-phone-number-to-clipboard ()
  (interactive)
  (setq my-phone-number "+4917657657978870")
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

;; * auto-complete
(require 'auto-complete-config)
(ac-config-default)
(set-face-attribute 'ac-selection-face t :background "deep sky blue" :foreground "black")

(set-face-attribute 'popup-menu-selection-face t :inherit 'default :background "cyan" :foreground "black")
(set-face-attribute 'popup-scroll-bar-foreground-face t :background "deep sky blue")




;; * if debug on start-up (-> disable now debug for session)
(if debug-only-on-start-up
  (setq debug-on-error nil)
  )

;; * image viewing (imagemagick)
;; ** image-set-size (not built-in (!) --> 100% 200% etc)
(defun image-set-size ()
  (interactive)
  ;; (setq new_scale (read-number "resizing -> enter new scale: "))
  ;; (let* ((image (image--get-imagemagick-and-warn))
  ;;        (new-image (image--image-without-parameters image))
  ;;        (scale (image--current-scaling image new-image)))
  ;;   (setcdr image (cdr new-image))
  ;;   (plist-put (cdr image) :scale new_scale)))
  (image-transform-set-scale)
  )

;; ** no line numbers
(add-hook 'image-mode-hook
          (lambda ()
            (display-line-numbers-mode -1)))

;; ** evil key bindings
(evil-define-key 'normal image-mode-map (kbd "n") 'image-next-file)
(evil-define-key 'normal image-mode-map (kbd "p") 'image-previous-file)
(evil-define-key 'normal image-mode-map (kbd "r") 'image-rotate)
(evil-define-key 'normal image-mode-map (kbd "+") 'image-increase-size)
(evil-define-key 'normal image-mode-map (kbd "=") 'image-increase-size)
(evil-define-key 'normal image-mode-map (kbd "-") 'image-decrease-size)
(evil-define-key 'normal image-mode-map (kbd "s") 'image-save)

(evil-define-key 'normal org-mode-map (kbd "TAB") 'org-cycle)
;; o               image-save

;; +               image-increase-size
;;   (that binding is currently shadowed by another mode)
;; -               image-decrease-size
;;   (that binding is currently shadowed by another mode)

;; r               image-rotate

;; n               image-next-file
;;   (that binding is currently shadowed by another mode)
;; o               image-save
;;   (that binding is currently shadowed by another mode)
;; p               image-previous-file

;; C-c             Prefix Command
;; RET             image-toggle-animation
;;   (that binding is currently shadowed by another mode)
;; SPC             image-scroll-up
;;   (that binding is currently shadowed by another mode)
;; +               image-increase-size
;;   (that binding is currently shadowed by another mode)
;; -               image-decrease-size
;;   (that binding is currently shadowed by another mode)
;; 0               digit-argument
;;   (that binding is currently shadowed by another mode)
;; <               beginning-of-buffer
;;   (that binding is currently shadowed by another mode)
;; >               end-of-buffer
;;   (that binding is currently shadowed by another mode)
;; ?               describe-mode
;;   (that binding is currently shadowed by another mode)
;; F               image-goto-frame
;;   (that binding is currently shadowed by another mode)
;; a               Prefix Command
;;   (that binding is currently shadowed by another mode)
;; b               image-previous-frame
;;   (that binding is currently shadowed by another mode)
;; f               image-next-frame
;;   (that binding is currently shadowed by another mode)
;; g               revert-buffer
;;   (that binding is currently shadowed by another mode)
;; h               describe-mode
;;   (that binding is currently shadowed by another mode)
;; k               image-kill-buffer
;;   (that binding is currently shadowed by another mode)
;; n               image-next-file
;;   (that binding is currently shadowed by another mode)
;; o               image-save
;;   (that binding is currently shadowed by another mode)
;; p               image-previous-file
;;   (that binding is currently shadowed by another mode)
;; q               quit-window
;;   (that binding is currently shadowed by another mode)
;; r               image-rotate
;;   (that binding is currently shadowed by another mode)
;; DEL             image-scroll-down
;;   (that binding is currently shadowed by another mode)
;; S-SPC           image-scroll-down
;; <remap>         Prefix Command

;; <remap> <backward-char>         image-backward-hscroll
;; <remap> <beginning-of-buffer>   image-bob
;; <remap> <end-of-buffer>         image-eob
;; <remap> <forward-char>          image-forward-hscroll
;; <remap> <left-char>             image-backward-hscroll
;; <remap> <move-beginning-of-line>
;;                                 image-bol
;; <remap> <move-end-of-line>      image-eol
;; <remap> <next-line>             image-next-line
;; <remap> <previous-line>         image-previous-line
;; <remap> <right-char>            image-forward-hscroll
;; <remap> <scroll-down>           image-scroll-down
;; <remap> <scroll-down-command>   image-scroll-down
;; <remap> <scroll-left>           image-scroll-left
;; <remap> <scroll-right>          image-scroll-right
;; <remap> <scroll-up>             image-scroll-up
;; <remap> <scroll-up-command>     image-scroll-up

;; C-c C-c         image-toggle-display
;; C-c C-x         image-toggle-hex-display


;; * mucke
(defun mucke-new-song-folder ()
  "creates song folder/file in default mucke folder (currently ~/org/mucke), and opens it in INSERT mode"
  (interactive)
  (setq owd default-directory)
  ;; make folder in mucke
  (cd (concat (substitute-in-file-name "$HOME") "/org/mucke"))
  (setq artist-song-name (read-string "Enter Artist_SongNamr (e.g. 'MichaelJackson_BillieJean'):"))
  (make-directory artist-song-name)
  ;; make hidden org folder
  (cd artist-song-name)
  (message default-directory)
  (setq song-file (create-hidden-org-file-folder artist-song-name))
  ;; (cd owd)
  ;; visit song-file so you can directly edit
  (find-file song-file)
  ;; paste android clipboard
  (if (equal myhost "phone")
  (android-paste-clipboard))
  )

;; * sound
;; ** disable annoying bell sound
(setq ring-bell-function 'ignore)


;; * expand-region
(require 'expand-region)

;; ** expand-region -> evil-mode shortcut -> visual mode map: "v" -> expand region / instead of exit visual mode
(define-key evil-visual-state-map (kbd "v") 'er/expand-region)
