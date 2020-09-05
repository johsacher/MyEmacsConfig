;;* trash / remove operations
(defvar logins_removeids)
(setq logins_removeids (list
                        (list 1  2  3  4) ;; blogin1
                        (list 5  6  7  8) ;; blogin2
                        (list 9  10 11 12) ;; blogin3
                        (list 13 14 15 16) ;; blogin4
                        (list 17 18 19 20) ;; blogin5
                        (list 21 22 23 24) ;; blogin6
                        (list 25 26 27 28) ;; blogin7
                        (list 29 30 31 32) ;; blogin8
                        ))
(defun hlrn-remove-screen-session-get-session-id-from-remove-id (remove-id)
  (interactive)
  (setq result nil)
  (setq loginid 0)
  (dolist (this_login_removeids logins_removeids)
    (setq loginid (1+ loginid))
    ;; (message (concat "login id: " (number-to-string loginid)))
    (dolist (this_removeid this_login_removeids)
      ;; (message (concat "   remove id: " (number-to-string this_removeid)))
      (if (= remove-id this_removeid)
          (setq result loginid)
          )
      )
    )
  result)


asdfasfd
(hlrn-remove-screen-session-get-session-id-from-remove-id 33)

(defun hlrn-remove-screen-session-open (index)
  ;; index.. which remove session -> remove1 / remove2 or remove16 / etc.
  ;; the remove sessions are distributed over the blogin nodes (blogin1/blogin2/etc.)
  ;; currently: blogin1 has remove1/2/3/4  ; blogin2 has remove5/6/7/8 ; and so forth
  (interactive)
  ;;* make new ansi-term buffer (not in sticky-buffer-mode)
  (setq program "/bin/bash")
  (setq term-ansi-buffer-name (concat "*hlrn-remove-session-" (number-to-string index)  "*"))
  (setq term-ansi-buffer-name (term-ansi-make-term term-ansi-buffer-name program))
  (switch-to-buffer term-ansi-buffer-name)
  (set-buffer term-ansi-buffer-name)
  (term-mode)
  (term-char-mode)
  )
(defun hlrn-remove-screen-session-command (command)
  

    )
