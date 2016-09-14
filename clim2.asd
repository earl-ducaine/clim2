
(progn
  (format t
	  (asdf::run-program
	   "export HOST=linux; make"
	   :output :string))
  (load "load-clim.lisp"))

(asdf:defsystem :clim2
    :depends-on ()
    :components
     ((:module demo
	       :depends-on (:package)
	       :serial t
 	     :components
 	     (
	      ;; (:file "address-book")
;; 	      ;; (:file "bitmap-editor")
;; 	      ;; (:file "browser")
;; 	      ;; (:file "cad-demo")
;; 	      ;; (:file "cload-demos")
;; 	      ;; (:file "color-editor")
;; 	      ;; (:file "custom-records")
;; 	      ;; (:file "default-frame-top-level")
;; 	      ;; (:file "demo-activity")
;; 	      ;; (:file "demo-driver")
;; 	      ;; (:file "demo-last")
;; 	      ;; (:file "demo-prefill")
;; 	      ;; (:file "graphics-demos")
;; 	      ;; (:file "graphics-editor")
;; 	      ;; (:file "ico")
;; 	      ;; (:file "japanese-graphics-editor")
;; 	      ;; (:file "listener")
;; 	      ;; (:file "navdata")
;; 	      ;; (:file "navfun")
;; 	      ;; (:file "output-record")
	      (:file "packages")
;; 	      ;; (:file "palette")
;; 	      ;; (:file "peek-frame")
;; 	      ;; (:file "plot")
;; 	      ;; (:file "printer")
;; 	      ;; (:file "process-browser")
;; 	      ;; (:file "puzzle")
;; 	      ;; (:file "sysdcl")
;; 	      ;; (:file "sysdcl-pc")
;; 	      ;; (:file "thinkadot")
;; 	      ;; (:file "winlisp")
 	      ))
      (:file "package")
      (:file "clim-example" :depends-on (:demo))
      ))
