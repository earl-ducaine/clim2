;; See the file LICENSE for the full license governing this code.
;;

(in-package :x11)

(defvar *trace-stream* (make-string-output-stream))

;; Note -- All exports are now done in pkg.lisp, for space/performance
;;         reasons.  jdi  (temporarily not true).

(defmacro def-exported-constant (name value)
  ;; define the constant and export it from :x11
  `(progn
     (eval-when (eval load compile)
       (export ',name))
     (defconstant ,name ,value)))

(eval-when (compile load eval)
  (defun transmogrify-ff-type (type)
    (if (consp type)
	(case (car type)
	  (:pointer
	   `(* ,@(transmogrify-ff-type (second type))))
	  (:array
	   `(,@(third type) ,(second type)))
	  (t (list type)))
      (list type))))

(defmacro def-exported-foreign-synonym-type (new-name old-name)
  `(progn
     (eval-when (eval load compile)
       (export ',new-name))
     (ff-wrapper::def-c-typedef ,new-name ,@(transmogrify-ff-type old-name))))

(defmacro def-exported-foreign-struct (name-and-options &rest slots)
  (let (name array-name (options nil))
    (if (atom name-and-options)
	(setq name name-and-options)
      (setq name (car name-and-options)
	    options (cdr name-and-options)))
    (when (member :array options)
      (setq array-name (fintern "~A-~A" name 'array)
	    options (delete :array options)))
    `(progn
       ,(flet ((make-exports (name)
		 (format t "def-exported-foreign-struct: ~A-~A%" 'make name)
		 (list* name
			(fintern "~A-~A" 'make name)
			(mapcar #'(lambda (x)
				    (fintern "~A-~A" name (car x)))
				slots))))
	  `(eval-when (eval load compile)
	     (export '(,@(make-exports name)
		       ,@(make-exports array-name)))))
       ,(flet ((foo-slot (slot)
		 (destructuring-bind
		     (name &key type) slot
		   `(,name ,@(trans-slot-type type)))))
	  (if (notany #'(lambda (s) (member :overlays (cdr s))) slots)
	      `(ff-wrapper:def-c-type (,name :no-defuns ,@options)
		 ,@(mapcar #'foo-slot slots))
	    (destructuring-bind
		((first-slot-name . first-options) . other-slots) slots
	      (declare (ignore first-slot-name))
	      (if (and (null (member :overlays first-options))
		       (every #'(lambda (slot)
				  slot ;- Bug
				  #+ignore
				  (eq (getf (cdr slot) :overlays)
				      first-slot-name))
			      other-slots))
		  `(ff-wrapper::def-c-type (,name :no-defuns ,@options) :union
				   ,@(mapcar #'(lambda (slot)
						 (setq slot (copy-list slot))
						 (remf (cdr slot) :overlays)
						 (foo-slot slot))
					     slots))
		(error ":overlays used in a way we cannot handle")))))
       ,(when array-name
	  `(ff-wrapper::def-c-type (,array-name :no-defuns ,@options)
	     1 ,name)))))

(defun trans-slot-type (type)
  (if (atom type)
      (transmogrify-ff-type type)
    (ecase (car type)
      (:pointer `(* ,(second type)))
      (:array
       (destructuring-bind
	  (ignore type indicies) type
	(declare (ignore ignore))
	`(,@indicies ,type))))))

(defun trans-arg-type (type)
  (cons (car type)
	(cond ((consp (cadr type))
	       (ecase (caadr type)
		 (:pointer '(:foreign-address))
		 (:array '(:foreign-address))))
	      (t
	       (case (cadr type)
		 (void (error "void not allowed here"))
		 ((int :signed-32bit) '(:int))
		 ((unsigned-int :unsigned-32bit) '(:unsigned-int))
		 ((fixnum-int fixnum-unsigned-int) '(:int fixnum))
		 (fixnum-drawable '(:foreign-address))
		 (t
		  (if (get (cadr type) 'ff-wrapper:cstruct)
		      '(:foreign-address)
		      '(:lisp))))))))

(defun trans-return-type (type)
  (cond
    ((consp type)
     (ecase (car type)
       (:pointer :foreign-address)
       (:array :foreign-address)))
    (t
     (case type
       (void :void)
       ((integer int) :int)
       ((fixnum-int :fixnum) '(:int fixnum))
       (:unsigned-32bit :unsigned-int)
       (:signed-32bit :int)
       (t :unsigned-int)))))

(defmacro def-exported-foreign-function ((name &rest options) &rest args)
  (format t "def-exported-foreign-function: ~s ~%" name)
  `(progn
     (eval-when (eval load compile)
       (export ',name))
     (eval-when (compile eval load)
       ,(let ((c-name (second (assoc :name options)))
	      (return-type (or (second (assoc :return-type options))
			       'void)))
	  `(ff-wrapper:def-foreign-call (,name ,c-name)
	       ,(or (mapcar #'trans-arg-type args) '(:void))
	     :returning ,(trans-return-type return-type)
	     :call-direct t
	     :arg-checking nil)))))

(defmacro def-exported-foreign-macro ((name &rest options) &rest args)
  `(def-exported-foreign-function (,name  ,@options) ,@args))

(ff-wrapper:def-c-typedef :fixnum :int)
(ff-wrapper:def-c-typedef :signed-32bit :int)
;; Already defined in CFFI
#-use-cffi (ff-wrapper:def-c-typedef :pointer * :char)
(ff-wrapper:def-c-typedef :signed-8bit :char)

;; Create non-keyword versions.
(def-exported-foreign-synonym-type char :char)
(def-exported-foreign-synonym-type unsigned-char :unsigned-char)
(def-exported-foreign-synonym-type short  :short)
(def-exported-foreign-synonym-type unsigned-short :unsigned-short)
(def-exported-foreign-synonym-type int :int)
(def-exported-foreign-synonym-type unsigned-int :unsigned-int)
(def-exported-foreign-synonym-type long :long)
(def-exported-foreign-synonym-type unsigned-long :unsigned-long)
(def-exported-foreign-synonym-type float :single-float)
(def-exported-foreign-synonym-type double  :double-float)
(def-exported-foreign-synonym-type void :int)
(def-exported-foreign-synonym-type short-int short)
(def-exported-foreign-synonym-type long-int long)
(def-exported-foreign-synonym-type unsigned unsigned-int)
(def-exported-foreign-synonym-type long-float double)

(def-exported-foreign-synonym-type caddr-t :pointer)

(def-exported-foreign-synonym-type u-char unsigned-char)
(def-exported-foreign-synonym-type u-short unsigned-short)
(def-exported-foreign-synonym-type u-int unsigned-int)
(def-exported-foreign-synonym-type u-long unsigned-long)
(def-exported-foreign-synonym-type fd-mask long)
