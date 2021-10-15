;;; my_matlab_hacks.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Dr. Johannes Sacher
;;
;; Author: Dr. Johannes Sacher <https://github.com/johannes>
;; Maintainer: Dr. Johannes Sacher <johannnes.sacher@googlemail.com>
;; Created: October 15, 2021
;; Modified: October 15, 2021
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/johannes/my_matlab_hacks
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:
;;;

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



(provide 'my_matlab_hacks)
;;; my_matlab_hacks.el ends here
;;;
;;;
;;;
