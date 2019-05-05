


(defpackage :ff-wrapper
  (:use cl)
  (:import-from :ff
		foreign-pointer
		foreign-pointer-address
		def-c-type
		def-c-typedef
		def-foreign-call
		defun-foreign-callable
		foreign-pointer-address
		cstruct-prop
		cstruct-property-length
		register-foreign-callable))
