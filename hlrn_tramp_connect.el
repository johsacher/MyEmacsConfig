(defun hlrn-home-tramp ()
  (interactive)
  (find-file "/ssh:blogin:/home/b/beijsach")
)

(defun hlrn-work1-tramp ()
  (interactive)
  (find-file "/ssh:blogin:/gfs1/work/beijsach")
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
