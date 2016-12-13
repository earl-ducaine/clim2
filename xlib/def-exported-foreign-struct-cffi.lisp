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

(defun compute-cffi-style-cstruct-slot-old (package-name cstruct-name slot)
  (destructuring-bind (slot-name &key type overlays)
      slot
    (list slot-name (compute-cffi-style-cstruct-type type))))

;; create a string of the proper case to generate the accessor symbol
(defun generate-slot-accessor-name (cstruct-name slot-name)
  (let* ((cstruct-name (string-upcase cstruct-name))
	 (slot-name (string-upcase slot-name))
	 (slot-accessor-name (concatenate 'string cstruct-name "-" slot-name)))
    slot-accessor-name))

;; Create and configure slot accessor symbol that we'll attach to the
;; correct function defination.
(defun create-slot-accessor-symbol (package-name cstruct-name slot-name)
  (let* ((accessor-name (generate-slot-accessor-name cstruct-name slot-name))
	 (package (find-package (string-upcase package-name)))
	 (accessor-symbol (intern accessor-name package)))
    (export accessor-symbol package)
    accessor-symbol))

(defun make-upcase-symbol (symbol-name)
  (make-symbol (string-upcase symbol-name)))

;; Create a slot accessor function exported in the specified package.
(defun generate-slot-accessor (package-name cstruct-name slot-name)
  (let* ((symbol (create-slot-accessor-symbol package-name cstruct-name slot-name)))
    (format t "symbol ~s, (type-of symbol) ~s~%" symbol (type-of symbol))
    (setf (symbol-function symbol) (function (lambda (struct)
				     (cffi:foreign-slot-value struct
							      (find-symbol (string-upcase cstruct-name) :x11)
							      (find-symbol (string-upcase slot-name) :x11)))))))











;;  (define-setf-expander ldb (bytespec int &environment env)
;;    (multiple-value-bind (temps vals stores
;;                           store-form access-form)
;;        (get-setf-expansion int env);Get setf expansion for int.
;;      (let ((btemp (gensym))     ;Temp var for byte specifier.
;;            (store (gensym))     ;Temp var for byte to store.
;;            (stemp (first stores))) ;Temp var for int to store.
;;        (if (cdr stores) (error "Can't expand this."))
;; ;;; Return the setf expansion for LDB as five values.
;;        (values (cons btemp temps)       ;Temporary variables.
;;                (cons bytespec vals)     ;Value forms.
;;                (list store)             ;Store variables.
;;                `(let ((,stemp (dpb ,store ,btemp ,access-form)))
;;                   ,store-form
;;                   ,store)               ;Storing form.
;;                `(ldb ,btemp ,access-form) ;Accessing form.
;;               ))))

(define-setf-expander lastguy (x &environment env)
   "Set the last element in a list to the given value."
   (multiple-value-bind (dummies vals newval setter getter)
       (get-setf-expansion x env)
     (let ((store (gensym)))
       (values dummies
               vals
               `(,store)
               `(progn (rplaca (last ,getter) ,store) ,store)
               `(lastguy ,getter)))))



(defun compute-cffi-style-cstruct-slot (package-name cstruct-name slot)
  (destructuring-bind (slot-id &key type overlays)
      slot
    (generate-slot-accessor package-name cstruct-name
			    (if (stringp slot-id)
				slot-id
				;; asume it's a symbol
				(symbol-name slot-id)))
    (list slot-id (compute-cffi-style-cstruct-type type))))


(defun ensure-list (list)
  "If LIST is a list, it is returned. Otherwise returns the list designated by LIST."
  (if (listp list)
      list
      (list list)))

(defun reformat-and-push-slot (name-and-options slots slot)
    (cond  ((stringp slot)
	    ;; documentation string
	    (cons slot slots))
	   ((or (listp slot)
		(symbolp slot)
		(keywordp slot))
	    (destructuring-bind (cstruct . options)
		(ensure-list name-and-options)
	      (cons (compute-cffi-style-cstruct-slot "x11"
						     (if (stringp cstruct)
							 cstruct
							 ;; asume it's a symbol
							 (symbol-name cstruct))
						     slot)
		    slots)))
	    (t (error "unexpected slot type"))))

(defun compute-cffi-style-cstruct-slots (name-and-options slots)
  (reverse (reduce (lambda (slots slot)
		     (reformat-and-push-slot name-and-options slots slot))
		   slots :initial-value '())))

(defmacro def-exported-foreign-struct-cffi (name-and-options &rest slots)
  (let ((cffi-slots (compute-cffi-style-cstruct-slots name-and-options slots)))
    (format t "cffi-slots ~s~%" cffi-slots)
    `(cffi:defcstruct ,name-and-options ,@cffi-slots)))

(defmacro def-exported-foreign-synonym-type-cffi (new-name old-name)
  `(progn
     (eval-when (eval load compile)
       (export ',new-name))
     (cffi::defctype ,new-name ,(convert-builtin-ctypes-to-keyword old-name))))
