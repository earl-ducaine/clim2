

(load "misc/compile-1.lisp")
(setf (sys:gsgc-switch :print) t)
(concatenate-system 'motif-clim-cat "./climxm.fasl")
