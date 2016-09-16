(load "misc/compile-1.lisp")
(setf (sys:gsgc-switch :print) t)
(concatenate-it (quote motif-clim))
