;; at the moment ABORTED, just could not get proficiant with removing duplicates from my file list 

(defvar ssh-config-file-path (expand-file-name "~/.ssh"))
(defvar ssh-config-file-name "config")
(defvar ssh-config-file-fullname (concat ssh-config-file-path "/" ssh-config-file-name))

(defun sshscreen-read-lines-file (filePath)
  "Return a list of lines of a file at filePath."
  (with-temp-buffer
    (insert-file-contents filePath)
    (split-string (buffer-string) "\n" t)))

(defun sshscreen-get-ssh-host-alias-list ()
  (let ((case-fold-search t)) ;; case-insensitive search
    ;; ** create regular expression
    (setq pattern-host-alias-line
            (rx line-start
                (zero-or-more blank)
                "host"
                (one-or-more blank)
                (group-n 1 (one-or-more (not blank)))
                line-end
                )
            )
    (setq host-alias-list ())
    (setq lines (sshscreen-read-lines-file ssh-config-file-fullname))
    (dolist (line lines)
        ;; (setq line (nth 1 lines))
        ;; * check if line matches "Host <alias-name>"
        (setq match-data (s-match-strings-all pattern-host-alias-line line))
        (if match-data
            (progn
            (setq this-alias (nth 1 (nth 0 match-data)))
            (push this-alias host-alias-list))
            )
        )
    (setq host-alias-list (nreverse host-alias-list))
    )
 host-alias-list)

(defun sshscreen-get-ssh-hostname-list ()
  (let ((case-fold-search t)) ;; case-insensitive search
    ;; ** create regular expression
    (setq pattern-hostname-line
            (rx line-start
                (zero-or-more blank)
                "hostname"
                (one-or-more blank)
                (group-n 1 (one-or-more (not blank)))
                line-end
                )
            )
    (setq hostname-list ())
    (setq lines (sshscreen-read-lines-file ssh-config-file-fullname))
    (dolist (line lines)
        ;; (setq line (nth 1 lines))
        ;; * check if line matches "Host <name-name>"
        (setq match-data (s-match-strings-all pattern-hostname-line line))
        (if match-data
            (progn
            (setq this-hostname (nth 1 (nth 0 match-data)))
            (push this-hostname hostname-list))
            )
        )
    )
  (setq hostname-list (nreverse hostname-list))
  hostname-list)

;; outcommented, because "push-back" is not a good practice in elisp, and does not exist. use push / nreverse instead
;; (defun sshscreen-push-to-end-of-list (list element)
;;   (setq lst (append list `(,element)))
;;   ;; when not familiar with lisp, this seems really weird
;;   ;; explanation: `(...) --> same as '(...) BUT optionally evaluate element with preceding ,
;;   ;; so by e.g. if element is "b", we achieve to create this list: ("b") , which can be appended 
;;   )

(defun sshscreen-get-ssh-host-name-list-unique ()
  (setq alias-list (sshscreen-get-ssh-host-alias-list))
  (setq host-list (sshscreen-get-ssh-host-name-list))
  ;; check host for duplicates
  (setq result (sshscreen-list-duplicates hostname-list))
  (dolist (item result)
    )
  )

(setq 
(sshscreen-list-duplicates '("a" "b" "b" "a" "b" "c" "c" "g"))


(defun sshscreen-list-duplicates (LIST) "
taken from: https://stackoverflow.com/questions/49005589/elisp-how-to-find-list-duplicates
Returns `nil' when LIST has no duplicates.
Otherise, returns a `list' of `cons's.
In each list element:
- the `car' is the element of LIST which has duplicates.
- the `cdr' is a list of the positions where the duplicates are found."
   (interactive)
   ;; res1 = result
   ;; unique1 = LIST with duplicates removed
   (let      (
              (unique1 (remove-duplicates LIST :test #'string-equal))
              (res1 '())
              (pos-list ()) ;; (my add-on code)
                )
     (if (eq LIST unique1)
     nil
       (progn
     (dolist (x unique1)
       ;; i = incrementor
       ;; pos1 = list of postions of duplicates
       (let (y (i 0) (pos1 '()))
         (while (member x LIST)
           (set 'y (seq-position LIST x))
           (when (> i 0)
         (push y pos1))
           (set 'i (+ 1 i))
           (set 'LIST
            (substitute (concat x "1") x LIST :test #'string-equal :count 1)))
         (push (cons x (nreverse pos1)) res1)))

     (pos-list)))))

(defun report-dups (xs)
  (let ((ys  ()))
    (while xs
      (unless (member (car xs) ys) ; Don't check it if already known to be a dup.
        (when (member (car xs) (cdr xs)) (push (car xs) ys)))
      (setq xs  (cdr xs)))
    ys))


;; * TRASH
;; (defun sshscreen-get-file-keyword ()
;;   "get the value from a line like this
;; Host blogin1 
;; in a file (this is typical line in ~/.ssh/config to introduce a ssh key alias)."
;;   (interactive)
;;   (setq keyword "host")

;;   ;; a little 'let' explanation: emacs (unfortunately has so-called 'dynamic scope', unlike most other languages which have static(=lexical) scope. so this means that NOT the 'most inner' variable is looked up, but 'the last' (in stack).
;;   ;; now 'let' remedies this by "forcing" local (i.e. like would be in lexical scope) scope like in the "normal" languages.
;;   ;; 
;;   ;; let has 3 parts: (  let   variables   body )
;;   ;;                      ^        ^        ^
;;   ;;                    part1    part2    part3
;;   ;; part 1: let
;;   (let
;;       ;;
;;       ;; let part 2: local scope variables  ( (var1 value1) (var2 value2) ... )
;;       ((case-fold-search t) ;; ~/.ssh/config IS CASE INSENSITIVE (!) -> so search also case insensitive
;;         ;; (re (concat "^" keyword " *[ \t]+\\([^\t\n]+\\)" KEYWORD)))
;;        (re (concat "^[ \t]+" keyword "[ \t]+" "\\([^\t\n]+\\)")))

;;       ;; let part 3: body  ( statement1 ) (statement2 ) ...
;;     (if (not (save-excursion
;;                (or (re-search-forward re nil t)
;;                    (re-search-backward re nil t))))
;;         (error (concat "No line containing " keyword " value found")))
;;     (match-string 1)

;;     )
;;   )
