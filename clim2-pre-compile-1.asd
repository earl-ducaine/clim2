
;; (progn

;;   (format t
;; 	  (asdf::run-program
;; 	   "export HOST=linux; make"
;; 	   :output :string))
;;   ;; (load "load-clim.lisp")
;;   )
;; (load "/home/rett/dev/common-lisp/clim2/cat.lisp")


(load "misc/compile-1.lisp")

(asdf:defsystem :clim2-pre-compile-1
    :depends-on ()
    :serial t
    :components
    (
     ;;     (:file "misc/compile-1")
;;;     (:file "misc/compile-1")

     ))
