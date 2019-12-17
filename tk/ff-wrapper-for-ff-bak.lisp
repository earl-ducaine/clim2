


(in-package :ff-wrapper)


(cffi:define-foreign-type clim-object-type ()
  ()
  (:actual-type :pointer)
  (:simple-parser clim-object))

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

  ;; (declaim (sb-ext:muffle-conditions sb-ext:defconstant-uneql))

  ;; Note, all CLIM pointer types must be translated, for that reason
  ;; we recast :pointer --> tk:application-context, even though
  ;; pointer IS a valid CFFI type.
  (defun emit-cffi-type-specfier (type)
    (cond
      ((eq :pointer type)
       ;; :pointer
       'clim-object
       )
      ((eq :foreign-address type)
       ;; :pointer
       'clim-object
       )
      ((eq :double-float type)
       :double)
      ((eq :signed-32bit type)
       :int32)
      ((eq :signed-32bit type)
       :uint32)
      ((eq :single-float type)
       :float)
      ((eq :cardinal type)
       :unsigned-int)
      ((eq :fixnum type)
       :int)
      ((string= "CHAR" (symbol-name type))
       :char)
      ((string= "BOOLEAN" (symbol-name type))
       :boolean)
      ((string= "ATOM" (symbol-name type))
       :unsigned-long)
      ((string= "*" (symbol-name type))
       'clim-object
       ;; :pointer
       )
      ((c-struct-p type)
       (unless (c-type-defined-p type :struct)
	 ;; Define it as a pointer for now and hope that its real
	 ;; definition appears later
	 (let ((def `(cffi:defcstruct ,type)))
	   (format t "defining struct stub: ~s~%" def)
	   (eval def)))
       (list :struct type))
      (t
       (progn
	 (unless (or (c-type-defined-p type :default)
		     (c-type-defined-p type :struct))
	   ;; Define it as a pointer for now and hope that its
	   ;; real definition appears later
	   (format t "defining base-type stub (shouldn't get here): ~s~%"
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
	 ;; "fake" structure. This is really a list of symbols, with
	 ;; each member of the 'structure' being a symbol value pair
	 (defun ,accessor-name-symbol (struct-pointer)
	   (cond
	     ((typep struct-pointer 'cons)
	      (getf struct-pointer ',accessor-name-symbol))
	     (t
	      (cffi:foreign-slot-value  struct-pointer
	   				(quote (:struct ,struct-name))
	   				(quote ,slot-name)))))
	 (defun (setf ,accessor-name-symbol) (value struct-pointer)
	   (setf (cffi:foreign-slot-value struct-pointer
					  (quote (:struct ,struct-name))
					  (quote ,slot-name))
		 value)))))

  (defun emit-cffitype-specfier-on-possibly-composite-type
      (possibly-composite-type)
    ;; We only know how to handle pointer composite types
    (cond
      ((and (consp possibly-composite-type)
	    (= (length possibly-composite-type) 2)
	    (or (eq (emit-cffi-type-specfier (car possibly-composite-type)) :pointer)
		(eq (emit-cffi-type-specfier (car possibly-composite-type)) 'clim-object)))
       (list :pointer  (emit-cffi-type-specfier (cadr possibly-composite-type))))
      ((atom possibly-composite-type)
       (emit-cffi-type-specfier possibly-composite-type))
      (t
       (error "Unrecognized composite-type: ~s~%" possibly-composite-type))))

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
	  (ecase (get-ffi-slot-def-category slot)
	    ;; '(class-initialize xt-proc)
	    (:define-slot-base-type
	     (push (list slot-name
			 (emit-cffi-type-specfier (cadr slot)))
		   cffi-defcstruct))
	    ((:define-slot-base-vector-type :define-slot-base-pointer-type)
	     (push (list (car slot)
			 `(:pointer ,(emit-cffitype-specfier-on-possibly-composite-type (caddr slot))))
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
	   (cffi:foreign-alloc ',(emit-cffi-type-specfier type) :count number))
	 (defun ,name (entry-point index)
	   (cffi:mem-aref entry-point ',(emit-cffi-type-specfier type) index))
	 (defun (setf ,name) (value entry-point index)
	   (setf (cffi:mem-aref entry-point ',(emit-cffi-type-specfier type) index)
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
      ((and (= (length slot) 3)
	    (and (symbolp (car slot))
		 (numberp (cadr slot))
		 (let ((item (caddr slot)))
		   (or (symbolp item)
		       (consp item)))))
       :define-slot-base-vector-type)
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
	 (declare (ignore size))
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
  (declare (ignore body)))

#-use-cffi
(defmacro cstruct-prop (&body body)
  `(ff::cstruct-prop ,@body))

#+use-cffi
(defmacro cstruct-property-length (&body body)
  (declare (ignore body)))

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
  (declare (ignore language))
  name)


(defparameter *exported-foreign-functions* '())
(defparameter *exported-types* '())

(defun cfun-lisp-name (cfun-definition)
  (getf cfun-definition :name))

(defun cfun-c-name (cfun-definition)
  (cadr (assoc :name (getf cfun-definition :options))))

(defun cfun-c-return-type (cfun-definition)
  (or (cadr (assoc :return-type (getf cfun-definition :options)))
      :void))

(defun cfun-c-raw-args (cfun-definition)
  (getf cfun-definition :args))

(defun str (&rest rest)
  (apply #'concatenate (cons 'string rest)))

(defun print-types-used-alt ()
  (let ((all-types
	 (apply #'concatenate
		(cons 'list
		      (mapcar
		       (lambda (cfun-def)
			 (let* ((arg-types
				 (mapcar #'cadr
					 (getf cfun-def :args))))
			   arg-types))
		       *exported-foreign-functions*)))))
    all-types))

(defparameter *composite-types* (make-hash-table :test 'eql))

;; also converts simple type, i.e. (not (consp type))
(defun convert-composite-ff-type-to-cffi-type (type)
  ;; These are the only case we need to worry about as empiracally
  ;; found in CLIM2 by brute force.
  (cond
    ((and (consp type)
	  (eq (car type) :array))
     (list :pointer (convert-composite-ff-type-to-cffi-type (cadr type))))
    ((and (consp type)
	  (or (eq (car type) :pointer)
	      ;; avoid issues with which package symbol's in
	      (string= (symbol-name (car type)) "*")))
     (list :pointer (convert-composite-ff-type-to-cffi-type (cadr type))))
    ((atom type)
     (emit-cffi-type-specfier type))
    (t
     (error "unknown type, can't convert ~s" type))))


;; also converts simple type, i.e. (not (consp type))
(defun convert-composite-ff-type-to-cffi-type-alt (type)
  (format t "convert-composite-ff-type-to-cffi-type: ~A~%" type)
  (labels ((type-to-name (type)
	     (cond
	       ((consp type)
		(intern (format nil "~A-~A" (type-to-name (car type))
				(type-to-name (cdr type)))))
	       ((atom type)
		(intern (format nil "~A" type)))
	       (t
		(error "unrecognized type: ~a" type)))))
    ;; These are the only case we need to worry about as empiracally
    ;; found in CLIM2 by brute force.
    (cond
      ((and (consp type)
	    (eq (car type) :array))
       (list :pointer (convert-composite-ff-type-to-cffi-type (cadr type))))
      ((and (consp type)
	    (or (eq (car type) :pointer)
		;; avoid issues with which package symbol's in
		(string= (symbol-name (car type)) "*")
		(eq (car type) :struct)))
       (let* ((cffi-type-qualifier
	       (cond
		 ((or (eq (car type) :pointer)
		      ;; avoid issues with which package symbol's in
		      (string= (symbol-name (car type)) "*"))
		  :pointer)
		 ((eq (car type) :struct)
		  :struct)))
	      (cffi-type (type-to-name
			  (convert-composite-ff-type-to-cffi-type (cadr type))))
	      (actual-type (list cffi-type-qualifier cffi-type))
	      (simple-parser (intern (format nil "~A-~A" cffi-type-qualifier cffi-type)))
	      (cffi-class-name (intern (format nil "~A-~A-~A" cffi-type-qualifier
					       cffi-type :type))))
	 ;; For each composite type create a simple parser, a foreign
	 ;; type and a translation
	 (unless (gethash simple-parser *composite-types*)
	   (setf (gethash simple-parser *composite-types*)
		 type)
	   (cffi-define-foreign-type cffi-class-name actual-type simple-parser)
	   (cffi-define-translation-to-foreign cffi-class-name))
	 simple-parser))
      ((atom type)
       (emit-cffi-type-specfier type))
      (t
       (error "unknown type, can't convert ~s" type)))))

;; (defmethod cffi:translate-to-foreign (pointer (type display-type))
;;   (declare (ignore type))
;;   (foreign-pointer-address pointer))
(defun cffi-define-translation-to-foreign (cffi-class-name)
  (let* ((expression
	  `(defmethod cffi:translate-to-foreign (lisp-object (type ,cffi-class-name))
	     (declare (ignore type))
	     (foreign-pointer-address lisp-object))))
    (format t "generate-cffi-translate-to-foreign~%~s~%"
	    expression)
    (eval expression)))

  ;; (cffi:define-foreign-type display-type ()
  ;;     ()
  ;;     (:actual-type :pointer)
  ;;     (:simple-parser pointer-display))
  (defun cffi-define-foreign-type (cffi-class-name actual-type simple-parser)
    (let ((expression `(cffi:define-foreign-type ,cffi-class-name ()
	     ()
	     (:actual-type ,actual-type)
	     (:simple-parser ,simple-parser))))
    (format t "cffi-define-foreign-type~%~s~%" expression)
    (eval expression)))





(defun generate-cffi-arg-list (ff-arg-list)
  (mapcar (lambda (arg)
	    (list (car arg)
		  (convert-composite-ff-type-to-cffi-type (cadr arg))))
	  ff-arg-list))

(defun generate-cffi-defcfun (ff-def)
  (let* ((lisp-name (cfun-lisp-name ff-def))
	 (c-name (cfun-c-name ff-def))
	 (c-return (cfun-c-return-type ff-def))
	 (c-args (cfun-c-raw-args ff-def)))
    `(cffi:defcfun (,lisp-name ,c-name)
	 ,(convert-composite-ff-type-to-cffi-type c-return)
       ,@(generate-cffi-arg-list c-args))))



#+use-cffi
(eval-when (:compile-toplevel :load-toplevel :execute)
  (defmacro def-exported-foreign-function ((name &rest options) &rest args)
    (push (list :name name :options options :args args)
	  *exported-foreign-functions*)
    (format t "def-exported-foreign-function: ~s ~%" name)
    `(progn
       (eval-when (eval load compile)
	 (export ',name))
       (eval-when (:compile-toplevel :load-toplevel :execute)
	 ,(generate-cffi-defcfun (list :name name :options options :args args))))))

;; total of 128
(defparameter *foreign-call* '())


;; (defun get-c-name-foreign-call (call-def)
;;   (let ((call-def-name (car call-def)))
;;   (cond
;;     ((and (consp call-def-name)
;; 	  (= (length call-def-name) 2))
;;      (cadr call-def-name))
;;     ((and (atom call-def-name)
;; 	  (symbolp call-def-name))
;;      (string-downcase (symbol-name call-def-name)))
;;     (t
;;      (error "Unable to parse foreign call ~s~%" call-def)))))

(defun get-lisp-name-foreign-call (call-def)
  (let ((call-def-name (car call-def)))
    (cond
      ((and (consp call-def-name)
	    (= (length call-def-name) 2))
       (car call-def-name))
      ((and (atom call-def-name)
	    (symbolp call-def-name))
       call-def-name)
      (t
       (error "Unable to parse foreign call ~s~%" call-def)))))


(defun get-c-name-foreign-call (call-def)
  (cond
    ((and (consp (car call-def))
	  (= (length (car call-def)) 2))
     (cadar call-def))
    ((and (atom (car call-def))
	  (symbolp (car call-def)))
     (string-downcase (symbol-name (car call-def))))
    (t
     (error "Unable to parse c-name of foreign call ~s~%" call-def))))

(defun get-raw-args-foreign-call (call-def)
  (let ((call-def-name (cadr call-def)))
    call-def-name))

(defun get-converted-arg-foreign-call (raw-arg)
  (cond
    ((atom raw-arg)
     (list raw-arg :int))
    ((and (consp raw-arg)
	  (= (length raw-arg) 2))
     (list (car raw-arg) (convert-composite-ff-type-to-cffi-type (cadr raw-arg))))
    ((and (consp raw-arg)
	  (= (length raw-arg) 3)
	  (eq (cadr raw-arg) :int))
     (list (car raw-arg) :int))
    ((and (consp raw-arg)
	  (= (length raw-arg) 3)
	  (consp (cadr raw-arg))
	  (string= (symbol-name (caadr raw-arg)) "*")
	  (eq (cadr (cadr raw-arg)) :char))
     (list (car raw-arg) '(:pointer :char)))
    (t
     (error "Unexpected argument type: ~s" raw-arg))))

(defun get-converted-args-foreign-call (raw-args)
    (cond
      ((and (= (length raw-args) 1)
	    (eq (car raw-args) :void))
       nil)
      (t
       (mapcar (lambda (arg)
		 (get-converted-arg-foreign-call arg))
	       raw-args))))

(defun get-converted-return-type-foreign-call (call-def)
  (let ((raw-return-type (getf (cddr call-def) :returning)))
    (cond
      ((and (consp raw-return-type)
	    (= (length raw-return-type) 2)
	    (eq (car raw-return-type) :int))
       :int)
      ((atom raw-return-type)
       (convert-composite-ff-type-to-cffi-type raw-return-type))
      (t
       (error "unidentified return type: ~s" raw-return-type)))))

;; (defmethod cffi:translate-to-foreign (pointer (type foreign-pointer))
;;   (declare (ignore type))
;;   (foreign-pointer-address pointer))

(defun generate-cffi-defcfun-from-ff-def-foreign-call (ff-def)
  (let* ((lisp-name (get-lisp-name-foreign-call ff-def))
	 (c-name (get-c-name-foreign-call ff-def))
	 (c-return (get-converted-return-type-foreign-call ff-def))
	 (c-args (get-converted-args-foreign-call
		  (get-raw-args-foreign-call ff-def))))
    `(cffi:defcfun (,lisp-name ,c-name)
	 ,c-return
       ,@c-args)))

(defun print-types-used ()
  (let ((all-types
	 (apply #'concatenate
		(cons 'list
		      (mapcar
		       (lambda (cfun-def)
			 (let* ((arg-types
				 (mapcar #'cadr
					 (getf cfun-def :args))))
			   arg-types))
		       *exported-foreign-functions*)))))
    all-types))


(defvar *foreign-callables* '())

#+use-cffi
(eval-when (:compile-toplevel :load-toplevel :execute)

  ;; A null-pointer is a foreign :POINTER that must always be NULL.
  ;; Both a null pointer, the number 0 and nil are legal values -- any
  ;; others will result in a runtime error.
  

  ;; This type translator is used to ensure that a NULL-POINTER has a
  ;; null value.  It also converts NIL to a null pointer.
  ;; (defmethod translate-to-foreign ((value (eql 0)) (type pointer-type))
  ;;   (null-pointer))

  ;; (defmethod translate-to-foreign ((value (eql nil)) (type pointer-type))
  ;;   (null-pointer))


  ;; This type translator is used to ensure that a NULL-POINTER has a
  ;; null value.  It also converts NIL to a null pointer.
  ;; (defmethod translate-to-foreign ((value number) (type null-pointer-type))
  ;;   (cond
  ;;     ((zerop value) (null-pointer))
  ;;     ((null value) (null-pointer))
  ;;     (t (error "~A is not a null pointer." value))))


  ;; (defmethod translate-to-foreign ((value system-area-pointer) (type null-pointer-type))
  ;;   (cond
  ;;     ((null-pointer-p value) value)
  ;;     (t (error "~A is not a null pointer." value))))                    
  
  (defun get-entry-point (x)
    (cffi:foreign-symbol-pointer x))

  (defun free-fobject (pointer)
    (cffi:foreign-free pointer))

  (defclass foreign-pointer ()
    ((foreign-address :accessor foreign-pointer-address :initarg :foreign-address)))

  (defmacro defun-foreign-callable (name args &rest body)
    `(cffi:defcallback ,name :void ,(get-converted-args-foreign-call args)
       ,@body))

  (defun register-foreign-callable (&rest callable)
    ;; Ignore all other arguments
    (let ((callable-name (car callable)))
      (format t "callable-name: ~s~%" callable-name)
      (cffi:get-callback callable-name)))

  (defmacro def-foreign-type (&body body)
    (declare (ignore body))
    '(cffi:defcstruct event-match-info
      (display (:pointer :void))
      (seq-no :unsigned-long)
      (n-types :int)
      (event-types (:pointer :int))))

  (defmacro def-foreign-call (&body body)
    (generate-cffi-defcfun-from-ff-def-foreign-call body)))

#-use-cffi
(eval-when (:compile-toplevel :load-toplevel :execute)
  ;; (defun free-fobject (pointer)
  ;;   (ff:free-fobject pointer))

  ;; (defclass foreign-pointer (ff:foreign-pointer)
  ;;   ())

  ;; (defmethod foreign-pointer-address ((foreign-pointer foreign-pointer))
  ;;   (ff:foreign-pointer-address foreign-pointer))

  ;; (defmethod (setf foreign-pointer-address) ((foreign-pointer foreign-pointer) value)
  ;;   (setf (ff:foreign-pointer-address foreign-pointer) value))

  ;; (defmethod (setf foreign-pointer-address) ((fixnum fixnum) value)
  ;;   (setf (ff:foreign-pointer-address fixnum) value))

  (defun get-entry-point (x)
    (ff:get-entry-point x))

  (defun register-foreign-callable (&rest rest)
       (apply #'ff:register-foreign-callable rest))

  (defmacro defun-foreign-callable (&body body)
    (format t "~s~%" body)
    (push  body *foreign-callables*)
    `(ff::defun-foreign-callable ,@body))

  (defmacro def-foreign-call (&body body)
    (push  body *foreign-call*)
    `(ff::def-foreign-call ,@body))

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
		    (if (get (cadr type) 'ff::cstruct)
			'(:foreign-address)
			'(:lisp))))))))

  (defmacro def-exported-foreign-function ((name &rest options) &rest args)
    (push (list :name name :options options :args args)
	  *exported-foreign-functions*)
    (format t "def-exported-foreign-function: ~s ~%" name)
    `(progn
       (eval-when (eval load compile)
	 (export ',name))
       (eval-when (compile eval load)
	 ,(let ((c-name (second (assoc :name options)))
		(return-type (or (second (assoc :return-type options))
				 'void)))
	    `(ff:def-foreign-call (,name ,c-name)
				  ,(or (mapcar #'trans-arg-type args) '(:void))
				  :returning ,(trans-return-type return-type)
				  :call-direct t
				  :arg-checking nil)))))

  (defmacro def-foreign-type (&body body)
    `(ff:def-foreign-type ,@body)))

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
