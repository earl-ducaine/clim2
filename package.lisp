;; See the file LICENSE for the full license governing this code.

#+allegro
(eval-when (eval load compile)
  (ff:def-c-typedef :anint :int)
  (assert  (find-symbol "CSTRUCT-PROPERTY-INITIALIZE" :ff)))

(eval-when (eval load compile)
  (push :use-cffi *features*))

#-allegro (rename-package
	   :closer-mop :closer-mop
	   (cons :clos (package-nicknames :closer-mop)))

(defpackage :ff-wrapper
  (:use cl)
  #-use-cffi
  (:import-from :ff
		foreign-pointer
		foreign-pointer-address
		free-fobject)
  (:export
   foreign-address
   allocate-fobject
   convert-foreign-name
   ;;cstruct
   cstruct-prop
   cstruct-property-length
   def-c-type
   def-c-typedef
   defforeign-list
   def-exported-foreign-function
   def-foreign-call
   def-foreign-type
   defun-foreign-callable
   foreign-pointer
   foreign-pointer-address
   free-fobject
   fslot-value-typed
   get-entry-point
   register-foreign-callable))

(defpackage :x11
  #-allegro (:use clim-lisp)
  ;; I don't know if this is OK (can we assume clim-utils?).  In any
  ;; case we want that definition of fintern.
  (:import-from :clim-utils :fintern)
  (:import-from :ff-wrapper :def-exported-foreign-function)

  ;; These next two import symbols when loading from clim.fasl.
  (:export #:int #:short)
  (:export #:int def-c-type def-c-typedef)
  (:export #:screen #:depth #:visual #:colormap
	   #:pixmap #:window #:display))

(defpackage :tk
  (:use :clim-lisp)
  (:nicknames :xt)
  (:import-from :clim-utils #:fintern #:package-fintern)
  (:import-from :x11 def-c-type def-c-typedef)
  (:export
   #:initialize-motif-toolkit
   #:widget-parent
   #:manage-child
   #:get-values
   #:top-level-shell
   #:popup
   #:popdown
   #:manage-child
   #:realize-widget
   #:card32
   #:card29
   #:card24
   #:card16
   #:card8
   #:int32
   #:int16
   #:int8
   #:with-server-grabbed
   #:window-property-list))

#+allegro
(setf (package-definition-lock (find-package :tk)) t)
