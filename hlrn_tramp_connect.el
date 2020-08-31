(defun hlrn-home-tramp ()
  (interactive)
  (find-file "/ssh:blogin:/home/beijsach")
)

(defun hlrn-work-tramp ()
  (interactive)
  (find-file "/ssh:blogin:/scratch/usr/beijsach")
)

(defun hlrn-work-tramp-sshx ()
  (interactive)
  (find-file "/sshx:blogin:/scratch/usr/beijsach")
)

(defun hlrn-work-tramp-scp ()
  (interactive)
  (find-file "/scp:blogin:/scratch/usr/beijsach")
)

(defun hlrn-goettingen-home-tramp ()
  (interactive)
  (find-file "/ssh:glogin:/home/beijsach")
)

(defun hlrn-goettingen-work-tramp ()
  (interactive)
  (find-file "/ssh:glogin:/scratch/usr/beijsach")
)


		 
(defun hlrn-work2-tramp ()
  (interactive)
  (find-file "/ssh:blogin:/gfs2/work/beijsach")
)

(defun hlrn-work1-tramp-scp ()
  (interactive)
  (find-file "/scp:blogin:/gfs1/work/beijsach")
)

(defun hlrn-work1-tramp-sshx ()
  (interactive)
  (find-file "/sshx:blogin:/gfs1/work/beijsach")
)

(defun mathecluster-home-tramp ()
  (interactive)
  (find-file "/ssh:mathe:/homes2/ifvt/sacher")
)

(defun mathecluster-work-tramp ()
  (interactive)
  (find-file "/ssh:mathe:/net/work/sacher")
)


;; xclip / copy / paste related stuff
(defun xclip-toggle-on ()
  (interactive)
  (require 'xclip)
  (xclip-mode 1)
  )

(defun set-localhost-nr ()
  (interactive)
  (setq localhost-integer-nr (read-string "enter localhost nr (integer without digit, e.g. 10):"))
  (setq localhost-str (concat "localhost:" localhost-integer-nr ".0"))
  (setenv "DISPLAY" localhost-str) 
  (message (concat "DISPLAY set to " localhost-str))
  )

(defun xclip-toggle-off ()
  (interactive)
  (require 'xclip)
  (xclip-mode 0)
  )

(defun set-localhost-nr ()
  (interactive)
  (setq localhost-integer-nr (read-string "enter localhost nr (integer without digit, e.g. 10):"))
  (setq localhost-str (concat "localhost:" localhost-integer-nr ".0"))
  (setenv "DISPLAY" localhost-str) 
  (message (concat "DISPLAY set to " localhost-str))
  )

(defun get-localhost-nr-mathe-cluster ()
  (interactive)
  ;; * get parent of current screen session
  ;; ** get output of ps -ef | grep <user>
  (setq ps-ef-output (shell-command-to-string "ps -ef | grep sacher"))
  (setq ps-ef-output-lines (split-string ps-ef-output "\n"))
  ;; ** get process of this screen session
  (setq found-lines ())
  (dolist (this-ps-ef-output-line ps-ef-output-lines)
    (when (string-match "^sacher *\\([0-9]+\\) *\\([0-9]+\\) .* screen -rd desktop" this-ps-ef-output-line)
      (setq login-shell-pid (match-string 2 this-ps-ef-output-line))
      (push this-ps-ef-output-line found-lines)
      )
    )
  ;; get parent of screen process -> i.e. second number in line
  ;; (setq n-lines (length found-lines))
  ;; (message (concat "I found " (number-to-string n-lines) " matches")) 
  ;; (message (concat "login shell pid: " login-shell-pid)) 
  ;; ** get (DISPLAY) info about login-shell process, which resides in /proc/<process-id> 
  ;; (setq environ-output (shell-command-to-string ("environ -ef | grep sacher"))
  (setq command-str (concat "cat /proc/" login-shell-pid "/environ "))
  (setq environ-file (shell-command-to-string command-str))
  (setq environ-file-lines (split-string environ-file "\0"))
  (dolist (environ-file-line environ-file-lines)
    (when (string-match "^DISPLAY=\\(.*\\)$" environ-file-line)
      (setq  display-name (match-string 1 environ-file-line))
      (message (concat "found display name: " display-name)) 
      )
    )
  display-name)

(defun set-correct-display-name-for-ssh-mathe-cluster ()
  (interactive)
  (setq display-name (get-localhost-nr-mathe-cluster))
  (setenv "DISPLAY" display-name)
  (message (concat "DISPLAY set to " display-name))
  )
