;; format of daily files: <year>_<month>_<day>_<weekday>.org
;; format of weekly files: <year>_<month>_<day>_week.org

;;* Todos
;;** insert/replace (=update) titles all files: MONDAY 16 DEC / 16-22 December
;;** font styling / appearence:
;;*** :LOGBOOK:.. and stuff --> grey ; style heading (*) ; style entry (**)
;;*** find way --> appearance only take effect for daily files
;;*** define appearance seperate for daily / weekly -> find way to recognize/define what type of org file it is (maybe over local variables, ooooor (even better) --> make file-name analysis as org-mode-hook -> determine type --> fire-up respective minor-mode --> do some learnings about minor-mode priorities (make sure the minor-mode does not get "corrupted/dominated" by other-minor mode)
;;** concept about categories/tags/properties -> work / privat / projects / task-clocking
;;** "sync-save" --> lauch git sync up on save --> shortcut: also spc-s / toggle-sync-save on/off , but only for planet-mode
(defvar planet-mode-map
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "C-.") 'planet-next-day)
    (define-key m (kbd "C-,") 'planet-previous-day)
    m))

(define-minor-mode planet-mode
  :initial-value nil
  :lighter " planet"
  :keymap planet-mode-map
  :group 'planet
  :global nil)

;;* planet evil
;; this also did not work out:
;; (evil-define-minor-mode-key 'normal planet-mode (kbd ">") 'planet-next-day)
;; (evil-define-minor-mode-key 'normal planet-mode (kbd "<") 'planet-previous-day)
;; intermediate work-around -> enable for all org files:
(evil-define-key 'normal org-mode-map (kbd ">") 'planet-next-day)
(evil-define-key 'normal org-mode-map (kbd "<") 'planet-previous-day)

;; that did not work: (would be nice for android usage)
;; (evil-define-minor-mode-key 'normal planet-mode-map (kbd "<up>") 'planet-next-day)
;; (evil-define-minor-mode-key 'normal planet-mode-map (kbd "up") 'planet-next-day)
;; (evil-define-minor-mode-key 'normal planet-mode-map (kbd "down") 'planet-previous-day)

(evil-define-minor-mode-key 'insert planet-mode (kbd ">") 'planet-next-day)
(evil-define-minor-mode-key 'insert planet-mode (kbd "<") 'planet-previous-day)
;; (evil-define-minor-mode-key 'insert planet-mode (kbd "up") 'planet-next-day)
;; (evil-define-minor-mode-key 'insert planet-mode (kbd "down") 'planet-previous-day)

(evil-define-minor-mode-key 'emacs planet-mode (kbd ">") 'planet-next-day)
(evil-define-minor-mode-key 'emacs planet-mode (kbd "<") 'planet-previous-day)
;; (evil-define-minor-mode-key 'emacs planet-mode-map (kbd "up") 'planet-next-day)
;; (evil-define-minor-mode-key 'emacs planet-mode-map (kbd "down") 'planet-previous-day)


(provide 'planet)

(defun planet-add-one-day (date)
  ;; (setq date (decode-time (current-time)))
(setq date2 date)
(setq day (nth 3 date2))
(setq day-incremented (1+ day))
(setf (nth 3 date2) day-incremented)
(setq date2 (decode-time (apply 'encode-time date2))) ;; this line "get s it correct again" in case the day "leaves its range" e.g. 40th of december (... 40 12 ...)
;; (apply 'encode-time (decode-time (current-time))) ;; this would be the equivalent "getting it right" the other way 'round
date2)

(defun planet-subtract-one-day (date)
  ;; (setq date (decode-time (current-time)))
(setq date2 date)
(setq day (nth 3 date2))
(setq day-incremented (1- day))
(setf (nth 3 date2) day-incremented)
(setq date2 (decode-time (apply 'encode-time date2))) ;; this line "get s it correct again" in case the day "leaves its range" e.g. 40th of december (... 40 12 ...)
;; (apply 'encode-time (decode-time (current-time))) ;; this would be the equivalent "getting it right" the other way 'round
date2)

(defun planet-create-date (day month year)
    (setq date (decode-time (encode-time 1 1 0 day month year)))
  date)

(defun planet-create-daily-org-files (&optional days)
    " creates daily files in $ORG/daily/ . determines the latest daily-file, and adds new daily-files for <days> number of days (default 60 days)."
    (interactive)
    ;* determine latest daily-file
    (setq date (planet-get-last-daily-org-file-date))
    (setq i 1)
    (while (< i 60)
      (setq i (1+ i))
      ;; add one day
      (setq date (planet-add-one-day date))
      (create-daily-hidden-org-file date)
      )
    (create-symlinks-for-all-hidden-org-file-folders planet-daily-dir)
    )

(defun planet-create-week-org-files (&optional days)
    " creates week files in $ORG/daily/ . only for existing daily-files. simply, for each existing monday-file a nearly equal org-file-folder is created, where only ..._Mon is replaced by ..._week"
    (interactive)
    ;* filter daily-files for mondays
    (setq daily-files (planet-get-all-daily-files))
    (setq daily-files (-filter (lambda (x) (string-match "^\..*_Mon\.org$" x)) daily-files))
    (dolist (file daily-files) 
      (setq filebasename (file-name-base file))
      ;; replace "Mon" by "week"
      (setq fixedcase t)
      (setq week-filebasename (replace-regexp-in-string "Mon" "week" filebasename fixedcase))
      (setq week-filebasename (replace-regexp-in-string "^." "" week-filebasename))
      (create-hidden-org-file-folder week-filebasename planet-daily-dir)
      )

    ;;* run create symlinks to "update" symlinks (existing are not changed)
    (create-symlinks-for-all-hidden-org-file-folders planet-daily-dir)
    )

(defun planet-get-all-daily-files ()
    (setq daily-files (directory-files planet-daily-dir))
    ;;** filter
    (setq daily-files (-filter (lambda (x) (string-match "^\..*\.org$" x)) daily-files))
    (cd planet-daily-dir)
    (setq daily-files (-filter (lambda (x) (file-directory-p x)) daily-files)) ;; get the wuckin symlinks out (above regex could not filter them, prob. elisp bug)
    ;;** extract year/month/day of last file
daily-files)

(defun planet-get-last-daily-org-file-date ()
    ;;** get list of files
    (setq daily-files (planet-get-all-daily-files))
    (setq last-daily-file-name (car (last daily-files)))

    ;;diese scheiße mit groups hat überhaupt nicht geklappt (when (string-match ".\\([0-9][0-9]*\\)_\\([0-9][0-9]*\\)_\\([0-9][0-9]*\\)_...\.org$" last-daily-file-name) (match-string 1) etc.
    (when (string-match ".[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]_...\.org$" last-daily-file-name)
      (setq year (string-to-number (substring last-daily-file-name 1 5)))
      (setq month (string-to-number (substring last-daily-file-name 6 8)))
      (setq day (string-to-number (substring last-daily-file-name 9 11)))
      )
    ;;** set last-date
    (setq last-date (planet-create-date day month year))
  ;; last-date)
last-date)
;; test: (planet-get-last-daily-org-file-date)

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

(defvar planet-daily-dir "~/org/daily")
(defvar planet-dir "~/org")

(defun convert-dow-abbreviation (dow)
  (setq weekday-abbr (nth dow dow-time-days))
 weekday-abbr)

(defun create-daily-hidden-org-file(date)
  " creates daily file <year>_<month>_<day>_<weekdayname>.org for <date> in planet-daily-directory. 
    1 argument: date ...  format elisp date list (run decode-time first): (16 50 15 9 12 2019 1 nil 3600)
    "
  (interactive)
  ;;* concat file name 
  (setq filebasename (planet-convert-date-to-filebasename (date)))
  (create-hidden-org-file-folder filebasename planet-daily-dir)
  (setq file-full-name (concat  (file-name-as-directory planet-daily-dir) filename))
  )

;; (setq date-raw-2 (time-add date-raw date-raw))
;; (decode-time date-raw)
;; (setq date2 (decode-time date-raw-2))

;; (setq t1 (encode-time 1 1 0 31 3 2019))
;; (decode-time (encode-time 1 1 0 33 3 2019))

;; (apply 'encode-time (decode-time (current-time)))

;; (setq a 3)
;; (format "%02i" a)

(defun planet-next-day ()
  (interactive)
  (setq this-file-date (planet-get-daily-file-date))
  (setq next-day-date (planet-add-one-day this-file-date))

  (setq next-day-filebasename (planet-convert-date-to-filebasename next-day-date))

  (find-file (concat planet-daily-dir "/." next-day-filebasename ".org" "/" next-day-filebasename ".org"))
  )

(defun planet-previous-day ()
  (interactive)
  (setq this-file-date (planet-get-daily-file-date))
  (setq previous-day-date (planet-subtract-one-day this-file-date))

  (setq previous-day-filebasename (planet-convert-date-to-filebasename previous-day-date))

  (find-file (concat planet-daily-dir "/." previous-day-filebasename ".org" "/" previous-day-filebasename ".org"))
  )

(defun planet-get-daily-file-date ()
  (interactive)
  (setq filebasename (file-name-sans-extension (buffer-name)))
  (setq this-file-date (planet-convert-filebasename-to-date filebasename))
  this-file-date)

(defun planet-today ()
  (interactive)
  (setq date (decode-time (current-time)))
  (setq filebasename (planet-convert-date-to-filebasename date))
  (find-file (concat planet-daily-dir "/." filebasename ".org" "/" filebasename ".org"))
  )
;;test: (planet-open-today)
(evil-leader/set-key "t" 'planet-today)
(evil-leader/set-key "w" 'planet-this-week)

(defun planet-this-week ()
  (interactive)
  (setq date (decode-time (current-time)))
  (planet-go-week-file-for-date date)
  )
;;test: (planet-open-today)


(defun planet-go-week-file-for-current-buffer-daily-file ()
  (interactive)
  (setq filebasename (file-name-sans-extension (buffer-name)))
  (setq this-file-date (planet-convert-filebasename-to-date filebasename))
  (planet-go-week-file-for-date this-file-date)
  )

(defun planet-go-week-file-for-date (date)
  (setq dow_monday 1)
  (setq dow (planet-date-get-dow date))
  (while (not (= dow dow_monday))
    (setq date (planet-subtract-one-day date))
    (setq dow (planet-date-get-dow date))
    )
  
  (setq found-monday-filebasename (planet-convert-date-to-filebasename date))
  (setq fixedcase t)
  (setq week-filebasename (replace-regexp-in-string "Mon" "week" found-monday-filebasename fixedcase))
  (find-file (concat planet-daily-dir "/." week-filebasename ".org" "/" week-filebasename ".org"))
  )

(defun planet-date-get-dow (date)
  (setq day  (nth 6 date))
day)

(defun planet-date-get-year (date)
  (setq year  (nth 5 date))
year)

(defun planet-date-get-month (date)
  (setq month  (nth 4 date))
month)
  
(defun planet-date-get-day (date)
  (setq day  (nth 3 date))
day)

(defun planet-convert-filebasename-to-date (filenamebase)
    ;;diese scheiße mit groups hat überhaupt nicht geklappt (when (string-match ".\\([0-9][0-9]*\\)_\\([0-9][0-9]*\\)_\\([0-9][0-9]*\\)_...\.org$" last-daily-file-name) (match-string 1) etc.
    (when (string-match "[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]_..." filenamebase)
      (setq year (string-to-number (substring filenamebase 0 4)))
      (setq month (string-to-number (substring filenamebase 5 7)))
      (setq day (string-to-number (substring filenamebase 8 10)))
      )
    ;;** set last-date
    (setq date (planet-create-date day month year))
date)

(defun planet-convert-date-to-filebasename (date)
  (setq year  (format "%02i" (nth 5 date)))
  (setq month (format "%02i" (nth 4 date)))
  (setq day   (format "%02i" (nth 3 date)))

  (setq dow (nth 6 date))
  (setq weekday-abbr (convert-dow-abbreviation dow))

   (setq filebasename (concat year "_" month "_" day "_" weekday-abbr ))

  filebasename)

;; open 'standard quick' notes.org file
(defun planet-open-quick-notes ()
  (interactive)
  (find-file (concat planet-dir "/" "notes.org"))
  )


;;* tag alignment
(defun planet-auto-align-tags () 
  (interactive)
  (setq org-tags-column (- 5 (window-body-width)))
  (org-align-all-tags)
  )
