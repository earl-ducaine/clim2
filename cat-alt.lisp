
#+use-cffi
(eval-when (eval load compile)
  (cffi:define-foreign-library lib-common
    (:unix
     "/home/rett/dev/common-lisp/clim2/liblib_motif_wrapper.so"))

  (cffi:use-foreign-library lib-common))

#-use-cffi
(unless (ff:get-entry-point "XmCreateMyDrawingArea")
  (load "./liblib_motif_wrapper.so"))
