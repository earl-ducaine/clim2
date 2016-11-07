(in-package :x11)

;; In the xlib-defs.lisp file the following provides definitions clim2
;; needs to access the c interface to motif. def-exported-constant is
;; already portable, being just a wrapper around export and
;; defconstant.  def-exported-foreign-struct, and
;; def-exported-foreign-synonym-type need to be reimplemented in cffi
;; to be made portable.


(defparameter *builtin-ctypes*
  '(char unsigned-char short unsigned-short int unsigned-int long unsigned-long
    long-long unsigned-long-long uchar ushort uint ulong llong llong ullong
    int8 uint8 int16 uint16 int32 uint32 int64 uint64 float double long-double
    pointer void))

(defun convert-builtin-ctypes-to-keyword (symbol)
  (if (member symbol *builtin-ctypes*)
      (alexandria:make-keyword (string-upcase (symbol-name symbol)))
      symbol))

;; Old way of creating interface to xcomposestatus.
;; (def-exported-foreign-struct-cffi xcomposestatus-ffi
;;     "Xcomposestatus structure."
;;   (compose-ptr :type (:pointer char))
;;   (chars-matched :type int))

;; New way of creating interface to xcomposestatus.
;; (cffi:defcstruct xcomposestatus
;;     "Xcomposestatus structure."
;;     (compose-ptr (:pointer :char))
;;     (chars-matched :int))

;; So, def-exported-foreign-struct-cffi has to render the old to the new.

(defun compute-cffi-style-cstruct-type (type)
  (cond ((listp type) (if (eq (car type) :pointer)
			  :pointer
			  (mapcar (lambda (symbol)
				    (convert-builtin-ctypes-to-keyword symbol)
				    type))))
	(t (convert-builtin-ctypes-to-keyword type)
	   )))

(defun compute-cffi-style-cstruct-slot (slot)
  (destructuring-bind (slot-name &key type overlays)
      slot
    (list slot-name (compute-cffi-style-cstruct-type type))))

(defmacro def-exported-foreign-struct-cffi (name-and-options &rest slots)
  (let ((cffi-slots
	 (reverse
	  (reduce
	   (lambda (slots slot)
	     (cond  ((stringp slot)
		     ;; documentation string
		     (cons slot slots))
		    ((or (listp slot)
			 (symbolp slot)
			 (keywordp slot))
		     (cons (compute-cffi-style-cstruct-slot slot) slots))
		    (t (error "unexpected slot type"))))
	   slots
	   :initial-value '()))))
    `(cffi:defcstruct ,name-and-options ,@cffi-slots)))





(defmacro def-exported-foreign-synonym-type-cffi (new-name old-name)
  `(progn
     (eval-when (eval load compile)
       (export ',new-name))
     (cffi::defctype ,new-name ,(convert-builtin-ctypes-to-keyword old-name))))
