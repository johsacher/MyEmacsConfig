;; a package to track your speaking time when talking with others -> did I exceed 50% speaking-time, was I so bad at listening to others?

(define-minor-mode speachron-mode
  :initial-value nil
  :lighter " speachrono"
  :keymap speachron-mode-map
  :group 'speachron-mode
  :global global)

(defvar other-name "other")
(defvar speachron-black-hide-buffer "*speachron-hidden*")

(defun speachron-black-hide ()
  ;;; creates a "hidden buffer" i.e. maximises it as a "black" screen
  ;;; buttons are also hidden:
  ;;; * TOGGLE
  ;;; * ME
  ;;; * OTHER
  ;;; * STOP
  ;;; * SET-OTHER-NAME
  (interactive)
  (get-buffer-create speachron-black-hide-buffer)
  (switch-to-buffer speachron-black-hide-buffer)
  
  ;; * make black background
  )


;; * redefine org-modes clock-in / out functions to track seconds
(defun speachron-clock-in (&optional select start-time)
  "Start the clock on the current item.

If necessary, clock-out of the currently active clock.

With a `\\[universal-argument]' prefix argument SELECT, offer a list of \
recently clocked
tasks to clock into.

When SELECT is `\\[universal-argument] \ \\[universal-argument]', \
clock into the current task and mark it as
the default task, a special task that will always be offered in the
clocking selection, associated with the letter `d'.

When SELECT is `\\[universal-argument] \\[universal-argument] \
\\[universal-argument]', clock in by using the last clock-out
time as the start time.  See `org-clock-continuously' to make this
the default behavior."
  (interactive "P")
  (setq org-clock-notification-was-shown nil)
  (org-refresh-effort-properties)
  (catch 'abort
    (let ((interrupting (and (not org-clock-resolving-clocks-due-to-idleness)
			     (org-clocking-p)))
	  ts selected-task target-pos (org--msg-extra "")
	  (leftover (and (not org-clock-resolving-clocks)
			 org-clock-leftover-time)))

      (when (and org-clock-auto-clock-resolution
		 (or (not interrupting)
		     (eq t org-clock-auto-clock-resolution))
		 (not org-clock-clocking-in)
		 (not org-clock-resolving-clocks))
	(setq org-clock-leftover-time nil)
	(let ((org-clock-clocking-in t))
	  (org-resolve-clocks)))    ; check if any clocks are dangling

      (when (equal select '(64))
	;; Set start-time to `org-clock-out-time'
	(let ((org-clock-continuously t))
	  (org-clock-in nil org-clock-out-time)
	  (throw 'abort nil)))

      (when (equal select '(4))
	(pcase (org-clock-select-task "Clock-in on task: ")
	  (`nil (error "Abort"))
	  (task (setq selected-task (copy-marker task)))))

      (when (equal select '(16))
	;; Mark as default clocking task
	(org-clock-mark-default-task))

      (when interrupting
	;; We are interrupting the clocking of a different task.  Save
	;; a marker to this task, so that we can go back.  First check
	;; if we are trying to clock into the same task!
	(when (or selected-task (derived-mode-p 'org-mode))
	  (org-with-point-at selected-task
	    (unless selected-task (org-back-to-heading t))
	    (when (and (eq (marker-buffer org-clock-hd-marker)
			   (org-base-buffer (current-buffer)))
		       (= (point) (marker-position org-clock-hd-marker))
		       (equal org-clock-current-task (org-get-heading t t t t)))
	      (message "Clock continues in %S" org-clock-heading)
	      (throw 'abort nil))))
	(move-marker org-clock-interrupted-task
		     (marker-position org-clock-marker)
		     (marker-buffer org-clock-marker))
	(let ((org-clock-clocking-in t))
	  (org-clock-out nil t)))

      ;; Clock in at which position?
      (setq target-pos
	    (if (and (eobp) (not (org-at-heading-p)))
		(point-at-bol 0)
	      (point)))
      (save-excursion
	(when (and selected-task (marker-buffer selected-task))
	  ;; There is a selected task, move to the correct buffer
	  ;; and set the new target position.
	  (set-buffer (org-base-buffer (marker-buffer selected-task)))
	  (setq target-pos (marker-position selected-task))
	  (move-marker selected-task nil))
	(org-with-wide-buffer
	 (goto-char target-pos)
	 (org-back-to-heading t)
	 (or interrupting (move-marker org-clock-interrupted-task nil))
	 (run-hooks 'org-clock-in-prepare-hook)
	 (org-clock-history-push)
	 (setq org-clock-current-task (org-get-heading t t t t))
	 (cond ((functionp org-clock-in-switch-to-state)
		(let ((case-fold-search nil))
		  (looking-at org-complex-heading-regexp))
		(let ((newstate (funcall org-clock-in-switch-to-state
					 (match-string 2))))
		  (when newstate (org-todo newstate))))
	       ((and org-clock-in-switch-to-state
		     (not (looking-at (concat org-outline-regexp "[ \t]*"
					      org-clock-in-switch-to-state
					      "\\>"))))
		(org-todo org-clock-in-switch-to-state)))
	 (setq org-clock-heading (org-clock--mode-line-heading))
	 (org-clock-find-position org-clock-in-resume)
	 (cond
	  ((and org-clock-in-resume
		(looking-at
		 (concat "^[ \t]*" org-clock-string
			 " \\[\\([0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}"
			 " *\\sw+.? +[012][0-9]:[0-5][0-9]\\)\\][ \t]*$")))
	   (message "Matched %s" (match-string 1))
	   (setq ts (concat "[" (match-string 1) "]"))
	   (goto-char (match-end 1))
	   (setq org-clock-start-time
		 (org-time-string-to-time (match-string 1)))
	   (setq org-clock-effort (org-entry-get (point) org-effort-property))
	   (setq org-clock-total-time (org-clock-sum-current-item
				       (org-clock-get-sum-start))))
	  ((eq org-clock-in-resume 'auto-restart)
	   ;; called from org-clock-load during startup,
	   ;; do not interrupt, but warn!
	   (message "Cannot restart clock because task does not contain unfinished clock")
	   (ding)
	   (sit-for 2)
	   (throw 'abort nil))
	  (t
	   (insert-before-markers "\n")
	   (backward-char 1)
	   (when (and (save-excursion
			(end-of-line 0)
			(org-in-item-p)))
	     (beginning-of-line 1)
	     (indent-line-to (- (current-indentation) 2)))
	   (insert org-clock-string " ")
	   (setq org-clock-effort (org-entry-get (point) org-effort-property))
	   (setq org-clock-total-time (org-clock-sum-current-item
				       (org-clock-get-sum-start)))
	   (setq org-clock-start-time
		 (or (and org-clock-continuously org-clock-out-time)
		     (and leftover
			  (y-or-n-p
			   (format
			    "You stopped another clock %d mins ago; start this one from then? "
			    (/ (org-time-convert-to-integer
				(org-time-subtract
				 (org-current-time org-clock-rounding-minutes t)
				 leftover))
			       60)))
			  leftover)
		     start-time
		     (org-current-time org-clock-rounding-minutes t)))
	   (setq ts (org-insert-time-stamp org-clock-start-time
					   'with-hm 'inactive))
	   (org-indent-line)))
	 (move-marker org-clock-marker (point) (buffer-base-buffer))
	 (move-marker org-clock-hd-marker
		      (save-excursion (org-back-to-heading t) (point))
		      (buffer-base-buffer))
	 (setq org-clock-has-been-used t)
	 ;; add to mode line
	 (when (or (eq org-clock-clocked-in-display 'mode-line)
		   (eq org-clock-clocked-in-display 'both))
	   (or global-mode-string (setq global-mode-string '("")))
	   (or (memq 'org-mode-line-string global-mode-string)
	       (setq global-mode-string
		     (append global-mode-string '(org-mode-line-string)))))
	 ;; add to frame title
	 (when (or (eq org-clock-clocked-in-display 'frame-title)
		   (eq org-clock-clocked-in-display 'both))
	   (setq org-frame-title-format-backup frame-title-format)
	   (setq frame-title-format org-clock-frame-title-format))
	 (org-clock-update-mode-line)
	 (when org-clock-mode-line-timer
	   (cancel-timer org-clock-mode-line-timer)
	   (setq org-clock-mode-line-timer nil))
	 (when org-clock-clocked-in-display
	   (setq org-clock-mode-line-timer
		 (run-with-timer org-clock-update-period
				 org-clock-update-period
				 'org-clock-update-mode-line)))
	 (when org-clock-idle-timer
	   (cancel-timer org-clock-idle-timer)
	   (setq org-clock-idle-timer nil))
	 (setq org-clock-idle-timer
	       (run-with-timer 60 60 'org-resolve-clocks-if-idle))
	 (message "Clock starts at %s - %s" ts org--msg-extra)
	 (run-hooks 'org-clock-in-hook))))))


(defun speachron-clock-out (&optional switch-to-state fail-quietly at-time)
  "Stop the currently running clock.
Throw an error if there is no running clock and FAIL-QUIETLY is nil.
With a universal prefix, prompt for a state to switch the clocked out task
to, overriding the existing value of `org-clock-out-switch-to-state'."
  (interactive "P")
  (catch 'exit
    (when (not (org-clocking-p))
      (setq global-mode-string
	    (delq 'org-mode-line-string global-mode-string))
      (org-clock-restore-frame-title-format)
      (force-mode-line-update)
      (if fail-quietly (throw 'exit t) (user-error "No active clock")))
    (let ((org-clock-out-switch-to-state
	   (if switch-to-state
	       (completing-read "Switch to state: "
				(with-current-buffer
				    (marker-buffer org-clock-marker)
				  org-todo-keywords-1)
				nil t "DONE")
	     org-clock-out-switch-to-state))
	  (now (org-current-time org-clock-rounding-minutes))
	  ts te s h m remove)
      (setq org-clock-out-time (or at-time now))
      (save-excursion ; Do not replace this with `with-current-buffer'.
	(with-no-warnings (set-buffer (org-clocking-buffer)))
	(save-restriction
	  (widen)
	  (goto-char org-clock-marker)
	  (beginning-of-line 1)
	  (if (and (looking-at (concat "[ \t]*" org-keyword-time-regexp))
		   (equal (match-string 1) org-clock-string))
	      (setq ts (match-string 2))
	    (if fail-quietly (throw 'exit nil) (error "Clock start time is gone")))
	  (goto-char (match-end 0))
	  (delete-region (point) (point-at-eol))
	  (insert "--")
	  (setq te (org-insert-time-stamp (or at-time now) 'with-hm 'inactive))
	  (setq s (org-time-convert-to-integer
		   (time-subtract
		    (org-time-string-to-time te)
		    (org-time-string-to-time ts)))
		h (floor s 3600)
		m (floor (mod s 3600) 60))
	  (insert " => " (format "%2d:%02d" h m))
	  (move-marker org-clock-marker nil)
	  (move-marker org-clock-hd-marker nil)
	  ;; Possibly remove zero time clocks.  However, do not add
	  ;; a note associated to the CLOCK line in this case.
	  (cond ((and org-clock-out-remove-zero-time-clocks
		      (= 0 h m))
		 (setq remove t)
		 (delete-region (line-beginning-position)
				(line-beginning-position 2)))
		(org-log-note-clock-out
		 (org-add-log-setup
		  'clock-out nil nil nil
		  (concat "# Task: " (org-get-heading t) "\n\n"))))
	  (when org-clock-mode-line-timer
	    (cancel-timer org-clock-mode-line-timer)
	    (setq org-clock-mode-line-timer nil))
	  (when org-clock-idle-timer
	    (cancel-timer org-clock-idle-timer)
	    (setq org-clock-idle-timer nil))
	  (setq global-mode-string
		(delq 'org-mode-line-string global-mode-string))
	  (org-clock-restore-frame-title-format)
	  (when org-clock-out-switch-to-state
	    (save-excursion
	      (org-back-to-heading t)
	      (let ((org-clock-out-when-done nil))
		(cond
		 ((functionp org-clock-out-switch-to-state)
		  (let ((case-fold-search nil))
		    (looking-at org-complex-heading-regexp))
		  (let ((newstate (funcall org-clock-out-switch-to-state
					   (match-string 2))))
		    (when newstate (org-todo newstate))))
		 ((and org-clock-out-switch-to-state
		       (not (looking-at (concat org-outline-regexp "[ \t]*"
						org-clock-out-switch-to-state
						"\\>"))))
		  (org-todo org-clock-out-switch-to-state))))))
	  (force-mode-line-update)
	  (message (if remove
		       "Clock stopped at %s after %s => LINE REMOVED"
		     "Clock stopped at %s after %s")
		   te (org-duration-from-minutes (+ (* 60 h) m)))
	  (run-hooks 'org-clock-out-hook)
	  (unless (org-clocking-p)
	    (setq org-clock-current-task nil)))))))


(defun speachron-me ()
  (interactive)
  ;; 
  )

(defun speachron-other ()
  (interactive)
  ;; 
  )

(defun speachron-new-item-and-start-clock (item-name)
  (interactive)
  ;; make new heading 

  ;; stop previous clock

  ;; start clock
  )
