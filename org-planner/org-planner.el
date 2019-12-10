(defun add-one-day (date)
  ;; (setq date (decode-time (current-time)))
(setq date2 date)
(setq day (nth 3 date2))
(setq day-incremented (1+ day))
(setf (nth 3 date2) day-incremented)

(setq date2 (decode-time (apply 'encode-time date2))) ;; this line "get s it correct again" in case the day "leaves its range" e.g. 40th of december (... 40 12 ...)
;; (apply 'encode-time (decode-time (current-time))) ;; this would be the equivalent "getting it right" the other way 'round
date2)

(defun org-planner-create-date (day month year)
    (setq date (decode-time (encode-time 1 1 0 day month year)))
  date)

(defun org-planner-create-daily-org-files (&optional days)
    " creates daily files in $ORG/daily/ . determines the latest daily-file, and adds new daily-files for <days> number of days (default 60 days)."
    (interactive)
    ;* determine latest daily-file
    (setq date (org-planner-get-last-daily-org-file-date))
    (setq i 1)
    (while (< i 60)
      (setq i (1+ i))
      ;; add one day
      (setq date (add-one-day date))
      (create-daily-hidden-org-file date)
      )
    (create-symlinks-for-all-hidden-org-file-folders org-planner-daily-dir)
    )

(defun org-planner-get-last-daily-org-file-date ()
    ;;** get list of files
    (setq daily-files (directory-files org-planner-daily-dir))
    ;;** filter
    (setq daily-files (-filter (lambda (x) (string-match "^\..*\.org$" x)) daily-files))
    (cd org-planner-daily-dir)
    (setq daily-files (-filter (lambda (x) (file-directory-p x)) daily-files)) ;; get the wuckin symlinks out (above regex could not filter them, prob. elisp bug)
    ;;** extract year/month/day of last file
    (setq last-daily-file-name (car (last daily-files)))

    ;;diese scheiße mit groups hat überhaupt nicht geklappt (when (string-match ".\\([0-9][0-9]*\\)_\\([0-9][0-9]*\\)_\\([0-9][0-9]*\\)_...\.org$" last-daily-file-name) (match-string 1) etc.
    (when (string-match ".[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]_...\.org$" last-daily-file-name)
      (setq year (string-to-number (substring last-daily-file-name 1 5)))
      (setq month (string-to-number (substring last-daily-file-name 6 8)))
      (setq day (string-to-number (substring last-daily-file-name 9 11)))
      )
    ;;** set last-date
    (setq last-date (org-planner-create-date day month year))
  ;; last-date)
last-date)
;; test: (org-planner-get-last-daily-org-file-date)

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



(defvar dow-time-days '("Sun"  ;; 0
                        "Mon"  ;; 1
                        "Tue"  ;; 2
                        "Wed"  ;; 3
                        "Thu"  ;; 4
                        "Fri"  ;; 5
                        "Sat") ;; 6
  )

(defvar org-planner-daily-dir "~/org/daily")

(defun convert-dow-abbreviation (dow)
  (setq weekday-abbr (nth dow dow-time-days))
 weekday-abbr)

(defun create-daily-hidden-org-file(date)
  " creates daily file <year>_<month>_<day>_<weekdayname>.org for <date> in org-planner-daily-directory. 
    1 argument: date ...  format elisp date list (run decode-time first): (16 50 15 9 12 2019 1 nil 3600)
    "
  (interactive)
  ;;* concat file name 
  (setq filebasename (org-planner-convert-date-to-filebasename (date)))
  (create-hidden-org-file-folder filebasename org-planner-daily-dir)
  (setq file-full-name (concat  (file-name-as-directory org-planner-daily-dir) filename))
  )

;; (setq date-raw-2 (time-add date-raw date-raw))
;; (decode-time date-raw)
;; (setq date2 (decode-time date-raw-2))

;; (setq t1 (encode-time 1 1 0 31 3 2019))
;; (decode-time (encode-time 1 1 0 33 3 2019))

;; (apply 'encode-time (decode-time (current-time)))

;; (setq a 3)
;; (format "%02i" a)


(defun org-planner-open-today ()
  (interactive)
  (setq date (decode-time (current-time)))
  (setq filebasename (org-planner-convert-date-to-filebasename date))
  (find-file (concat org-planner-daily-dir "/." filebasename ".org" "/" filebasename ".org"))
  )
;;test: (org-planner-open-today)

  

(defun org-planner-convert-filebasename-to-date (filenamebase)
    ;;diese scheiße mit groups hat überhaupt nicht geklappt (when (string-match ".\\([0-9][0-9]*\\)_\\([0-9][0-9]*\\)_\\([0-9][0-9]*\\)_...\.org$" last-daily-file-name) (match-string 1) etc.
    (when (string-match "[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]_..." last-daily-file-name)
      (setq year (string-to-number (substring last-daily-file-name 0 4)))
      (setq month (string-to-number (substring last-daily-file-name 5 7)))
      (setq day (string-to-number (substring last-daily-file-name 8 10)))
      )
    ;;** set last-date
    (setq date (org-planner-create-date day month year))
date)

(defun org-planner-convert-date-to-filebasename (date)
  (setq year  (format "%02i" (nth 5 date)))
  (setq month (format "%02i" (nth 4 date)))
  (setq day   (format "%02i" (nth 3 date)))

  (setq weekday-int (nth 6 date))
  (setq weekday-abbr (convert-dow-abbreviation weekday-int))

   (setq filebasename (concat year "_" month "_" day "_" weekday-abbr ))

  filebasename)
