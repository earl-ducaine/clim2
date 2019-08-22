
;; (push :use-cffi *features*)

;; (eval-when (:compile-toplevel :load-toplevel :execute)
;;   (without-package-locks
;;     ;; (setf *enable-package-locked-errors* nil)
;;     (export :cstruct-property-initialize :ff)
;;     (export :cstruct-prop :ff)))

(eval-when (eval load compile)
  (ff:def-c-typedef :anint :int)
  (assert  (find-symbol "CSTRUCT-PROPERTY-INITIALIZE" :ff)))

(defpackage :ff-wrapper
  (:use cl)
  (:import-from :ff
		allocate-fobject
		cstruct-prop
		cstruct-property-length
		;; def-c-type
		;; def-c-typedef
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
   cstruct-prop
   cstruct-property-length
   def-c-type
   def-c-typedef
   def-foreign-call
   defun-foreign-callable
   foreign-pointer
   foreign-pointer-address
   free-fobject
   fslot-value-typed
   register-foreign-callable))




(in-package :ff-wrapper)



(eval-when (:compile-toplevel :load-toplevel :execute)
  ;; (defun translate-to-cffi-type (ff-type)
  ;;   (ecase
  ;; 	(:unsigned-int
  (defun adjust-c-base-types (types)
    (let (converted-types)
      (reverse
       (dolist (converted-type types converted-types)
	 (case converted-type
	   ('char (push  :char converted-types))
	   ('* (push :pointer converted-types))
	   (t (push  converted-type converted-types)))))))

  (defun convert-base-type (type-elements)
    (cond
      ((eq (car slots) '*)
       (let ((base-types (adjust-c-base-types (cdr slots))))
	 `(cffi:defctype ,name (:pointer ,@base-types))))
      (t
       `(cffi:defctype ,name ,(car slots)))))

  (defun emit-cffi-def-c-typedef-simple (name &rest slots)
    (format t "emit-cffi-def-c-typedef name:~s slots:~s~%" name slots)
    (let ((name (if (consp name)(car name) name)))
      (cond
	((eq (caar slots) '*)
	 (let ((base-types (adjust-c-base-types (cdar slots))))
	   `(cffi:defctype ,name (:pointer ,@base-types))))
	(t
	 `(cffi:defctype ,name ,(car slots))))))

  ;; ((:STRUCT
  ;;   (PTR * :CHAR)
  ;;   (LENGTH :INT)
  ;;   (FORMAT ATOM)))

  (defparameter *parse-example*
    '((:STRUCT
    (PTR * :CHAR)
    (LENGTH :INT)
       (FORMAT ATOM))))

  (defun emit-cffi-defcstruct (name ff-cstruct-body)
    (format t "emit-cffi-defcstruct name:~s ff-cstruct-body:~s~%" name
	    ff-cstruct-body)
    (reverse
     (let ((name (if (consp name) (car name) name))
	   (cffi-def `(,name defcstruct)))
       (dolist (slot ff-cstruct-body cffi-def)
	 (cond
	   ((not (symbolp (car slot)))
	    ;; create a dummy name for an anonymous slot)
	    (push `(,(gensym) ,@(adjust-c-base-types (cdr slot)))
		  cffi-def))
	   ((eq (car slot) '*)
	    ;; create a dummy name for an anonymous slot
	    (push `(,(gensym) ,@(adjust-c-base-types slot))
		  cffi-def))
	   (t
	    (push `(,(car slot) ,@(adjust-c-base-types (cdr slot)))
		  cffi-def)))))))


  (defun emit-cffi (name body)
    (format t "emit-cffi: ~s~%" body)
    (cond
      ((and  (eq (car body) :struct)
	    (let ((body (car body))
		  (defcstruct (emit-cffi-defcstruct name (cdr body))))
	      (format t "parse-def-c-typedef: ~s~%" defcstruct)
	      defcstruct)))
      (t (emit-cffi-def-c-typedef-simple name body))))

  ;; (defun emit-cffi-def-c-type (name &rest slots)
  ;;   ;(format t "emit-cffi-def-c-type name:~s slots:~s~%" name slots)
  ;;   (emit-cffi-def-c-typedef-simple name slots))

  ;; (defun emit-cffi (ff-type name &body slots)
  ;;   (case ff-type
  ;;     (:def-c-typedef
  ;;      (:def-c-type
  ;;   ))
  )


(defmacro def-c-typedef (name &rest slots)
  `(progn
     #+use-cffi ,(emit-cffi name slots)
     #-use-cffi (ff::def-c-typedef ,name ,@slots)))

#-use-cffi
(defmacro def-c-type (name &body body)
  `(ff::def-c-type ,name ,@body))

#+use-cffi
(defmacro def-c-type (name &rest slots)
  `(,@(emit-cffi name slots)))
