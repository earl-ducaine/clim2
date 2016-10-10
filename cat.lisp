;;(load "misc/compile-1.lisp")

(eval-when (compile load eval)
  (load "misc/compile-1.lisp")
  (setf (sys:gsgc-switch :print) t)
  (concatenate-it (quote motif-clim))
  )
