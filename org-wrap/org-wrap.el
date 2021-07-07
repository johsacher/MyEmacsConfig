;; basic concept/convention:
;;
;; testdoc.pdf                  (wrap-directory)
;;           |
;;           |__ testdoc.pdf    (wrapped-file)
;;           |
;;           |__ testdoc.pdf.org (meta-file)
;;
;;                   * [[file:testdoc.pdf]]      (heading with UUID for file stored here)
;;                     :PROPERTIES:
;;                     :ID:  a9cad6b-803e-448a-aae9-de8fe3684249
;;                     :END:
;;
;;
;; basic functionalities:
;; * wrap a file (e.g. testdoc.pdf -> testdoc.pdf/testdoc.pdf)
;; * link to a (wrapped) file
;; ** (defun open-link-wrapped-file ()... -> e.g. quickly open linked wrapped pdf  
;; ** (defun open-link-wrapped-meta-file ()... 
;; * rename wrapped file -> rename (1) wrapped-file (2) wrap-dir (3) meta-file (4) link in meta-file 
;; ** however: when the user manually renames something -> links do not get broken :), can be cleaned up automatically for the user 



(defun org-wrap-file ()
  "Wraps a file (any type) into an org-wrapped file. I.e.:
   - creates folder of same name (testdoc.pdf)
   - moves file there (testdoc.pdf/testdoc.pdf
   - creates an org-wrap-meta-file of same name with additionally .org-extension (testdoc.pdf/testdoc.pdf.org)
   - inserts a heading with a unique id (*testdoc.pdf.org -> with property ID: <uuid>) 
"
  (interactive)

  )

