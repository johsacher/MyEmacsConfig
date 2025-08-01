(defun copy-current-path ()
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
  ;; (setq currentpath_quoted (concat "'" currentpath "'"))
  (setq currentpath_quoted currentpath)
 (kill-new currentpath_quoted)
 (message (concat "copied path to clipboard: "  currentpath_quoted))
 currentpath_quoted)


(defun change-dir-from-clipboard () 
  (interactive)
  (cond ( (equal major-mode 'dired-mode)
	  (dired (current-kill 0)) ;; open new dired and go to path (maybe later reuse buffer)
        )
	( (equal major-mode 'term-mode)
	  (term-send-raw-string (concat "cd " (current-kill 0))); "\n")
	  (term-send-raw-string "\n")
          )
	(t
	 (dired (current-kill 0)) ;; open new dired and go to path
	)
   )     
)

(defun copy-current-file-name ()
  (interactive)
  (cond ( (equal major-mode 'dired-mode)
       ;; nothing
	)
	( (equal major-mode 'term-mode)
       ;; nothing
	)
	(t ;; else
	     (setq filename (file-name-nondirectory buffer-file-name))
	)
   )
 (kill-new filename)
 (message (concat "copied file name to clipboard: "  filename))
 )


(defun copy-current-file-name-no-extension ()
  (interactive)
  (cond ( (equal major-mode 'dired-mode)
       ;; nothing
	)
	( (equal major-mode 'term-mode)
       ;; nothing
	)
	(t ;; else
	     (setq filename-noext (file-name-base buffer-file-name))
	)
   )
 (kill-new filename-noext)
 (message (concat "copied file name (without extension) to clipboard: " filename-noext))
 )
