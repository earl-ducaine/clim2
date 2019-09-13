

(eval-when (eval load compile)
  ;; (push :use-cffi *features*)
  )

#+allegro
(eval-when (eval load compile)
  (ff:def-c-typedef :anint :int)
  (assert  (find-symbol "CSTRUCT-PROPERTY-INITIALIZE" :ff)))


(defpackage :ff-wrapper
  (:use cl)
  (:import-from :ff
		;; foreign-address
		;; allocate-fobject
		;; convert-foreign-name
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

;; (defparameter *structs* '())
(eval-when (:compile-toplevel :load-toplevel :execute)
  ;; There are two namespaces for types in c (that we care about) one
  ;; for structs, enums, unions. and then the regular one for all
  ;; other types, CFFI calls them :struct and default respectively.
  (defun c-type-defined-p (type &optional (namespace :default))
    (gethash (cons namespace type) cffi::*type-parsers*))

  (defun c-struct-p (type)
    (member type *structs*))

  (defparameter *ff-base-type* '(:signed-int :short :unsigned-int
				 :void :unsigned-long :int :cardinal
				 :char :long :pointer))

  (defparameter *ff-types* '())


  (defun print-ffi-used-types (&optional (type :unidentified))
    (reduce (lambda (definitions definition)
	      (let ((definition-type
		     (get-type-category (cadr (assoc :body definition)))))
		(cond
		  ((eq type definition-type)
		   (cons definition definitions))
		  (t
		   definitions))))
	    *ff-types* :initial-value '()))

  (defun get-struct-types ()
    (reduce (lambda (names definition)
	      (let* ((body (cadr (assoc :body definition)))
		     (name (if (consp (car body)) (caar body) (car body)))
		     (definition-type
		      (get-ffi-type-def-category body)))
		(cond
		  ((member definition-type '(:explicit-struct :implied-structure))
		   (cons name names))
		  (t
		   names))))
	    *ffi-c-definitions* :initial-value '()))


  (defun get-type-category (type)
    (pushnew type *ff-types*)
    (cond
      ((keywordp type)
       :base-type)
      (t
       :unidentified)))

  (defun emit-cffi-type-specfier (type)
    ;; (push types *ff-types*)
    (format t "type (~s) category: ~s~%" type (get-type-category type))
    (cond
      ((eq :double-float type)
       :double)
      ((eq :single-float type)
       :float)
      ((eq 'char type)
       :char)
      ((eq '* type)
       :pointer)
      ((c-struct-p type)
       (unless (c-type-defined-p type :struct)
	 ;; Define it as a pointer for now and hope that its
	 ;; real definition appears later
	 (let ((def `(cffi:defcstruct ,type)))
	   (format t "defining stub: ~s~%" def)
	   (eval def)))
       (list :struct type))
      (t
       (progn
	 (unless (or (c-type-defined-p type :default)
		     (c-type-defined-p type :struct))
	   ;; Define it as a pointer for now and hope that its
	   ;; real definition appears later
	   (format t "defining stub: ~s~%"
		   `(cffi:defctype ,type :pointer))
	   (eval `(cffi:defctype ,type :pointer))))
       type)))

  (defun emit-cffi-def-c-typedef-simple (name body)
    (format t "emit-cffi-def-c-typedef-simple name:~s body:~s~%" name body)
    (let ((name (if (consp name)(car name) name)))
      (cond
	;; defines an array
	((integerp (car body))
	 `(defparameter ,name (cffi:foreign-alloc
			       '(,(emit-cffi-type-specfier (cadr body)))
			       :count ,(car body))))
	(t
	 `(cffi:defctype ,name ,(emit-cffi-type-specfier (car body)))))))

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
	   (cffi:foreign-slot-value struct-pointer
				    (quote ,struct-name)
				    (quote ,slot-name)))
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
			 (emit-cffi-type-specfier (cadr slot)))
		   cffi-defcstruct))
	    (:define-slot-base-pointer-type
	     (push (list (car slot)
			 `(:pointer ,(emit-cffi-type-specfier (caddr slot))))
		   cffi-defcstruct)))))
      (let ((result (cons (reverse cffi-defcstruct)
			  slot-accessors)))
	(format t "defstructure: ~s~%" result)
	result)))

  (defun generate-accessor-defun (name type)
    (let ((make-defun-name
	   (intern (format nil "~a-~a" 'make name) (symbol-package name))))
      (format
       t
       "generate-accessor-defun -- name: ~a type: ~a make-defun-name: ~a~%"
       name type make-defun-name)
      `(progn
	 (defun ,make-defun-name
	     (&key number in-foreign-space initialize)
	   (declare (ignore in-foreign-space initialize))
	   (cffi:foreign-alloc ,(emit-cffi-type-specfier type) :count number))
	 (defun ,name (entry-point index)
	   (cffi:mem-aref entry-point ,(emit-cffi-type-specfier type) index))
	 (defun (setf ,name) (entry-point index value)
	   (setf (cffi:mem-aref entry-point ,(emit-cffi-type-specfier type) index)
		 value)))))

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
      ;;  (x11::mode x11:int)
      ;;  (x11::detail x11:int)))
      (:implied-structure
       (let* ((name (car body))
	      (name (if (consp name) (car name) name))
	      (slots (cdr body)))
	 (generate-cffi-defcstruct name slots))))))

(defparameter *ffi-c-definitions* '())

;; List of all structs implied and explicit
(defparameter *structs*
  '(x11::xextdata x11::xextcodes x11::_xextension x11::xgcvalues x11::_xgc
		x11::visual x11::depth x11::screen x11::screenformat
		x11::xsetwindowattributes x11::xwindowattributes x11::xhostaddress
		x11::funcs x11::ximage x11::xwindowchanges x11::xcolor x11::xsegment
		x11::xpoint x11::xrectangle x11::xarc x11::xkeyboardcontrol
		x11::xkeyboardstate x11::xtimecoord x11::xmodifierkeymap x11::display
		x11::xkeyevent x11::xbuttonevent x11::xmotionevent x11::xcrossingevent
		x11::xfocuschangeevent x11::xkeymapevent x11::xexposeevent
		x11::xgraphicsexposeevent x11::xnoexposeevent x11::xvisibilityevent
		x11::xcreatewindowevent x11::xdestroywindowevent x11::xunmapevent
		x11::xmapevent x11::xmaprequestevent x11::xreparentevent
		x11::xconfigureevent x11::xgravityevent x11::xresizerequestevent
		x11::xconfigurerequestevent x11::xcirculateevent
		x11::xcirculaterequestevent x11::xpropertyevent x11::xselectionclearevent
		x11::xselectionrequestevent x11::xselectionevent x11::xcolormapevent
		x11::xclientmessageevent x11::xmappingevent x11::xerrorevent
		x11::xanyevent x11::_xqevent x11::xcharstruct x11::xfontprop
		x11::xfontstruct x11::xtextitem x11::xchar2b x11::xtextitem16 x11::xrmvalue
		x11::xrmoptiondescrec x11::xwmhints x11::xsizehints x11::xcomposestatus
		tk::xt-class tk::xt-resource tk::xt-offset-rec tk::xt-widget
		tk::x-push-button-callback-struct tk::x-drawing-area-callback
		tk::xt-arg tk::xt-widget-geometry tk::xm-text-block-rec
		tk::xm-text-field-callback-struct
		tk::xm-file-selection-box-callback-struct tk::xm-list-callback-struct
		wnn::wnn-buf))

(defun get-structs ()
  (reduce (lambda (definitions definition)
	    (let ((definition-type
		   (get-ffi-type-def-category (cadr (assoc :body definition)))))
	      (cond
		((member definition-type '(:explicit-struct :implied-structure))
		 (let* ((name (caadr (assoc :body definition)))
			(name (if (consp name) (car name) name)))
		   (pushnew name definitions)))
		(t
		 definitions))))
	  *ffi-c-definitions* :initial-value '()))

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
  `(ff::cstruct-property-length ,@body))


;; (defparameter *foreign-names* '())



;; (do-list (name ff-wrapper::*foreign-names*)
;;   (when (not (string= (getf name :to-name)
;; 		      (getf name :from-name)))
;;     (format t "convert-foreign-name did work on: ~s~%"
;; 	    (getf name :from-name))))

;; Should never need to convert for CFFI supported platforms or allegro on
;; linux.
(defun convert-foreign-name (name &key (language :c))
  name)



;; (let ((to-name
  ;; 	 (funcall #'ff:convert-foreign-name name :language language)))
  ;;   (push (list :from-name name
  ;; 		:to-name to-name
  ;; 		:language language)
  ;; 	  *foreign-names*)
  ;;   to-name))
;; ;; make-*-ARRAY
;;
;; (defpackage :wnn
;;   (:export wnn-buf))
;;
;; (defpackage :tk
;;   (:export
;;    x-drawing-area-callback
;;    x-push-button-callback-struct
;;    xm-file-selection-box-callback-struct
;;    xm-list-callback-struct
;;    xm-text-block-rec
;;    xm-text-field-callback-struct
;;    xt-arg
;;    xt-class
;;    xt-offset-rec
;;    xt-resource
;;    xt-widget
;;    xt-widget-geometry))
;; (defpackage :x11
;;   (:export
;;    _xextension
;;    _xgc
;;    _xqevent
;;    depth
;;    display
;;    funcs
;;    screen
;;    screenformat
;;    visual
;;    xanyevent
;;    xarc
;;    xbuttonevent
;;    xchar2b
;;    xcharstruct
;;    xcirculateevent
;;    xcirculaterequestevent
;;    xclientmessageevent
;;    xcolor
;;    xcolormapevent
;;    xcomposestatus
;;    xconfigureevent
;;    xconfigurerequestevent
;;    xcreatewindowevent
;;    xcrossingevent
;;    xdestroywindowevent
;;    xerrorevent
;;    xexposeevent
;;    xextcodes
;;    xextdata
;;    xfocuschangeevent
;;    xfontprop
;;    xfontstruct
;;    xgcvalues
;;    xgraphicsexposeevent
;;    xgravityevent
;;    xhostaddress
;;    ximage
;;    xkeyboardcontrol
;;    xkeyboardstate
;;    xkeyevent
;;    xkeymapevent
;;    xmapevent
;;    xmappingevent
;;    xmaprequestevent
;;    xmodifierkeymap
;;    xmotionevent
;;    xnoexposeevent
;;    xpoint
;;    xpropertyevent
;;    xrectangle
;;    xreparentevent
;;    xresizerequestevent
;;    xrmoptiondescrec
;;    xrmvalue
;;    xsegment
;;    xselectionclearevent
;;    xselectionevent
;;    xselectionrequestevent
;;    xsetwindowattributes
;;    xsizehints
;;    xtextitem
;;    xtextitem16
;;    xtimecoord
;;    xunmapevent
;;    xvisibilityevent
;;    xwindowattributes
;;    xwindowchanges
;;    xwmhints
;;    ))
