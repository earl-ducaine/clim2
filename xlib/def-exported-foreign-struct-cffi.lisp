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



(defparameter package-name "x11")
(defparameter package (find-package (string-upcase package-name)))
(defparameter cstruct-name "xsizehints-flags")
(defparameter cstruct-symbol (intern (string-upcase cstruct-name)))
(defparameter slot-name "flags")
(defparameter accessor-symbol (intern (string-upcase cstruct-name)
					      package))


(defun generate-slote-accessor (package-name cstruct-name slot-name)
  (let ((cstruct-symbol (make-symbol (string-upcase cstruct-name)))
	(slot-symbol (make-symbol (string-upcase slot-name)))
	(package (find-package (string-upcase package-name)))
	(accessor-symbol (intern (string-upcase (concatenate 'string cstruct-name "-" slot-name)))))
    `(defun ,accessor-symbol (struct)
       (foreign-slot-value struct cstruct-symbol slot-symbol))
    (export accessor-symbol package)
    (list cstruct-symbol slot-symbol package accessor-symbol)))


(defun compute-cffi-style-cstruct-slot (cstruct-name slot)
  (destructuring-bind (slot-name &key type overlays)
      slot
    (generate-slote-accessor cstruct-name slot)
    (list slot-name (compute-cffi-style-cstruct-type type))))

(defun ensure-list (list)
  "If LIST is a list, it is returned. Otherwise returns the list designated by LIST."
  (if (listp list)
      list
      (list list)))

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
		     (destructuring-bind (cstruct-name . options)
			 (ensure-list name-and-options)
		       (cons (compute-cffi-style-cstruct-slot cstruct-name slot)
			     slots)))
		    (t (error "unexpected slot type"))))
	   slots
	   :initial-value '()))))
    `(cffi:defcstruct ,name-and-options ,@cffi-slots)))





(defmacro def-exported-foreign-synonym-type-cffi (new-name old-name)
  `(progn
     (eval-when (eval load compile)
       (export ',new-name))
     (cffi::defctype ,new-name ,(convert-builtin-ctypes-to-keyword old-name))))
