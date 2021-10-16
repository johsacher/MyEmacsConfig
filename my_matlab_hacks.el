;;; my_matlab_hacks.el --- Description -*- lexical-binding: t; -*-
;;;
(add-hook!  matlab-mode 'line-number-mode)

 (defvar matlab-term-mode-map
   (let ((m (make-sparse-keymap))) ;; i think this achieves a "local key binding" for the buffer
     (define-key m (kbd "M-p") 'term-send-up)
     m))

 (define-minor-mode matlab-term-mode "this is the documentation."
   :init-value nil
   :lighter " matlab-term"
   :keymap matlab-term-mode-map
   :group 'matlab-term
   :global nil)
;; * create my own matlab REPL "*MATLAB*" buffer
(defvar matlab-term-buffer-name "*MATLAB*")
(defun matlab-term-init ()
  "Start a terminal-emulator in a new buffer  and call it  '*MATLAB*, then start matlab -nodisplay')"
  (interactive)
  (setq program "/bin/bash")
  (setq term-ansi-buffer-name (concat matlab-term-buffer-name))
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
    ;; (matlab-term-send-string-and-execute "matlab -nodisplay")
    (matlab-term-send-string-and-execute "matlab -nodesktop")
    ;; go to emacs state and char-mode
    (evil-emacs-state)
    (term-char-mode)
    (matlab-term-mode))

(defun matlab-term ()
  (interactive)
  ;; initiate if not already exists
  (if (not (get-buffer matlab-term-buffer-name))
      (matlab-term-init))
  ;; switch to that buffer
  (switch-to-buffer matlab-term-buffer-name))

 (defun matlab-term-send-string-and-execute (string)
   (comint-send-string matlab-term-buffer-name (concat string "\n")))
;; test: (matlab-term-send-string-and-execute "echo hello")

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
 (defun matlab-term-send-scriptname-and-execute ()
   "execute "
   (interactive)
   (setq this-buffer-filename-base (file-name-base (buffer-file-name)))
   (matlab-term-send-string-and-execute this-buffer-filename-base))

 (defun matlab-term-save-and-send-scriptname-and-execute ()
   (interactive)
   (save-buffer)
   (matlab-term-send-scriptname-and-execute))

 (defun matlab-term-send-current-region-and-execute ()
 (interactive)
     (setq region_string (buffer-substring (mark) (point)))
     (matlab-term-send-string-and-execute region_string)
 )

 (defun matlab-term-set-breakpoint-current-line()
   (interactive)
   ; get line number
   (setq line-nr (number-to-string (line-number-at-pos)))
   ; get file name without ".m" extension
  (setq filename-base (file-name-base (buffer-file-name)))
   (matlab-term-send-string-and-execute (concat "dbstop " filename-base " at " line-nr))
 )

 (defun matlab-term-dbstep()
   (interactive)
   (matlab-term-send-string-and-execute "dbstep")
   ;; (matlab-jump-to-current-debug-position) ;; --> this was not working fluently
   ;; --> instead: assume were still in the same file and procede to new line
   ;; (sleep-for 10)
   ;; (message "sleeping ...")
   ;; (call-process "sleep" nil nil nil "1")
   ;; (message "finished ...")
   (matlab-term-get-jump-new-line-number-from-last-debug-output)
 )

 (defun matlab-term-dbcont()
   (interactive)
   (matlab-term-send-string-and-execute "dbcont")
 )

 (defun matlab-term-dbclear-all()
   (interactive)
   (matlab-term-send-string-and-execute "dbclear all")
 )

 (defun matlab-term-dbquit()
   (interactive)
   (matlab-term-send-string-and-execute "dbquit")
 )

 (defun matlab-term-dbclear-current-file()
   (interactive)
   (setq filename-base (file-name-base (buffer-file-name)))
   (matlab-term-send-string-and-execute (concat "dbclear " filename-base))
 )

 (defun matlab-term-get-jump-new-line-number-from-last-debug-output ()
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

;; this still not working (maybe have to sleep 1s or sth)
 (defun matlab-term-jump-to-current-debug-position ()
   (interactive)
   ;; (sleep-for 0.1)
   ;; produce current debug position information
   (matlab-term-send-string-and-execute "dbstack")
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
(after! matlab
 ;; MATLAB-DEBUG/RUN SHORT-CUTS (could serve generalistically for other languages)
 ;; SET BREAKPOINT <F12>
 (define-key matlab-mode-map (kbd "<f12>") 'matlab-term-set-breakpoint-current-line)
 ;; JUMP TO CURRENT DEBUG POS <F11> (todo --> just for now because automatic not working flawlessly)
 (define-key matlab-mode-map (kbd "<f11>") 'matlab-term-jump-to-current-debug-position)
 ;; DEBUG STEP <F10>
 (define-key matlab-mode-map (kbd "<f10>") 'matlab-term-dbstep)
 ;; DEBUG CONTINUE <F6> (todo--> could be united with F5, detect if in debug process)
 (define-key matlab-mode-map (kbd "<f6>") 'matlab-term-dbcont)
 ;; SAVE and RUN script <F5>
 (define-key matlab-mode-map (kbd "<f5>") 'matlab-term-save-and-send-scriptname-and-execute)
 ;; DEBUG QUIT <F8>
 (define-key matlab-mode-map (kbd "<f8>") 'matlab-term-dbquit)
 ;; CLEAR BREAK POINTS current file
 (define-key matlab-mode-map (kbd "<f7>") 'matlab-term-dbclear-all)
 ;; EVALUATE/RUN SELECTION <F9>
 (define-key matlab-mode-map (kbd "<f9>") 'matlab-term-send-current-region-and-execute)
 ;; EVALUATE/RUN SELECTION <F9>
 ;;; END MATLAB COMODITIES
 )

 ;; matlab shell key bindings (--> have to be implemented as hooks, since matlab-shell-mode-map does not exist before opening a matlab-shell()
 (add-hook 'matlab-term-mode-hook
           (lambda ()
             (define-key matlab-term-mode-map (kbd "<f10>") 'matlab-dbstep)
             (define-key matlab-term-mode-map (kbd "<f8>") 'matlab-dbquit)
             (define-key matlab-term-mode-map (kbd "<f7>") 'matlab-dbclear-all)
             (define-key matlab-term-mode-map (kbd "<f6>") 'matlab-dbcont)
             ;; set Alt-p for "go up" --> my own 'convenient convention' for all types of command shells
             (define-key matlab-term-mode-map (kbd "M-p") 'matlab-shell-previous-matching-input-from-input)
             (define-key matlab-term-mode-map (kbd "M-n") 'matlab-shell-next-matching-input-from-input)
             ))



(provide 'my_matlab_hacks)
;;; my_matlab_hacks.el ends here
;;;
;;;
;;;
