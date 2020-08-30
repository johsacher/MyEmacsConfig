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
