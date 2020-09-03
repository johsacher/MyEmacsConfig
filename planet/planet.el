;; format of daily files: <year>_<month>_<day>_<weekday>.org
;; format of weekly files: <year>_<month>_<day>_week.org

;;* Todos
;;** week view 4X2
;;** go to today (weekview) SPC t, shortcuts view/rendering,level 1/2/3, all / single buffer
;;** view option -> level 1, no bulletsi (more space in weekview), option linebreak/no line break
;;** better week-day headers --> use header-line
;;*** color week-end / week-day / current-day
;;** better modeline --> optimize modeline for planet-week-day-view 
;;** git-save --> detect if merge conflict --> pull first
;;** clock in/out -> closer look --> multimachine -> no dependency on (global) lisp variables --> these would not be in sync in machines --> only depend on text-(org-)file content!
;;** DONE insert/replace (=update) titles all files: MONDAY 16 DEC / 16-22 December
;;** DONE week view (8 windows, quit-week-view --> winner-undo/or better: remember windows arrangement and go back) + move forward week
;;** planet files --> show only top headings
;;** leader-key bindings for planet-mode (minor mode) --> (currently with evil-leader/set-key-for-mode org-mode ... ), was only possible with major-mode
;;** font styling / appearence:
;;*** :LOGBOOK:.. and stuff --> grey ; style heading (*) ; style entry (**)
;;*** find way --> appearance only take effect for daily files
;;*** define appearance seperate for daily / weekly -> find way to regnize/define what type of org file it is (maybe over local variables, ooooor (even better) --> make file-name analysis as org-mode-hook -> determine type --> fire-up respective minor-mode --> do some learnings about minor-mode priorities (make sure the minor-mode does not get "corrupted/dominated" by other-minor mode)
;;** concept about categories/tags/properties -> work / privat / projects / task-clocking
;;** ("sync-save" --> lauch git sync up on save --> shortcut: also spc-s / toggle-sync-save on/off , but only for planet-mode) -> not necessary with gsyn checkout / checkin

(defvar planet-mode-map
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "C-.") 'planet-next-day)
    (define-key m (kbd "C-,") 'planet-previous-day)
    m))

(defvar planet-regexp-daily-file-folder ".[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]_...\.org$")

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
(evil-define-key 'normal org-mode-map (kbd ">") 'planet-next)
(evil-define-key 'normal org-mode-map (kbd "<") 'planet-previous)

;; that did not work: (would be nice for android usage)
;; (evil-define-minor-mode-key 'normal planet-mode-map (kbd "<up>") 'planet-next-day)
;; (evil-define-minor-mode-key 'normal planet-mode-map (kbd "up") 'planet-next-day)
;; (evil-define-minor-mode-key 'normal planet-mode-map (kbd "down") 'planet-previous-day)

(evil-define-minor-mode-key 'insert planet-mode (kbd ">") 'planet-next)
(evil-define-minor-mode-key 'insert planet-mode (kbd "<") 'planet-previous)
;; (evil-define-minor-mode-key 'insert planet-mode (kbd "up") 'planet-next-day)
;; (evil-define-minor-mode-key 'insert planet-mode (kbd "down") 'planet-previous-day)

(evil-define-minor-mode-key 'emacs planet-mode (kbd ">") 'planet-next)
(evil-define-minor-mode-key 'emacs planet-mode (kbd "<") 'planet-previous)
;; (evil-define-minor-mode-key 'emacs planet-mode-map (kbd "up") 'planet-next-day)
;; (evil-define-minor-mode-key 'emacs planet-mode-map (kbd "down") 'planet-previous-day)


(provide 'planet)

(defun planet-date-deep-copy (date1)
  (setq date2 (decode-time (apply 'encode-time date1)))
  date2)

(defun planet-add-one-day (date1)
;; (setq date2 date1) --> this creates problem, is just a shallow copy
  (setq date2 (planet-date-deep-copy date1))
(setq day (nth 3 date2))
(setq day-incremented (1+ day))
(setf (nth 3 date2) day-incremented)
(setq date2 (decode-time (apply 'encode-time date2))) ;; this line "get s it correct again" in case the day "leaves its range" e.g. 40th of december (... 40 12 ...)
;; (apply 'encode-time (decode-time (current-time))) ;; this would be the equivalent "getting it right" the other way 'round
date2)

(defun planet-add-7-days (date1)
;; (setq date2 date1) --> this creates problem, is just a shallow copy
  (setq date2 (planet-date-deep-copy date1))
(setq day (nth 3 date2))
(setq day-incremented (+ day 7))
(setf (nth 3 date2) day-incremented)
(setq date2 (decode-time (apply 'encode-time date2))) ;; this line "get s it correct again" in case the day "leaves its range" e.g. 40th of december (... 40 12 ...)
;; (apply 'encode-time (decode-time (current-time))) ;; this would be the equivalent "getting it right" the other way 'round
date2)

(defun planet-date-add-days (date1 number-of-days-to-add)
;; (setq date2 date1) --> this creates problem, is just a shallow copy
  (setq date2 (planet-date-deep-copy date1))
(setq day (nth 3 date2))
(setq day-incremented (+ day number-of-days-to-add))
(setf (nth 3 date2) day-incremented)
(setq date2 (decode-time (apply 'encode-time date2))) ;; this line "get s it correct again" in case the day "leaves its range" e.g. 40th of december (... 40 12 ...)
;; (apply 'encode-time (decode-time (current-time))) ;; this would be the equivalent "getting it right" the other way 'round
date2)

(defun planet-date-subtract-days (date1 number-of-days-to-substract)
;; (setq date2 date1) --> this creates problem, is just a shallow copy
  (setq date2 (planet-date-deep-copy date1))
(setq day (nth 3 date2))
(setq day-incremented (- day number-of-days-to-substract))
(setf (nth 3 date2) day-incremented)
(setq date2 (decode-time (apply 'encode-time date2))) ;; this line "get s it correct again" in case the day "leaves its range" e.g. 40th of december (... 40 12 ...)
;; (apply 'encode-time (decode-time (current-time))) ;; this would be the equivalent "getting it right" the other way 'round
date2)

(defun planet-subtract-7-days (date1)
;; (setq date2 date1) --> this creates problem, is just a shallow copy
  (setq date2 (planet-date-deep-copy date1))
(setq day (nth 3 date2))
(setq day-incremented (- day 7))
(setf (nth 3 date2) day-incremented)
(setq date2 (decode-time (apply 'encode-time date2))) ;; this line "get s it correct again" in case the day "leaves its range" e.g. 40th of december (... 40 12 ...)
;; (apply 'encode-time (decode-time (current-time))) ;; this would be the equivalent "getting it right" the other way 'round
date2)

(defun planet-subtract-one-day (date1)
;; (setq date2 date1) --> this creates problem, is just a shallow copy
  (setq date2 (planet-date-deep-copy date1))
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
    )

(defun planet-create-week-org-files (&optional days)
    " creates week files in $ORG/daily/ . only for existing daily-files. simply, for each existing monday-file a nearly equal org-file-folder is created, where only ..._Mon is replaced by ..._week"
    (interactive)
    ;* filter daily-files for mondays
    (setq daily-file-folders (planet-get-all-daily-file-folders))
    (setq daily-file-folders (-filter (lambda (x) (string-match "^\..*_Mon\.org$" x)) daily-file-folders))
    (setq file-folder (nth 1 daily-file-folders))
    (dolist (file-folder daily-file-folders) 
      (setq file-folder-basename (file-name-base file-folder))
      ;; replace "Mon" by "week"
      (setq fixedcase t)
      (setq week-filefolder-basename (replace-regexp-in-string "Mon" "week" file-folder-basename fixedcase))
      (setq week-filebasename (replace-regexp-in-string "^." "" week-filefolder-basename))
      (setq week-filefullname (planet-convert-filebasename-to-filefullname week-filebasename))
      ;; create if not already exists
      (if (not (file-exists-p week-filefullname))
        (create-hidden-org-file-folder week-filebasename planet-daily-dir)
        (message (concat "hidden folder \"" week-filefullname "\" already exists."))
        )
      )
    ;;* run create symlinks to "update" symlinks (existing are not changed)
    (create-symlinks-for-all-hidden-org-file-folders planet-daily-dir)
    )

(defun planet-get-all-daily-file-folders ()
    (setq daily-file-folders (directory-files planet-daily-dir))
    ;;** filter
    (setq daily-file-folders (-filter (lambda (x) (string-match planet-regexp-daily-file-folder x)) daily-file-folders))
    (cd planet-daily-dir)
    (file-directory-p (nth 1 daily-file-folders))
    (setq daily-file-folders (-filter (lambda (x) (file-directory-p x)) daily-file-folders)) ;; get the wuckin symlinks out (above regex could not filter them, prob. elisp bug)
    ;;** extract year/month/day of last file
daily-file-folders)

(defun planet-get-all-daily-filebasenames ()
  "returns list of daily files with full path (full file names)"
    (setq daily-file-folders (planet-get-all-daily-file-folders))
    (setq daily-filebasenames ())
    (dolist (daily-file-folder daily-file-folders)
      ;; get the filebasename
      (setq this-filebasename (replace-regexp-in-string "^." "" daily-file-folder))
      (setq this-filebasename (replace-regexp-in-string "\.org$" "" this-filebasename))
      (push this-filebasename daily-filebasenames)
    )
    (setq daily-filebasenames (nreverse daily-filebasenames)) ;; (elisp does not have an efficient 'append'-function for lists, only 'push' --> so the best practice is to build a list with push and then reverse it (nreverse))
daily-filebasenames)

(defun planet-get-all-daily-filefullnames ()
  "returns list of daily files with full path (full file names)"
    (setq daily-file-folders (planet-get-all-daily-file-folders))
    (setq daily-filefullnames ())
    (dolist (daily-file-folder daily-file-folders)
      ;; get the filebasename
      (setq this-filebasename (replace-regexp-in-string "^." "" daily-file-folder))
      (setq this-filebasename (replace-regexp-in-string "\.org$" "" this-filebasename))
      (setq this-filefullname (planet-convert-filebasename-to-filefullname this-filebasename))
      (push this-filefullname daily-filefullnames)
    )
    (setq daily-filefullnames (nreverse daily-filefullnames)) ;; (elisp does not have an efficient 'append'-function for lists, only 'push' --> so the best practice is to build a list with push and then reverse it (nreverse))
daily-filefullnames)

(defun planet-get-last-daily-org-file-date ()
    ;; * get list of files
    (setq daily-filebasenames (planet-get-all-daily-filebasenames))
    (setq last-daily-filebasename (car (last daily-filebasenames)))

    ;; ;;diese scheiße mit groups hat überhaupt nicht geklappt (when (string-match ".\\([0-9][0-9]*\\)_\\([0-9][0-9]*\\)_\\([0-9][0-9]*\\)_...\.org$" last-daily-file-name) (match-string 1) etc.
    ;; (when (string-match ".[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]_...\.org$" last-daily-file-name)
    ;;   (setq year (string-to-number (substring last-daily-file-name 1 5)))
    ;;   (setq month (string-to-number (substring last-daily-file-name 6 8)))
    ;;   (setq day (string-to-number (substring last-daily-file-name 9 11)))
    ;;   )

    ;; * convert last filebase into date
    (setq last-date (planet-convert-filebasename-to-date last-daily-filebasename))
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



(defvar planet-dow-abbreviations '("Sun"  ;; 0
                        "Mon"  ;; 1
                        "Tue"  ;; 2
                        "Wed"  ;; 3
                        "Thu"  ;; 4
                        "Fri"  ;; 5
                        "Sat") ;; 6
  )

(defvar planet-dow-abbreviations-upcase '("SUN"  ;; 0
                        "MON"  ;; 1
                        "TUE"  ;; 2
                        "WED"  ;; 3
                        "THU"  ;; 4
                        "FRI"  ;; 5
                        "SAT") ;; 6
  )

(defvar planet-month-abbreviations '("zero_month_should_not_be"  ;; 0 (month 0 does not exist)
                        "Jan"  ;; 1
                        "Feb"  ;; 2
                        "Mar"  ;; 3
                        "Apr"  ;; 4
                        "May"  ;; 5
                        "Jun"  ;; 6
                        "Jul"  ;; 7
                        "Aug"  ;; 8
                        "Sep"  ;; 9
                        "Oct"  ;; 10
                        "Nov"  ;; 11
                        "Dec")  ;; 12
  )

(defvar planet-month-abbreviations-upcase '("zero_month_should_not_be"  ;; 0 (month 0 does not exist)
                        "JAN"  ;; 1
                        "FEB"  ;; 2
                        "MAR"  ;; 3
                        "APR"  ;; 4
                        "MAY"  ;; 5
                        "JUN"  ;; 6
                        "JUL"  ;; 7
                        "AUG"  ;; 8
                        "SEP"  ;; 9
                        "OCT"  ;; 10
                        "NOV"  ;; 11
                        "DEC")  ;; 12
  )


(defvar planet-month-fullnames-upcase '("zero_month_should_not_be"  ;; 0 (month 0 does not exist)
                        "JANUARY"  ;; 1
                        "FEBRUARY"  ;; 2
                        "MARCH"  ;; 3
                        "APRIL"  ;; 4
                        "MAY"  ;; 5
                        "JUNE"  ;; 6
                        "JULY"  ;; 7
                        "AUGUST"  ;; 8
                        "SEPTEMBER"  ;; 9
                        "OCTOBER"  ;; 10
                        "NOVEMBER"  ;; 11
                        "DECEMBER")  ;; 12
  )

(defvar planet-daily-dir (expand-file-name "~/org/daily"))
(defvar planet-dir (expand-file-name "~/org"))

(defun convert-dow-abbreviation (dow)
  (setq weekday-abbr (nth dow planet-dow-abbreviations))
 weekday-abbr)

(defun planet-convert-month-abbreviation (month)
  (setq month-abbr (nth month planet-month-abbreviations-upcase))
 month-abbr)

(defun create-daily-hidden-org-file(date)
  " creates daily file <year>_<month>_<day>_<weekdayname>.org for <date> in planet-daily-directory. 
    1 argument: date ...  format elisp date list (run decode-time first): (16 50 15 9 12 2019 1 nil 3600)
    "
  (interactive)
  ;;* concat file name 
  (setq filebasename (planet-convert-date-to-filebasename date))
  (create-hidden-org-file-folder filebasename planet-daily-dir)
  )

;; (setq date-raw-2 (time-add date-raw date-raw))
;; (decode-time date-raw)
;; (setq date2 (decode-time date-raw-2))

;; (setq t1 (encode-time 1 1 0 31 3 2019))
;; (decode-time (encode-time 1 1 0 33 3 2019))

;; (apply 'encode-time (decode-time (current-time)))

;; (setq a 3)
;; (format "%02i" a)

(defun planet-date-is-weekend (date)
  (setq dow (planet-date-get-dow date))
  (if (or (= dow 6) (= dow 0)) ;; (6=Sat, 0=Sun)
      (setq return-value t)
      (setq return-value nil))
  return-value)

(defun planet-date-is-workday (date)
  (setq dow (planet-date-get-dow date))
  (if (and (> dow 0) (< dow 6)) ;; (Mon-Fri = 1-5)
      (setq return-value t)
      (setq return-value nil))
  return-value)

(defun planet-date-is-today (datee)
  (setq date-today (planet-get-todays-date))
  (setq month-today (planet-date-get-month date-today))
  (setq day-today (planet-date-get-day date-today))

  (setq month (planet-date-get-month datee))
  (setq day (planet-date-get-day datee))
  (if (and (= month month-today) (= day day-today))
      (setq return-value t)
      (setq return-value nil))
    return-value)

(defun planet-current-buffer-is-day-file ()
  ;; get current buffer's file base
  (setq filebasename (file-name-sans-extension (buffer-name))) ;; todo --> (file-name-base ...)
  ;; (message filebasename)
  ;;                                            3 dots in regex: ..." --> do make sure week-files get filtered out
  (if (string-match "^[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]_...$" filebasename)
      (setq return_value t) 
      (setq return_value nil))
  return_value)
  ;; filebasename)

(defun planet-current-buffer-is-week-file ()
  ;; get current buffer's file base
  (setq filebasename (file-name-sans-extension (buffer-name)))
  (message filebasename)
  (if (string-match "^[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]_week$" filebasename)
      (setq return_value t) 
      (setq return_value nil))
  return_value)

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

(defun planet-get-todays-date ()
  (setq date (decode-time (current-time)))
  )

(defun planet-today ()
  (interactive)
  (setq date (planet-get-todays-date))
  (setq filebasename (planet-convert-date-to-filebasename date))
  (find-file (concat planet-daily-dir "/." filebasename ".org" "/" filebasename ".org"))
  )

(defun planet-this-week ()
  (interactive)
  (setq date-today (planet-get-todays-date))
  (planet-go-week-file-for-date date-today)
  )

;;test: (planet-open-today)
;;test: (planet-open-today)
(evil-leader/set-key "pt" 'planet-today)
(evil-leader/set-key "py" 'planet-this-week)



(defun planet-go-week-file-for-current-buffer-daily-file ()
  (interactive)
  (setq filebasename (file-name-sans-extension (buffer-name)))
  (setq this-file-date (planet-convert-filebasename-to-date filebasename))
  (planet-go-week-file-for-date this-file-date)
  )


(defun planet-get-previous-monday-date-for-date (date1)
;; (setq date-iter date1) --> this creates problem, is just a shallow copy
  (setq date-iter (planet-date-deep-copy date1))
  (setq dow_monday 1)
  (setq dow (planet-date-get-dow date-iter))
  (while (not (= dow dow_monday))
    (setq date-iter (planet-subtract-one-day date-iter))
    (setq dow (planet-date-get-dow date-iter))
    )
  ;; iterator date reached monday and is returned
  (setq date-previous-monday date-iter)
  date-previous-monday)

(defun planet-get-week-file-basename-for-date (date)
  (setq date-previous-monday (planet-get-previous-monday-date-for-date date))
  
  (setq found-monday-filebasename (planet-convert-date-to-filebasename date-previous-monday))
  (setq fixedcase t)
  (setq week-file-basename (replace-regexp-in-string "Mon" "week" found-monday-filebasename fixedcase))
  week-file-basename)


(defun planet-get-week-file-fullname-for-date (date)
  (setq week-file-basename (planet-get-week-file-basename-for-date date))
  (setq week-file-fullname (planet-convert-filebasename-to-filefullname week-file-basename))
  week-file-fullname)

(defun planet-go-week-file-for-date (date)
  (setq week-filebasename (planet-get-week-file-basename-for-date date))
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
    (when (string-match "[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]_...k?" filenamebase)
      ;; (this matches _Mon, _Fri etc. , OR _week)
      (setq year (string-to-number (substring filenamebase 0 4)))
      (setq month (string-to-number (substring filenamebase 5 7)))
      (setq day (string-to-number (substring filenamebase 8 10)))
      )
    ;;** set last-date
    (setq date (planet-create-date day month year))
date)




(defun planet-convert-filefullname-to-date (filefullname)
  (setq filebasename (planet-convert-filefullname-to-filebasename filefullname))
  (setq date (planet-convert-filebasename-to-date filebasename))
date)


(defun planet-convert-date-to-filebasename (date)
  (setq year  (format "%02i" (nth 5 date)))
  (setq month (format "%02i" (nth 4 date)))
  (setq day   (format "%02i" (nth 3 date)))

  (setq dow (nth 6 date))
  (setq weekday-abbr (convert-dow-abbreviation dow))

   (setq filebasename (concat year "_" month "_" day "_" weekday-abbr ))

  filebasename)

(defun planet-get-full-file-name-for-date (date)
  (setq filebasename (planet-convert-date-to-filebasename date))
  (setq full-file-name (planet-convert-filebasename-to-filefullname filebasename))
  full-file-name)

(defun planet-convert-filebasename-to-filefullname (filebasename)
  (setq filefullname (concat planet-daily-dir "/." filebasename ".org" "/" filebasename ".org"))
  filefullname)

(defun planet-convert-filefullname-to-filebasename (filefullname)
  (setq filebasename (file-name-base filefullname))
  filebasename)

;; open 'standard quick' notes.org file
(defun planet-open-quick-notes ()
  (interactive)
  (find-file (concat planet-dir "/" "lists/quick_notes.org"))
  )


;;* tag alignment
(defun planet-auto-align-tags () 
  (interactive)
  (setq org-tags-column (- 5 (window-body-width)))
  (org-align-all-tags)
  )


;;* week-view
;; arrange windows in frame in a 2X4-scheme:
;; 
;; |---------------------
;; |Mo  | Tu | We | Th   |
;; |---------------------
;; | Fr | Sa | Su | week |
;; |---------------------

;;** pseudo code:
;;*** save the frames window configuration (to return later when whished)
;; (setq winconf_before_weekview (current-window-configuration))
;; (set-window-configuration winconf_before_weekview)
;;*** set up the 2X4-scheme

;; global variables for getting handle to specific windows in a window-configuration

(defvar planet-view-state "none")

(defvar planet-view-states '("none"  ;; 0
                        "week2X4"  ;; 1
                        ) 
  ) ;; this is the allowed view states, variable at the moment not used, but it makes the concept clear, later maybe implement some check function (planet-view-state-exist "blabla-view") --> possibly throw error 

(defvar winconf_before_weekview)

(defvar win11)
(defvar win12)
(defvar win13)
(defvar win14)
(defvar win15)
(defvar win16)
(defvar win17)
(defvar win18)
(defvar win19)

(defvar win21)
(defvar win22)
(defvar win23)
(defvar win24)
(defvar win25)
(defvar win26)
(defvar win27)
(defvar win28)
(defvar win29)

(defvar win31)
(defvar win32)
(defvar win33)
(defvar win34)
(defvar win35)
(defvar win36)
(defvar win37)
(defvar win38)
(defvar win39)

(defvar win41)
(defvar win42)
(defvar win43)
(defvar win44)
(defvar win45)
(defvar win46)
(defvar win47)
(defvar win48)
(defvar win49)

(defun planet-return-windows-configuration ()
  (interactive)
  (set-window-configuration winconf_before_weekview)
  )

(defun planet-view-quit ()
  (interactive)
  (planet-return-windows-configuration)
  ;; ** set planet-view-state to "none"
  (setq planet-view-state "none")
  )
(evil-leader/set-key "q" 'planet-view-quit)

(defun planet-view-week2X4 ()
  (interactive)
  ;;* save the window configuration (later return to that on planet-view-quit)
  (setq winconf_before_weekview (current-window-configuration))
  ;;* make window matrix 2X4
  (planet-setup-windows-config-2X4)
  ;;* open day-files in the windows
  ;;** get the dates for mo,tu,we,th,fr,sa,su of current week
  ;;*** get today's date
  (setq date-today (planet-get-todays-date))
  (planet-view-week2X4-for-date date-today)
  ;; ** set planet-view-state to "view-week2X4"
  (setq planet-view-state "week2X4")
  (planet-view-week2X4-message-week-from-till)
  )


(defun planet-view-week2X4-for-date (date)
  ;; ;;*** get monday date for today's date, and dates for tuesday,wednesday,..., sunday
  (setq date-monday (planet-get-previous-monday-date-for-date date))
  (setq date-tuesday (planet-add-one-day date-monday))
  (setq date-wednesday (planet-add-one-day date-tuesday))
  (setq date-thursday (planet-add-one-day date-wednesday))
  (setq date-friday (planet-add-one-day date-thursday))
  (setq date-saturday (planet-add-one-day date-friday))
  (setq date-sunday (planet-add-one-day date-saturday))
  ;;** get (full) file-names  for all dates
  (setq file-monday (planet-get-full-file-name-for-date date-monday))
  (setq file-tuesday (planet-get-full-file-name-for-date date-tuesday))
  (setq file-wednesday (planet-get-full-file-name-for-date date-wednesday))
  (setq file-thursday (planet-get-full-file-name-for-date date-thursday))
  (setq file-friday (planet-get-full-file-name-for-date date-friday))
  (setq file-saturday (planet-get-full-file-name-for-date date-saturday))
  (setq file-sunday (planet-get-full-file-name-for-date date-sunday))

  (setq file-week (planet-get-week-file-fullname-for-date date))
  ;; ;;** create the buffers for all dates (not displayed, that the elegant trick ;) --> find-file-noselect as the working horse, low level function for all visiting file operations in elisp)
  (setq buffer-monday (find-file-noselect file-monday))
  (setq buffer-tuesday (find-file-noselect file-tuesday))
  (setq buffer-wednesday (find-file-noselect file-wednesday))
  (setq buffer-thursday (find-file-noselect file-thursday))
  (setq buffer-friday (find-file-noselect file-friday))
  (setq buffer-saturday (find-file-noselect file-saturday))
  (setq buffer-sunday (find-file-noselect file-sunday))

  (setq buffer-week (find-file-noselect file-week))
  ;; ;;** open the buffers in the window arrangement
  (set-window-buffer win11 buffer-monday) 
  (set-window-buffer win12 buffer-tuesday) 
  (set-window-buffer win13 buffer-wednesday) 
  (set-window-buffer win14 buffer-thursday) 
  (set-window-buffer win21 buffer-friday) 
  (set-window-buffer win22 buffer-saturday) 
  (set-window-buffer win23 buffer-sunday) 

  (set-window-buffer win24 buffer-week) 
  )

  ;; ** set planet-view-state to "view-week2X4"

(evil-leader/set-key "w" 'planet-view-week2X4)

(defun planet-setup-windows-config-2X4 ()
  (interactive)
  ;; creates ("empty") windows in a 2X4-matrix, equally distributed

  ;; create "empty frame" with one dummy buffer
  (planet-make-empty-frame-one-window)
  (setq win1 (selected-window))
  ;; subdivide in 2X4 windows configuration
  ;;* splitting nr. 1:
  ;; (divide horizontally (and save new window into variable (return value)) )
  (setq win2 (split-window win1 nil 'below))

  ;;* splitting nr. 2: 
  (setq win3 (split-window win1 nil 'right))
  (setq win4 (split-window win2 nil 'right))
;; ---------------
;; | win1 | win3 |
;; |-------------|
;; | win2 | win4 |
;; ---------------

  ;;* splitting nr. 3: 
  (setq win5 (split-window win1 nil 'right))
  (setq win6 (split-window win2 nil 'right))
;; ----------------------
;; | win1 | win5 |      win3 |
;; |---------------------
;; | win2 | win6 |      win4 |
;; ----------------------

  ;;* splitting nr. 4: 
  (setq win7 (split-window win3 nil 'right))
  (setq win8 (split-window win4 nil 'right))
;; -----------------------------
;; | win1 | win5 | win3 | win7 |
;; |----------------------------
;; | win2 | win6 | win4 | win8 |
;; -----------------------------

  ;; rename windows systematically
  (setq win11 win1)
  (setq win12 win5)
  (setq win13 win3)
  (setq win14 win7)
  (setq win21 win2)
  (setq win22 win6)
  (setq win23 win4)
  (setq win24 win8)
;; --------------------------------
;; | win11 | win12 | win13 | win14 |
;; |--------------------------------
;; | win21 | win22 | win23 | win24 |
;; ---------------------------------
  )


(defun planet-make-empty-frame-one-window ()
  (interactive)
  (switch-to-buffer "planet-dummy-buffer-empty-frame") ;; (this creates the buffer also if not already exists)
  ;; in emacs you cannot create a new window without a buffer, so this is the cleanest way
  ;; now visit this buffer
  ;; delete all other windows
  (delete-other-windows)
  )


(defun planet-next ()
  (interactive)
  (cond
        ;;if not in a view ...
        ((string= planet-view-state "none")
         (cond
            ;;if in dayfile --> forward day
            ((planet-current-buffer-is-day-file)
                (planet-next-day)
                )
            ;; if in week file --> forward week
            ((planet-current-buffer-is-week-file)
                (planet-next-week)
            )
            (t
             (message "planet: not in a view-state (see planet-view-state = 'none') and either in a day-file. cannot forward.")
             )
            )
         )
        ;;if in week view --> forward week
        ((string= planet-view-state "week2X4")
            (planet-view-week2X4-next)
            )
        ;; if view-state not valid
        (t
            (message "planet: view-state not valid.")
            )
        )
  )

(defun planet-previous ()
  (interactive)
  (cond
        ;;if not in a view ...
        ((string= planet-view-state "none")
         (cond
            ;;if in dayfile --> backward day
            ((planet-current-buffer-is-day-file)
                (planet-previous-day)
                )
            ;; if in week file --> forward week
            ((planet-current-buffer-is-week-file)
                (planet-previous-week)
            )
            (t
             (message "planet: not in a view-state (see planet-view-state = 'none') and either in a day-file. cannot forward.")
             )
            )
         )
        ;;if in week view --> forward week
        ((string= planet-view-state "week2X4")
            (planet-view-week2X4-previous)
            )
        ;; if view-state not valid
        (t
            (message "planet: view-state not valid.")
            )
        )
  )


(defun planet-view-week2X4-next ()
  ;; get date of monday (in window win11)
  (setq buffer-monday (window-buffer win11))
  (setq buffer-monday-filefullname (buffer-file-name buffer-monday))
  (setq buffer-monday-filebasename (file-name-base buffer-monday-filefullname))
  (setq date-monday (planet-convert-filebasename-to-date buffer-monday-filebasename))
  ;; add 7 days
  (setq date-monday-7days-forward (planet-add-7-days date-monday))
  ;; set up the windows win11, win12, etc. wit 
  (planet-view-week2X4-for-date date-monday-7days-forward)
  ;; make a message like: "1 Dec - 7 Dec"
  (planet-view-week2X4-message-week-from-till)
  )


(defun planet-view-week2X4-previous ()
  ;; get date of monday (in window win11)
  (setq buffer-monday (window-buffer win11))
  (setq buffer-monday-filefullname (buffer-file-name buffer-monday))
  (setq buffer-monday-filebasename (file-name-base buffer-monday-filefullname))
  (setq date-monday (planet-convert-filebasename-to-date buffer-monday-filebasename))
  ;; subtract 7 days
  (setq date-monday-7days-backward (planet-subtract-7-days date-monday))
  ;; set up the windows win11, win12, etc. wit 
  (planet-view-week2X4-for-date date-monday-7days-backward)

  ;; make a message like: "1 Dec - 7 Dec"
  (planet-view-week2X4-message-week-from-till)
  )


(defun planet-view-week2X4-message-week-from-till ()
  ;; get date of monday (in window win11)
  (setq buffer-monday (window-buffer win11))
  (setq buffer-monday-filefullname (buffer-file-name buffer-monday))
  (setq buffer-monday-filebasename (file-name-base buffer-monday-filefullname))
  (setq date-monday (planet-convert-filebasename-to-date buffer-monday-filebasename))

  (setq monday-day (planet-date-get-day date-monday))
  (setq monday-month (planet-date-get-month date-monday))
  (setq monday-month-abbr (planet-convert-month-abbreviation monday-month))

  ;; get date of sunday (in window win23)
  (setq buffer-sunday (window-buffer win23))
  (setq buffer-sunday-filefullname (buffer-file-name buffer-sunday))
  (setq buffer-sunday-filebasename (file-name-base buffer-sunday-filefullname))
  (setq date-sunday (planet-convert-filebasename-to-date buffer-sunday-filebasename))

  (setq sunday-day (planet-date-get-day date-sunday))
  (setq sunday-month (planet-date-get-month date-sunday))
  (setq sunday-month-abbr (planet-convert-month-abbreviation sunday-month))

  (message (concat (number-to-string monday-day) " " monday-month-abbr " -- " (number-to-string sunday-day) " " sunday-month-abbr))
  )

(defun planet-next-week ()
  ;; get date of current week file
  (setq this-weeks-date-monday (planet-get-daily-file-date))
  (setq date-7days-forward (planet-add-7-days this-weeks-date-monday))
  (planet-get-previous-monday-date-for-date date-7days-forward)
  (setq week-file (planet-get-week-file-fullname-for-date date-7days-forward))
  (find-file week-file)
  )

(defun planet-previous-week ()
  ;; get date of current week file
  (setq this-weeks-date-monday (planet-get-daily-file-date))
  (setq date-7days-backward (planet-subtract-7-days this-weeks-date-monday))
  (planet-get-previous-monday-date-for-date date-7days-backward)
  (setq week-file (planet-get-week-file-fullname-for-date date-7days-backward))
  (find-file week-file)
  )


;;* insert titles to all dayly files
;;(update --> redundant now --> solution now with buffer header-line)
;; (defun planet-all-daily-files-format-title ()
;;   (interactive)
;;   (planet-all-daily-files-delete-lines-until-first-org-heading)
;;   (planet-all-daily-files-insert-title)
;;   )

;; (defun planet-all-daily-files-insert-title ()
;;     (setq daily-filefullnames (planet-get-all-daily-filefullnames))
;;     (dolist (filefullname daily-filefullnames) 
;;       ;; (setq count 0)
;;       ;; (setq count (1+ count))
;;       ;; (setq filefullname (nth count daily-filefullnames))
;;       (planet-daily-file-insert-title filefullname)
;;       )
;;     )
;; (defun planet-all-daily-files-delete-lines-until-first-org-heading ()
;;     (setq daily-filefullnames (planet-get-all-daily-filefullnames))
;;     (dolist (filefullname daily-filefullnames) 
;;       ;; (setq count 0)
;;       ;; (setq count (1+ count))
;;       ;; (setq filefullname (nth count daily-filefullnames))
;;       (planet-daily-file-delete-lines-until-first-org-heading filefullname)
;;       )
;;     )

(defun planet-insert-string-as-first-line-to-file (file string)
  (with-temp-file file
    ;; this first line is necessary because "the way elisp/emacs works"...
    ;; (we create a new 'silent' buffer, which is empty at the beginning, then we create content and put ALL that content to 'file' OVERWRITING it, so as a first thing we have to add all file contents to the temporary buffer)
    (insert-file-contents file)
    ;; then we start actuall 'doing stuff'
    (goto-char 1)
    (newline)
    (goto-char 1)
    (insert string)
    )
  )

(defun planet-read-current-line ()
  (interactive)
  (move-beginning-of-line nil)
  (setq beginofline (point))
  (move-end-of-line nil)
  (setq endofline (point))
  (setq currentlinestring (buffer-substring beginofline endofline))
  (message currentlinestring)
  currentlinestring)

(defun planet-daily-file-delete-lines-until-first-org-heading (filefullname)
  (interactive)
  ;; (setq filefullname (planet-convert-filebasename-to-filefullname (planet-convert-date-to-filebasename (planet-date-add-days (planet-get-previous-monday-date-for-date (planet-get-todays-date)) 5))))
  ;; (setq tempfile "~/temp.txt")
  ;; (with-temp-file tempfile
  (with-temp-file filefullname
    (insert-file-contents filefullname)

    (beginning-of-buffer)

    ;;* while loop
    ;;** abort conditions 
    (setq org-heading-found nil)
    (setq end-of-buffer-reached nil)

    (setq continue t)
    (while continue 
      ;;** determine conditions

      ;;*** end of buffer reached?
      (setq end-off-buffer-reached (eobp))

      ;;*** org-heading found?
      (setq this-line (planet-read-current-line))
      (if (string-match "^\*\** .*$" this-line) ;; org-headings are : '* blabla' or '** blabla' etc.
          (setq org-heading-found t)
        )

      (setq continue (and (not org-heading-found) (not end-off-buffer-reached)))
      (if continue 
          (planet-delete-current-line)
        )
      )
    )
  )

;; (defun planet-daily-file-insert-title (fullfilename)
;;   ;; (setq filefullname (planet-convert-filebasename-to-filefullname (planet-convert-date-to-filebasename (planet-date-add-days (planet-get-previous-monday-date-for-date (planet-get-todays-date)) 5))))
;;   ;; get dow/day/month and format
;;   (setq date (planet-convert-filefullname-to-date filefullname))

;;   (setq dow (planet-date-get-dow date))
;;   (setq dow-abbr (nth dow planet-dow-abbreviations))

;;   (setq month (planet-date-get-month date))
;;   (setq month-abbr (nth month planet-month-abbreviations-upcase))
;;   (setq day (planet-date-get-day date))
;;   (setq day-string (number-to-string day))

;;   (setq title-string (concat "\*" dow-abbr " " day-string " " month-abbr"\*"))  
;;   (setq horizontal-rule-string "-------------")  

;;   (with-temp-file filefullname
;;     ;; this first line is necessary because "the way elisp/emacs works"...
;;     ;; (we create a new 'silent' buffer, which is empty at the beginning, then we create content and put ALL that content to 'file' OVERWRITING it, so as a first thing we have to add all file contents to the temporary buffer)
;;     (insert-file-contents filefullname)
;;     ;; then we start actuall 'doing stuff'
;;     (goto-char 1)
;;     (newline)
;;     (goto-char 1)
;;     (insert title-string)
;;     (newline)
;;     (insert horizontal-rule-string)
;;     )
;;   )


(defun planet-delete-current-line ()
  " like the equivalent of vim 'dd'"
  (interactive)
  (kill-whole-line)
  )

;;* set categories (work/tools/etc.)
(defun planet-set-category-work ()
  (interactive)
  (org-set-property "Category" "work")
  )
(evil-leader/set-key-for-mode 'org-mode "pw" 'planet-set-category-work) 

(defun planet-set-category-tools ()
  (interactive)
  (org-set-property "Category" "tools")
  )

(evil-leader/set-key-for-mode 'org-mode "pt" 'planet-set-category-tools) 

;;* concept/shortcuts for clock in / out / clocking tables / set tags "tools" "work" / etc. 

;;** konzept:
;;*** schnell taggen: work / tools / etc
;;**** schneller zugriff auf wichtigste mit SPC-p-<key> 
;;**** tag work --> SPC-p-w
(defun planet-add-tag-work ()
  (interactive)
  (planet-add-tag "work")
  )
;;**** tag tools --> SPC-p-t
(defun planet-add-tag-tools ()
  (interactive)
  (planet-add-tag "tools")
  )
;;*** guter shortcut für clock in/out / effort
;;**** clock in --> SPC-p-i
(evil-leader/set-key-for-mode 'org-mode "pi" 'planet-clock-in) 
;;**** clock out --> SPC-p-o
(evil-leader/set-key-for-mode 'org-mode "po" 'planet-clock-out) 
;;**** set effort --> SPC-p-e
(evil-leader/set-key-for-mode 'org-mode "pe" 'org-set-effort) 

(defun planet-clock-in ()
  (interactive)
  (org-clock-in)
  (planet-save)
  )

(defun planet-clock-out ()
  (interactive)
  (org-clock-out)
  (planet-save)
  )

;; default save behaviour in planet (possibly involving git up date)
(defun planet-save ()
  (interactive)
  (save-buffer)
  )


(defun planet-add-tag (newtag)
  (interactive)
  ;;get current tags
  (org-set-tags-to newtag)
  ;; align all tags
  (org-set-tags t t)
)

(defun planet-set-tag (newtag)
  (interactive)
  (org-set-tags-to newtag)
  ;; align all tags
  (org-set-tags t t)
)

(defun planet-mode-hook-workaround ()
  ;; put here everything for "start-up" of planet files/buffers
  ;; this is a workaround, since out-of-the-box planet-mode-hook does not work
  ;; this function is called on every open/revert/etc.
  (interactive)
  ;; (message "planet-mode start up script started...")
  ;; settings day-files
  (cond ( (planet-current-buffer-is-day-file)
          (planet-day-file-start-up)
          )
        ;; settings week-files
        ( (planet-current-buffer-is-week-file)
          (planet-week-file-start-up)
          )
        (t
         )
        )
  )

(defun planet-day-file-start-up ()
  ;; * header
  (planet-daily-file-set-header-line) 
  ;; * modeline (->remove)
  (setq mode-line-format "")
  ;; * default initial visibility ("overwrites" org-mode's initial visibility)
  (planet-level-2)
  )

(defun planet-week-file-start-up ()
  ;;* header
  (planet-week-file-set-header-line) 
  ;;* modeline (->remove)
  (setq mode-line-format "")
  )

;;* turn on planet-mode for the "right org-files (planet files)"
(add-hook 'org-mode-hook
         (lambda ()
           (if (planet-detect-if-planet-file)
               (progn
                 (planet-mode)
                 (planet-mode-hook-workaround)))))

;; detect planet mode
(defun planet-detect-if-planet-file ()
  (interactive)
  (setq is-planet-file nil)
  ;; easiest: check if it s in ~/org
   (setq file-path (file-name-directory buffer-file-name))
   (setq file-path (expand-file-name file-path)) ;; for security, converts e.g. ~ to /home/<user-name>
   (setq file-is-in-planet-dir nil)
   (if (string-match (concat "^" planet-dir ".*") file-path)
       (setq file-is-in-planet-dir t)
       (setq file-is-in-planet-dir nil)
       )

   (setq is-planet-file file-is-in-planet-dir)
   ;; (if is-planet-file
   ;;     (message (concat "file IS a planet file ; " file-path))
   ;;   (message (concat "file NOT a planet file ; " file-path))
   ;;   )
  is-planet-file)

(defvar planet-git-save-switch nil)

(defun planet-git-save-info ()
  (interactive)
  (if planet-git-save-switch
       (message "planet-git-save is switched ON.")
       (message "planet-git-save is switched OFF.")
     )
  )

(defun planet-git-save-toggle ()
  (interactive)
  (if planet-git-save-switch
      (planet-git-save-turn-off)
      (planet-git-save-turn-on)
    )
  )

(defun planet-git-save-turn-off ()
  (interactive)
  (if planet-git-save-switch
      (progn
        (remove-hook 'after-save-hook 'planet-git-sync-up-file)
        (setq planet-git-save-switch nil)
        (message "planet-git-save turned off.")
        )
    )
  )

(defun planet-git-save-turn-on ()
  (interactive)
  (if (not planet-git-save-switch)
      (progn
        ;; (add-hook 'before-save-hook 'planet-git-pull)
        (add-hook 'after-save-hook 'planet-git-sync-up-file)


	(setq planet-git-save-switch t)
        (message "planet-git-save turned on.")
        )
    )
  )
(defun planet-git-pull ()
  (interactive)
  (if (and (planet-detect-if-planet-file) (planet-last-git-save-long-enough-ago))
      (progn
	(setq command-string-pull "git pull -C ~/org"
        (shell-command command-string-pull)
        )
      )
  )
  )
;; ** set buffer-local exception from git-save (even when globally turned on)
;; to achieve for a buffer either:
;;   (1)  (make-local-variable 'planet-buffer-local-git-save-turned-off)
;;        (setq planet-buffer-local-git-save-turned-off t)
;;
;;or (2)  ((
(defvar planet-buffer-local-git-save-turned-off nil)

(defun planet-get-buffer-local-git-save-turned-off ()
  (interactive)
  (setq result nil)
  (if (boundp planet-buffer-local-git-save-turned-off)
      (if planet-buffer-local-git-save-turned-off
          (setq result t)))
  result)

(defun planet-git-sync-up-file ()
  (interactive)
  (cond ((not(planet-detect-if-planet-file))
         ;; (message "no planet file. no sync.")
         )
        ((planet-get-buffer-local-git-save-turned-off)
         (message "file saved. (but not synced, since buffer-locally sync turned off.)"))
        ((not (planet-last-git-save-long-enough-ago))
         (message "file saved. (but not synced, since last git-save not long enough ago.)"))
        (t
           (progn
             ;; (planet-update-last-git-save-time)
             ;; (setq command-string (concat "git add " buffer-file-name " && git commit -m '.' && git push"))
             ;; (message (concat "git-save process started (git add/commit/push)." ))

             ;; * (1) add/commit (all) this files changes (so they are safe! not overridden by pull)
             (setq command-string "git -C ~/org add -A")
             (message (concat "executing: " command-string))
             (shell-command command-string)
             (setq command-string "git  -C ~/org commit -m '.'")
             (message (concat "executing: " command-string))
             ;; * (2) pull (so make sure)
             (shell-command command-string)
             (setq command-string "git -C ~/org pull")
             (message (concat "executing: " command-string))
             ;; * (3) push (perform this last asynchronously to minimize "freeze"-time)
             (shell-command command-string)
             (setq command-string "git -C ~/org push")
             (message (concat "executing: " command-string))
             (async-shell-command command-string)
             ;; * update last gite-save-time
             (planet-update-last-git-save-time)
             ;; * update other planet buffers (may pull brought sth new)
             ;; (it is placed "some seconds" AFTER "git pull", because: technical detail: apparently not all files instantly updated when (shell-command "git pull") finishes.
             (sleep-for 0.5)
             (planet-revert-all-planet-buffers)
             (planet-level-0)
             (message "file saved. (and synced, since git-save turned on.)"))
             )))


(defun planet-git-sync-down-revert-file ()
  (interactive)
  (message (concat "git pull started..."))
  (shell-command "git pull")
  (message (concat "git-pulled."))
  (revert-buffer)
  )
(defun planet-revert-all-planet-buffers ()
  (interactive)
  ;; (message "syncing down planet-files - started.")
  ;; (shell-command (concat "cd " planet-dir "; git pull ") "*planet process: git pull*")
  ;; later:

  ;; ('stolen' from org-revert-all-org-buffers - seems to be thought in it for efficiency)

  ;; (todo "little cosmetics: this function still issues message of last reverted buffer filebase-name, don t know why)
  (save-excursion
    (save-window-excursion
      (dolist (b (buffer-list))
	(when (and (with-current-buffer b (bound-and-true-p planet-mode))
		   (with-current-buffer b buffer-file-name))
          (pop-to-buffer-same-window b)
          (revert-buffer t 'no-confirm)))
      )
    )
  )

(defun planet-revert-all-planet-buffers-except-current ()
  (interactive)
  ;; (message "syncing down planet-files - started.")
  ;; (shell-command (concat "cd " planet-dir "; git pull ") "*planet process: git pull*")
  ;; later:

  ;; ('stolen' from org-revert-all-org-buffers - seems to be thought in it for efficiency)

  ;; (todo "little cosmetics: this function still issues message of last reverted buffer filebase-name, don t know why)
  (setq current-buffer-original (current-buffer))
  (save-excursion
    (save-window-excursion
      (dolist (b (delq current-buffer-original (buffer-list)))
	(when (and (with-current-buffer b (bound-and-true-p planet-mode))
		   (with-current-buffer b buffer-file-name)
                   (with-current-buffer b (buffer-file-name))
                   )
          (pop-to-buffer-same-window b)
          (revert-buffer t 'no-confirm)))
      )
    )
  )
(evil-leader/set-key-for-mode 'org-mode "pp" 'planet-revert-all-planet-buffers)
;;*** git save critical last time

(defvar planet-last-git-save-time)
(setq planet-last-git-save-time (planet-get-todays-date))

(defvar planet-last-git-save-minimum-number-of-seconds-ago)
(setq planet-last-git-save-minimum-number-of-seconds-ago 15)

(defun planet-update-last-git-save-time ()
  (setq planet-last-git-save-time (planet-get-todays-date))
  )

(defun planet-last-git-save-long-enough-ago ()
  ;; get current time
  (setq current-time (planet-get-todays-date))
  (setq current-time-encoded (apply 'encode-time current-time))
  (setq planet-last-git-save-time-encoded (apply 'encode-time planet-last-git-save-time))
  ;; difference in seconds
  (setq time-diff-seconds (float-time (time-subtract current-time-encoded planet-last-git-save-time-encoded)))
  (if (> time-diff-seconds  planet-last-git-save-minimum-number-of-seconds-ago) 
      (setq result t)
      (setq result nil)
      )
  result)
;;* default appearance on open file
;;** option1: show 3 levels
(add-hook 'planet-mode-hook
         (lambda ()
           (org-content 3) ;; show 3 levels
          ))

(defun planet-level-1-all ()
  (interactive)

  ;; ('stolen' from org-revert-all-org-buffers - seems to be thought in it for efficiency)
  (save-excursion
    (save-window-excursion
      (dolist (b (buffer-list))
	(when (and (with-current-buffer b (bound-and-true-p planet-mode))
		   (with-current-buffer b buffer-file-name))
          (pop-to-buffer-same-window b)
          (planet-level-1)
          ))
      )
    )
  )

(defun planet-level-0-all ()
  (interactive)

  ;; ('stolen' from org-revert-all-org-buffers - seems to be thought in it for efficiency)
  (save-excursion
    (save-window-excursion
      (dolist (b (buffer-list))
	(when (and (with-current-buffer b (bound-and-true-p planet-mode))
		   (with-current-buffer b buffer-file-name))
          (pop-to-buffer-same-window b)
          (outline-show-all)
          ))
      )
    )
  )

(evil-leader/set-key-for-mode 'org-mode "o1" 'planet-level-1-all)
(evil-leader/set-key-for-mode 'org-mode "o2" 'planet-level-2-all)
(evil-leader/set-key-for-mode 'org-mode "o3" 'planet-level-3-all)
(evil-leader/set-key-for-mode 'org-mode "o0" 'planet-level-0-all)

(evil-leader/set-key-for-mode 'org-mode "p1" 'planet-level-1)
(evil-leader/set-key-for-mode 'org-mode "p2" 'planet-level-2)
(evil-leader/set-key-for-mode 'org-mode "p3" 'planet-level-3)
(evil-leader/set-key-for-mode 'org-mode "p0" 'planet-level-0)

(defun planet-level-2-all ()
  (interactive)
  ;; ('stolen' from org-revert-all-org-buffers - seems to be thought in it for efficiency)
  (save-excursion
    (save-window-excursion
      (dolist (b (buffer-list))
	(when (and (with-current-buffer b (bound-and-true-p planet-mode))
		   (with-current-buffer b buffer-file-name))
          (pop-to-buffer-same-window b)
          (planet-level-2)
          ))
      )
    )
  )

(defun planet-level-3-all ()
  (interactive)
  ;; ('stolen' from org-revert-all-org-buffers - seems to be thought in it for efficiency)
  (save-excursion
    (save-window-excursion
      (dolist (b (buffer-list))
	(when (and (with-current-buffer b (bound-and-true-p planet-mode))
		   (with-current-buffer b buffer-file-name))
          (pop-to-buffer-same-window b)
          (planet-level-3)
          ))
      )
    )
  )

(defun planet-level-0 ()
  (interactive)
  (org-global-cycle 0)
  )
(defun planet-level-1 ()
  (interactive)
  (org-global-cycle 1)
  )

(defun planet-level-2 ()
  (interactive)
  (org-global-cycle 2)
  )

(defun planet-level-3 ()
  (interactive)
  (org-global-cycle 3)
  )


;;* planet header-line
(defvar planet-daily-file-header-line-weekend-color-foreground)
(setq planet-daily-file-header-line-week-end-color-foreground "ivory")
(defvar planet-daily-file-header-line-weekend-color-background)
(setq planet-daily-file-header-line-week-end-color-background "DarkOrange2")

(defvar planet-daily-file-header-line-workday-color-foreground)
(setq planet-daily-file-header-line-workday-color-foreground "ivory")
(defvar planet-daily-file-header-line-workday-color-background)
(setq planet-daily-file-header-line-workday-color-background "DarkOrange2")

(defvar planet-daily-file-header-line-currentday-color-foreground)
(setq planet-daily-file-header-line-currentday-color-foreground "ivory")
(defvar planet-daily-file-header-line-currentday-color-background)
(setq planet-daily-file-header-line-currentday-color-background "DarkOrange2")

(defun planet-daily-file-set-header-line ()
  (interactive)
  (setq filefullname buffer-file-name)
  ;;* get date components
  (setq date (planet-get-daily-file-date))
  (setq dow (planet-date-get-dow date))
  (setq dow-abbr (nth dow planet-dow-abbreviations))

  (setq month (planet-date-get-month date))
  (setq month-abbr (nth month planet-month-abbreviations-upcase))
  (setq day (planet-date-get-day date))
  (setq day-string (number-to-string day))

  ;;* compose string
  (setq title-string (concat dow-abbr " " day-string " " month-abbr))  

  ;;* face appearance (fore/background color, bold, italic, etc.)
  (cond ( (planet-date-is-workday date)
          (setq background-color "#42ecf5")
          (setq foreground-color "black")
        )
        ( (planet-date-is-weekend date)
          (setq background-color "#42f5aa") ;; turqoise
          (setq foreground-color "black")
        )
        )

  ;;** special action --> special color today
  (if (planet-date-is-today date)
      (progn
          (setq background-color "#8a42f5") ;; violet for today 
          (setq foreground-color "white")
        )
    )
  ;; (face-remap-add-relative 'header-line '((:foreground foreground-color :background background-color) header-line))
  (face-remap-add-relative 'header-line :foreground foreground-color)
  (face-remap-add-relative 'header-line :background background-color)
  (face-remap-add-relative 'header-line :weight 'bold)
:weight 'bold
  ;;* show header line
  (setq header-line-format title-string)
  )

(defun planet-week-file-set-header-line ()
  (interactive)
  (setq filefullname buffer-file-name)
  ;;* get date components
  (setq date (planet-get-daily-file-date))
  (setq dow (planet-date-get-dow date))
  (setq dow-abbr (nth dow planet-dow-abbreviations))

  (setq month (planet-date-get-month date))
  (setq month-abbr (nth month planet-month-abbreviations-upcase))
  (setq day (planet-date-get-day date))
  (setq day-string (number-to-string day))

  ;; get date 6+
  (setq date-6-plus (planet-date-add-days date 6))
  (setq dow-6-plus (planet-date-get-dow date-6-plus))
  (setq dow-abbr-6-plus (nth dow-6-plus planet-dow-abbreviations))

  (setq month-6-plus (planet-date-get-month date-6-plus))
  (setq month-abbr-6-plus (nth month-6-plus planet-month-abbreviations-upcase))
  (setq day-6-plus (planet-date-get-day date-6-plus))
  (setq day-string-6-plus (number-to-string day-6-plus))

  ;;* compose string
  (setq title-string (concat "week " day-string " " month-abbr " - " day-string-6-plus " " month-abbr-6-plus))  

  ;;* face appearance (fore/background color, bold, italic, etc.)
  (setq background-color "#f5e342")
  (setq foreground-color "black")
  ;; (face-remap-add-relative 'header-line '((:foreground foreground-color :background background-color) header-line))
  (face-remap-add-relative 'header-line :foreground foreground-color)
  (face-remap-add-relative 'header-line :background background-color)
  (face-remap-add-relative 'header-line :weight 'bold)
  ;;* show header line
  (setq header-line-format title-string)
  )


  (defun sl/make-header ()
    ""
    (let* ((sl/full-header (abbreviate-file-name buffer-file-name))
           (sl/header (file-name-directory sl/full-header))
           (sl/drop-str "[...]"))
      (if (> (length sl/full-header)
             (window-body-width))
          (if (> (length sl/header)
                 (window-body-width))
              (progn
                (concat (with-face sl/drop-str
                                   :background "blue"
                                   :weight 'bold
                                   )
                        (with-face (substring sl/header
                                              (+ (- (length sl/header)
                                                    (window-body-width))
                                                 (length sl/drop-str))
                                              (length sl/header))
                                   ;; :background "red"
                                   :weight 'bold
                                   )))
            (concat (with-face sl/header
                               ;; :background "red"
                               :foreground "#8fb28f"
                               :weight 'bold
                               )))
        (concat (with-face sl/header
                           ;; :background "green"
                           ;; :foreground "black"
                           :weight 'bold
                           :foreground "#8fb28f"

)
                (with-face (file-name-nondirectory buffer-file-name)
                           :weight 'bold
                           ;; :background "red"
                           )))))
  (defun sl/display-header ()
    (interactive)
    (setq header-line-format
          '("" ;; invocation-name
            (:eval (if (buffer-file-name)
                       (sl/make-header)
                     "%b")))))

