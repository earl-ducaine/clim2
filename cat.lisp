

(pushnew :ansi-90 *features*)

;; (setq comp:declared-fixnums-remain-fixnums-switch
;;       (named-function |(> speed 2)|
;; 		      (lambda (safety size speed debug compilation-speed)
;; 			(declare (ignore safety size debug compilation-speed))
;; 			(> speed 2))))

(setf (logical-pathname-translations "clim2")
      (list (list ";**;*.*"
		  (format nil "~A**/*.*"
			  (directory-namestring
			   (make-pathname
			    :directory
			    (butlast (pathname-directory
				      *load-pathname*))))))))

(in-package :cl-user)

(eval-when (compile load eval)

;;; Tell the world that we're here
;;;--- These need to be in the CLIM.fasl also.
;;;--- Currently they're in EXCL-VERIFICATION but that does not seem the best place.
  (pushnew :clim *features*)
  (pushnew :clim-2 *features*)
  (pushnew :clim-2.1 *features*)
  (pushnew :silica *features*)
  (pushnew :clim-uses-lisp-stream-classes *features*)
  (pushnew :clim-uses-lisp-stream-functions *features*)
  (pushnew :clim-ansi-conditions *features*)
  (pushnew :allegro-v4.0-constructors *features*))

(declaim (declaration non-dynamic-extent))

;; (eval-when (compile load eval)
;;   (load "sys/sysdcl.lisp"))

;; (setf (sys:gsgc-switch :print) t)

;; (defvar sys::*clim-library-search-path*
;;   '("/usr/X11/lib/"
;;     "/usr/X11R6/lib/"
;;     "/usr/local/lib/"
;;     "/opt/local/lib/"
;;     "/sw/lib/"))


(defpackage :cffi-user
    (:use :common-lisp :cffi))

  (in-package :cffi-user)

(define-foreign-library libcurl
    (:darwin (:or "libcurl.3.dylib" "libcurl.dylib"))
    (:unix (:or "./liblib_motif_wrapper.so"))
    (t (:default "libcurl")))


(unless (ff:get-entry-point (ff:convert-foreign-name "XmCreateMyDrawingArea"))
  (load (merge-pathnames (asdf:system-source-directory :clim2)
			 "liblib_motif_wrapper.so")))
