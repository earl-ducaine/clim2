
#+use-cffi
(eval-when (eval load compile)
  (cffi:define-foreign-library lib-common
    (:unix
     "/mnt/seagate/working/allegro-clim2-ubuntu-16-04-x32/dev/clim2/liblib_motif_wrapper.so"))

  (cffi:use-foreign-library lib-common))

#-use-cffi
(unless (ff:get-entry-point "XmCreateMyDrawingArea")
  (load "./liblib_motif_wrapper.so"))
