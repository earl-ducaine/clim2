


(defpackage :ff-wrapper
  (:use cl)
  (:import-from :ff
		allocate-fobject
		cstruct-prop
		cstruct-property-length
		def-c-type
		def-c-typedef
		def-foreign-call
		defun-foreign-callable
		foreign-pointer
		foreign-pointer-address
		foreign-pointer-address
		free-fobject
		fslot-value-typed
		register-foreign-callable)
  (:export
   allocate-fobject
   defun-foreign-callable
   foreign-pointer
   foreign-pointer-address
   free-fobject
   fslot-value-typed
   register-foreign-callable))
