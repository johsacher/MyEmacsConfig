;; format of daily files: <year>_<month>_<day>_<weekday>.org
;; format of weekly files: <year>_<month>_<day>_week.org

;;* Todos
;;** insert/replace (=update) titles all files: MONDAY 16 DEC / 16-22 December
;;** calendar-date picker
;;** week view (8 windows, quit-week-view --> winner-undo/or better: remember windows arrangement and go back) + move forward week
;;** month view
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

(defun planet-current-buffer-is-day-file ()
  ;; get current buffer's file base
  (setq filebasename (file-name-sans-extension (buffer-name)))
  (message filebasename)
  (setq return_value (string-match "^[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]_...$" filebasename))
  return_value)
  ;; filebasename)

(defun planet-current-buffer-is-week-file ()
  ;; get current buffer's file base
  (setq filebasename (file-name-sans-extension (buffer-name)))
  (message filebasename)
  (setq return_value (string-match "^[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]_week$" filebasename))
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
  (setq date planet-get-todays-date)
  (setq filebasename (planet-convert-date-to-filebasename date))
  (find-file (concat planet-daily-dir "/." filebasename ".org" "/" filebasename ".org"))
  )
;;test: (planet-open-today)
(evil-leader/set-key "t" 'planet-today)
(evil-leader/set-key "y" 'planet-this-week)

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

(defun planet-get-previous-monday-date-for-date (date1)
;; (setq date-iter date1) --> this creates problem, is just a shallow copy
  (setq date1 (planet-get-todays-date))
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
  (setq date-previous-monday (planet-get-previous-monday-date-for-date todaysdate))
  
  (setq found-monday-filebasename (planet-convert-date-to-filebasename date-previous-monday))
  (setq fixedcase t)
  (setq week-file-basename (replace-regexp-in-string "Mon" "week" found-monday-filebasename fixedcase))
  week-file-basename)


(defun planet-get-week-file-fullname-for-date (date)
  (setq week-file-basename (planet-get-week-file-basename-for-date date))
  (setq week-file-fullname (planet-convert-filebasename-to-filefullname week-file-basename))
  week-file-fullname)

(defun planet-go-week-file-for-date (date)
  (setq week-filebasename (planet-get-week-file-basename-for-date date)
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

(defun planet-get-full-file-name-for-date (date)
  (setq filebasename (planet-convert-date-to-filebasename date))
  (setq full-file-name (planet-convert-filebasename-to-full-file-name filebasename))
  full-file-name)

(defun planet-convert-filebasename-to-filefullname (filebasename)
  (setq filefullname (concat planet-daily-dir "/." filebasename ".org" "/" filebasename ".org"))
  filefullname)

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

(defvar planet-view-state)

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
  ;; ;;*** get monday date for today's date, and dates for tuesday,wednesday,..., sunday
  (setq date-monday (planet-get-previous-monday-date-for-date date-today))
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

  (setq file-week (planet-get-week-file-fullname-for-date date-today))
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

  ;; ** set planet-view-state to "view-week2X4"
  (setq planet-view-state "week2X4")
  )

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
        ((string= planent-view-state "none")
        ;;if in dayfile --> forward day
            (if (planet-current-buffer-is-day-file)
                (planet-next-day)
                (message "planet: not in a view-state and either in a day-file. cannot forward.")
                )
            )
        ;;if in week view --> forward week
        ((string= txt-format-text "week2X4")
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
        ((string= planent-view-state "none")
        ;;if in dayfile --> backward day
            (if (planet-current-buffer-is-day-file)
                (planet-previous-day)
                (message "planet: not in a view-state and either in a day-file. cannot backward.")
                )
            )
        ;;if in week view --> forward week
        ((string= txt-format-text "week2X4")
            (planet-view-week2X4-previous)
            )
        ;; if view-state not valid
        (t
            (message "planet: view-state not valid.")
            )
        )
  )
