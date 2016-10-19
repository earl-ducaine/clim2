

(pushnew :ansi-90 *features*)

(setq comp:declared-fixnums-remain-fixnums-switch
      (named-function |(> speed 2)|
		      (lambda (safety size speed debug compilation-speed)
			(declare (ignore safety size debug compilation-speed))
			(> speed 2))))

(setf (logical-pathname-translations "clim2")
      (list (list ";**;*.*"
		  (format nil "~A**/*.*"
			  (directory-namestring
			   (make-pathname
			    :directory
			    (butlast (pathname-directory
				      *load-pathname*))))))))


(eval-when (compile load eval)
  (load "sys/sysdcl.lisp"))

(setf (sys:gsgc-switch :print) t)

(defvar sys::*clim-library-search-path*
  '("/usr/X11/lib/"
    "/usr/X11R6/lib/"
    "/usr/local/lib/"
    "/opt/local/lib/"
    "/sw/lib/"))

(cl:in-package #:user)

(unless (ff:get-entry-point (ff:convert-foreign-name "XmCreateMyDrawingArea"))
  (load "./liblib_motif_wrapper.so"))
