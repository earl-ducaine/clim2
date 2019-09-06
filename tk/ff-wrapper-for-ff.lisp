

(eval-when (eval load compile)
  (push :use-cffi *features*)
  (ff:def-c-typedef :anint :int)
  (assert  (find-symbol "CSTRUCT-PROPERTY-INITIALIZE" :ff)))

(defpackage :ff-wrapper
  (:use cl)
  (:import-from :ff
		foreign-address
		allocate-fobject
		convert-foreign-name
		cstruct
		;; cstruct-prop
		;; cstruct-property-length
		;; def-c-type
		;; def-c-typedef
		defforeign-list
		def-foreign-call
		def-foreign-type
		defun-foreign-callable
		foreign-pointer
		foreign-pointer-address
		foreign-pointer-address
		free-fobject
		fslot-value-typed
		get-entry-point
		register-foreign-callable)
  (:export
   foreign-address
   allocate-fobject
   convert-foreign-name
   cstruct
   cstruct-prop
   cstruct-property-length
   def-c-type
   def-c-typedef
   defforeign-list
   def-foreign-call
   def-foreign-type
   defun-foreign-callable
   foreign-pointer
   foreign-pointer-address
   free-fobject
   fslot-value-typed
   get-entry-point
   register-foreign-callable))

(in-package :ff-wrapper)

(defparameter *structs* '())
(eval-when (:compile-toplevel :load-toplevel :execute)
  ;; There are two namespaces for types in c (that we care about) one
  ;; for structs, enums, unions. and then the regular one for all
  ;; other types, CFFI calls them :struct and default respectively.
  (defun c-type-defined-p (type &optional (namespace :default))
    (gethash (cons namespace type) cffi::*type-parsers*))

  (defun structp (type)
    (member type *structs*))

  (defun nest-pointers-add-structs (type)
    (cond
      ((and (> (length type) 1)
	    (eq (car type) :pointer))
       (list :pointer (nest-pointers-add-structs (cdr type))))
      ((structp (car type))
       (list :struct  (car type)))
      (t
       (car type))))

  (defun emit-cffi-type-specfier (types)
    (nest-pointers-add-structs
     (reverse
      (let (converted-types)
	(dolist (converted-type types converted-types)
	  (cond
	    ((eq :double-float converted-type)
	     (push :double converted-types))
	    ((eq :single-float converted-type)
	     (push :float converted-types))
	    ((eq 'char converted-type)
	     (push :char converted-types))
	    ((eq '* converted-type)
	     (push :pointer converted-types))
	    ;; ((and (numberp converted-type) (= converted-type 1))
	    ;;  (push :pointer converted-types))
	    (t
	     (progn
	       (unless (or (c-type-defined-p converted-type :default)
			   (c-type-defined-p converted-type :struct))
		 ;; Define it as a pointer for now and hope that its
		 ;; real definition appears later
		 (format t "defining stub: ~s~%"
			 `(cffi:defctype ,converted-type :pointer))
		 (eval `(cffi:defctype ,converted-type :pointer))))
	     (push  converted-type converted-types))))))))

  (defun emit-cffi-def-c-typedef-simple (name body)
    (format t "emit-cffi-def-c-typedef-simple name:~s body:~s~%" name body)
    (let ((name (if (consp name)(car name) name)))
      (cond
	;; defines an array
	((integerp (car body))
	 `(defparameter ,name (cffi:foreign-alloc '(,@(emit-cffi-type-specfier (cdr body)))
						  :count ,(car body))))
	(t
	 `(cffi:defctype ,name ,(emit-cffi-type-specfier body))))))


  ;; ((:STRUCT
  ;;   (PTR * :CHAR)
  ;;   (LENGTH :INT)
  ;;   (FORMAT ATOM)))

  (defparameter *parse-example*
    '((:STRUCT
       (PTR * :CHAR)
       (LENGTH :INT)
       (FORMAT ATOM))))

  ;; each slot name has a potential global scope as an accessor
  (defparameter *ffi-c-slot-defs* '())

  (defun generate-slot-accessor-defun (struct-name slot-name)
    (let* ((accessor-name-string
	   (concatenate 'string (symbol-name struct-name)
			"-"
			(symbol-name slot-name)))
	  (accessor-name-symbol
	   (intern accessor-name-string (symbol-package struct-name))))
      `(progn
	 (defun ,accessor-name-symbol (struct-pointer)
	   (cffi:foreign-slot-value struct-pointer (quote ,struct-name) (quote ,slot-name)))
	 (defun (setf ,accessor-name-symbol) (struct-pointer value)
	   (setf (cffi:foreign-slot-value struct-pointer
					  (quote ,struct-name)
					  (quote ,slot-name))
		 value)))))

  (defun generate-cffi-defcstruct (struct-name slots)
    (format t "generate-cffi-defcstruct name:~s ff-cstruct-body:~s~%" struct-name
	    slots)
    (let* ((struct-name (if (consp struct-name) (car struct-name) struct-name))
	   (slot-accessors '())
	   (cffi-defcstruct (list struct-name 'cffi:defcstruct)))
      (dolist (slot slots)
	(push slot *ffi-c-slot-defs*)
	(let ((slot-name (car slot)))
	  (push (generate-slot-accessor-defun struct-name (car slot))
		slot-accessors)
	  (case (get-ffi-slot-def-category slot)
	    ;; '(class-initialize xt-proc)
	    (:define-slot-base-type
	     (push (list slot-name
			 (emit-cffi-type-specfier (list (cadr slot))))
		   cffi-defcstruct))
	    (:define-slot-base-pointer-type
	     (push (list (car slot)
			 `(:pointer ,(emit-cffi-type-specfier (list (caddr slot)))))
		   cffi-defcstruct)))))
      (let ((result (cons (reverse cffi-defcstruct)
			  slot-accessors)))
	(format t "defstructure: ~s~%" result)
	result)))

  (defun generate-accessor-defun (name type)
    `(defun ,name (entry-point index)
       (cffi:mem-aref entry-point ,type index)))

  (defun get-ffi-slot-def-category (slot)
    (cond
      ;; e.g.
      ;; '((X11:XCOLOR-ARRAY :NO-DEFUNS) 1 X11:XCOLOR)
      ;; '((TK::CLASS-ARRAY :NO-DEFUNS :NO-CONSTRUCTOR) 1 :UNSIGNED-LONG)
      ((and (= (length slot) 2)
	    (and (symbolp (car slot))
		 (symbolp (cadr slot))))
       :define-slot-base-type)
      ((and (= (length slot) 3)
	    (and (symbolp (car slot))
		 (eq (cadr slot) '*)
		 (symbolp (caddr slot))))
       :define-slot-base-pointer-type)
      (t
       :unidentified)))

  ;; :define-slot-base-pointer-type 18
  ;; :define-slot-base-type         68

  (defun print-ffi-slot-defs (&optional (type :unidentified))
    (reduce (lambda (definitions definition)
	      (let ((def-category
		     (get-ffi-slot-def-category definition)))
		(cond
		  ((eq type def-category)
		   (cons definition definitions))
		  (t
		   definitions))))
	    *ffi-c-slot-defs* :initial-value '()))

  (defun get-ffi-type-def-category (body)
    (cond
      ;; e.g.
      ;; '((X11:XCOLOR-ARRAY :NO-DEFUNS) 1 X11:XCOLOR)
      ;; '((TK::CLASS-ARRAY :NO-DEFUNS :NO-CONSTRUCTOR) 1 :UNSIGNED-LONG)
      ((and (= (length body) 3)
	    (integerp (nth 1 body)))
       :define-base-type-array)
      ((and (= (length body) 4)
	    (integerp (nth 1 body))
	    (eq (nth 2 body) '*))
       :define-pointer-type-array)
      ((and (> (length body) 2)
	    (or (symbolp (car body))
		(consp (car body)))
	    (eq (cadr body) :union))
       :union)
      ((and (> (length body) 2)
	    (or (symbolp (car body))
		(consp (car body)))
	    (eq (cadr body) :struct))
       :explicit-struct)
      ((and (= (length body) 2)
	    (or (symbolp (car body))
		(consp (car body)))
	    (symbolp (cadr body)))
       :define-c-base-type)
      ((and (or (symbolp (car body))
		(consp (car body)))
	    (eq (cadr body) '*)
	    (symbolp (caddr body)))
       :define-c-pointer-type)
      ((and (>= (length body) 2)
	    (or (symbolp (car body))
		(consp (car body)))
	    (consp (cadr body)))
       :implied-structure)
      (t
       :unidentified)))

  ;; :define-pointer-type-array 16
  ;; :define-pointer-type-array  3
  ;; :define-c-base-type        80
  ;; :define-c-pointer-type     12
  ;; :implied-structure         68
  ;; :explicit-struct           12
  ;; :union                      2
  ;; :unidentified               4

  (defun emit-cffi (body)
    (format t "emit-cffi: ~s~%" body)
    (case (get-ffi-type-def-category body)
      (:define-base-type-array
       (destructuring-bind (name size type) body
	 (let ((name (if (consp name) (car name) name)))
	   (list (generate-accessor-defun name type)))))
      ;; ((tk::xt-class :no-defuns :no-constructor) :struct
      ;;  (tk::superclass :long) (tk::name * :char)
      ;;  (tk::get-values-hook tk::xt-proc)
      ;;  (tk::accept-focus tk::xt-proc)
      ;;  (tk::version tk::xt-version-type)
      ;;  (tk::callback-private * :char))
      (:explicit-struct
       (let* ((name (car body))
	      (name (if (consp name) (car name) name))
	      (slots (cddr body)))
	 (generate-cffi-defcstruct name slots)))
      ;; ((x11:xfocuschangeevent :no-defuns)
      ;;  (type x11:int)
      ;;  (x11::serial x11:unsigned-long)
      ;;  (x11::send-event x11:int)
      ;;  (x11:display * x11:display)
      ;;  (x11:window x11:window)
      ;;  (x11::mode x11:int)
      ;;  (x11::detail x11:int)))
      (:implied-structure
       (let* ((name (car body))
	      (name (if (consp name) (car name) name))
	      (slots (cdr body)))
	 (generate-cffi-defcstruct name slots))))))

(defparameter *ffi-c-definitions* '())

(defun print-ffi-definitions (&optional (type :unidentified))
  (reduce (lambda (definitions definition)
	    (let ((definition-type
		   (get-ffi-type-def-category (cadr (assoc :body definition)))))
	      (cond
		((eq type definition-type)
		 (cons definition definitions))
		(t
		 definitions))))
	  *ffi-c-definitions* :initial-value '()))

(defun clear-ffi-definition-queue ()
  (setf *ffi-c-definitions* '()))

(clear-ffi-definition-queue)

#+use-cffi
(defmacro def-c-typedef (&body body)
  (push (list '(:ffi-entry 'def-c-typedef)
	      (list :body body))
	*ffi-c-definitions*)
  `(eval-when (eval load compile)
     ,@(emit-cffi body)))

#-use-cffi
(defmacro def-c-typedef (name &body body)
  `(progn
     (ff::def-c-typedef ,name ,@body)))

#-use-cffi
(defmacro def-c-type (name &body body)
  `(ff::def-c-type ,name ,@body))

#+use-cffi
(defmacro def-c-type (&body body)
  (push (list '(:ffi-entry 'def-c-type)
	      (list :body body))
	*ffi-c-definitions*)
  `(eval-when (eval load compile)
     ,@(emit-cffi body)))


#+use-cffi
(defmacro cstruct-prop (&body body)
  )

#-use-cffi
(defmacro cstruct-prop (&body body)
  `(ff::cstruct-prop ,@body))

#+use-cffi
(defmacro cstruct-property-length (&body body)
  )

#-use-cffi
(defmacro cstruct-property-length (&body body)
  `(ff::cstruct-prop ,@body))
