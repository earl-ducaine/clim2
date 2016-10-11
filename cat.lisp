

(load "misc/compile-1.lisp")
(setf (sys:gsgc-switch :print) t)
(concatenate-system 'motif-clim-cat "./climxm.fasl")

(defvar sys::*clim-library-search-path* '("/usr/X11/lib/" "/usr/X11R6/lib/" "/usr/local/lib/"
                                          "/opt/local/lib/" "/sw/lib/"))
(cl:in-package #:user)

(unless (ff:get-entry-point (ff:convert-foreign-name "XmCreateMyDrawingArea"))
    (load "./climxm.so"))
