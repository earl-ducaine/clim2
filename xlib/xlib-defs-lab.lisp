(in-package :x11)

;; In the xlib-defs.lisp file the following provides definitions clim2
;; needs to access the c interface to motif. def-exported-constant is
;; already portable, being just a wrapper around export and
;; defconstant.  def-exported-foreign-struct, and
;; def-exported-foreign-synonym-type need to be reimplemented in cffi
;; to be made portable.


(defparameter size-hints (x11::xallocsizehints))
;;(defparameter flags (x11::xsizehints-flags size-hints))

;; clim2 format:
;;
;; (def-exported-foreign-function
;;     (xallocsizehints
;;      (:name "XAllocSizeHints")
;;      (:return-type (:pointer xsizehints))))
;;
;; alegro ff format:
;;
;; (foreign-functions:def-foreign-call
;;     (xallocsizehints "XAllocSizeHints") (:void)
;;   :returning :foreign-address
;;   :call-direct t
;;   :arg-checking nil)))
;;
;; cffi format:
;; (cffi:defcfun (xallocsizehints "XAllocSizeHints") :pointer)
;;
;; Original -cffi format
;; (def-exported-foreign-function-cffi
;;     (xallocsizehints
;;      (:name "XAllocSizeHints")
;;      (:return-type (:pointer xsizehints))))

(cffi:defcfun "strlen" :int
  "Calculate the length of a string"
  (n :string))

(ff-wrapper:def-foreign-call
    (xallocsizehints "XAllocSizeHints") (:void)
  :returning :foreign-address
  :call-direct t
  :arg-checking nil)

(defun run-set-foreign-slot-value ()
  (set-foreign-slot-value size-hints 'xsizehints 'flags 1))

(defun set-foreign-slot-value (object struct slot value)
  (setf (cffi:foreign-slot-value object struct slot)  value)
  value)

(defun access-foreign-slot-value (object struct slot)
  (cffi:foreign-slot-value object struct slot)  value)

;; (defun set-xsizehints-flags (cstruct value)
;;   (setf (cffi:foreign-slot-value object struct slot) value))

;; (defsetf xsizehints-flags set-xsizehints-flags)

;; (multiple-value-bind (dummies vals newval setter getter)
;;     (get-setf-expansion size-hints)
;;   (list dummies vals newval setter getter))


;; (defun run-define-setf-expander-lastguy ()
;;   (define-setf-expander lastguy (x &environment env)
;;     "Set the last element in a list to the given value."
;;     (multiple-value-bind (dummies vals newval setter getter)
;; 	(get-setf-expansion x env)
;;       (let ((store (gensym)))
;; 	(values dummies
;; 		vals
;; 		`(,store)
;; 		`(progn (rplaca (last ,getter) ,store) ,store)
;; 		`(lastguy ,getter))))))

(defun run-foreign-slot-value-cffi ()
  (define-setf-expander foreign-slot-value-cffi (x &environment env)
    (multiple-value-bind (dummies vals newval setter getter)
	(get-setf-expansion x env)
      (let ((store (gensym)))
	(values dummies
		vals
		`(,store)
		`(progn (setf (cffi:foreign-slot-value size-hints 'xsizehints 'flags)
			      ,store))
		`,getter)))))


(defvar a)
(defvar b)
(defvar c)

(defun cffi-test (cstruct)
  (cffi:foreign-slot-value
   (:pointer (:struct struct))
   (find-symbol (string-upcase "xsizehints") :x11)
   (find-symbol (string-upcase "flags") :x11)))

(defun run-cffi-test ()
  (let ((size-hints (x11::xallocsizehints)))))

;; (defun lastguy (x) (car (last x)))

;; (defun reset-lastguy ()
;;   (setf a (list 'a 'b 'c 'd))
;;   (setf b (list 'x))
;;   (setf c (list 1 2 3 (list 4 5 6))))

;; (defun run-setf-lastguy ()
;;   (setf (lastguy a) 3)
;;   (setf (lastguy b) 7))

;; Old way of creating interface to xcomposestatus.
;; (def-exported-foreign-struct-cffi xcomposestatus-ffi
;;     "Xcomposestatus structure."
;;   (compose-ptr :type (:pointer char))
;;   (chars-matched :type int))

;; New way of creating interface to xcomposestatus.
(cffi:defcstruct xcomposestatus-lab
  "Xcomposestatus structure."
  (compose-ptr (:pointer :char))
  (chars-matched :int))

;; (eval-when (eval load compile)

;; (defparameter *builtin-ctypes*
;;   '(char unsigned-char short unsigned-short int unsigned-int long unsigned-long
;;     long-long unsigned-long-long uchar ushort uint ulong llong llong ullong
;;     int8 uint8 int16 uint16 int32 uint32 int64 uint64 float double long-double
;;     pointer void))

;; (defun convert-builtin-ctypes-to-keyword (symbol)
;;   (if (member symbol *builtin-ctypes*)
;;       (alexandria:make-keyword (string-upcase (symbol-name symbol)))
;;       symbol))

;; So, def-exported-foreign-struct-cffi has to render the old to the
;; new.
;; (defun compute-cffi-style-cstruct-type (type)
;;   (cond ((listp type) (if (eq (car type) :pointer)
;; 			  :pointer
;; 			  (mapcar (lambda (symbol)
;; 				    (convert-builtin-ctypes-to-keyword symbol))
;; 				  type)))
;; 	(t (convert-builtin-ctypes-to-keyword type))))

;; (defun compute-cffi-style-cstruct-slot-lab (slot)
;;   (destructuring-bind (slot-name &key type overlays)
;;       slot
;;     (list slot-name (compute-cffi-style-cstruct-type type))))

;; (defmacro def-exported-foreign-struct-cffi-lab (name-and-options &rest slots)
;;   (let ((cffi-slots
;; 	 (reverse
;; 	  (reduce
;; 	   (lambda (slots slot)
;; 	     (cond  ((stringp slot)
;; 		     ;; documentation string
;; 		     (cons slot slots))
;; 		    ((or (listp slot)
;; 			 (symbolp slot)
;; 			 (keywordp slot))
;; 		     (cons (compute-cffi-style-cstruct-slot slot) slots))
;; 		    (t (error "unexpected slot type"))))
;; 	   slots
;; 	   :initial-value '()))))
;;     `(cffi:defcstruct ,name-and-options ,@cffi-slots)))

(defmacro def-c-typedef (lisp-type c-type)
  `(progn
     (ff-wrapper:def-c-typedef ,lisp-type ,c-type)
     (cffi:defctype ,lisp-type ,c-type)))

(defmacro def-c-type (type-spec storage-type &body body)

  `(progn
     (ff-wrapper:def-c-typedef ,type-spec ,storage-type ,@body)
     (,(if (eq storage-type :struct) 'cffi:defcstruct 'cffi:defctype)
       ,(if (consp type-spec) (car type-spec) type-spec)
       ,@body)))


;; (def-exported-foreign-struct-cffi xextdata-cffi
;;     (number :type int)
;;   (next :type (:pointer xextdata))
;;   (free-private :type (:pointer :pointer))
;;   (private-data :type (:pointer char)))







;; (defmacro def-exported-constant-cffi ()
;;   was-called-above 0)

;; (defmacro def-exported-constant (name value)
;;   ;; define the constant and export it from :x11
;;   `(progn
;;      (eval-when (eval load compile)
;;        (export ',name))
;;      (defconstant ,name ,value)))




;; ;;(def-exported-constant was-called-above 0)


;; ;; (defmacro def-exported-foreign-struct-cffi (name-and-options &rest slots)
;; ;;   (let ((cffi-cstruct-slots (compute-cffi-style-cstruct-slots slots))
;; ;; 	(cffi-cstruct-slots-sym (gensym)))
;; ;;     `(let ((,cffi-cstruct-slots-sym ,cffi-cstruct-slot))
;; ;;        (cffi:defcstruct ,name-and-options
;; ;; 	 ,@cffi-cstruct-slots-sym))))

;; ;; (compose-ptr (:pointer :char))
;; ;; (chars-matched :int))

;; ;; (def-exported-foreign-struct xcomposestatus-ffi
;; ;;     (compose-ptr :type (:pointer char))
;; ;;   (chars-matched :type int))

;; ;; (cffi:defcstruct xcomposestatus
;; ;;     "Xcomposestatus structure."
;; ;;     (compose-ptr (:pointer :char))
;; ;;     (chars-matched :int))


;; ;; (def-exported-foreign-struct xanyevent
;; ;;     (type :type int)
;; ;;   (serial :type unsigned-long)
;; ;;   (send-event :type int)
;; ;;   (display :type (:pointer display))
;; ;;   (window :type window))

;; ;; (cffi:defcstruct xanyevent
;; ;;   (type :int)
;; ;;   (serial :unsigned-long)
;; ;;   (send-event :int)
;; ;;   (display (:pointer display))
;; ;;   (window window))




;; ;; (define-foreign-type curl-code-type ()
;; ;;   ()
;; ;;   (:actual-type :int)
;; ;;   (:simple-parser curl-code))

;; ;; (cstruct-and-class
;; ;;  display-cffi
;; ;;  ((context :initarg :context :reader display-context)
;; ;;   (xid->object-mapping :initform (make-hash-table :test #'equal)
;; ;; 		       excl::fixed-index 0)))


;; ;; (cffi:defcstruct xcomposestatus2
;; ;;   "Xcomposestatus structure."
;; ;;   (compose-ptr (:struct xcomposestatus))
;; ;;   (chars-matched :int))


;; ;; (cffi:defcstruct xcomposestatus2
;; ;;   "Xcomposestatus structure."
;; ;;   (compose-ptr (:pointer :char))
;; ;;   (chars-matched :int))



;; (defun iota (n) (loop for i from 1 to n collect i))       ;helper
;; (destructuring-bind ((a &optional (b 'bee)) one two three)
;;     `((alpha) ,@(iota 3)))

;; ;; (:struct
;; ;;     (list slot-name type overlays))
;; ;;   (destructuring-bind ((a &optional (b 'bee)) one two three)

;; ;; (def-exported-foreign-struct-cffi  '(  (type :type int)
;; ;; 				     (xany :type xanyevent :overlays type)
;; ;; 				     (xkey :type xkeyevent :overlays xany)
;; ;; 				     (xbutton :type xbuttonevent :overlays xany)
;; ;; 				     (xmotion :type xmotionevent :overlays xany)
;; ;; 				     (xcrossing :type xcrossingevent :overlays xany)
;; ;; 				     (xfocus :type xfocuschangeevent :overlays xany)
;; ;; 				     (xexpose :type xexposeevent :overlays xany)
;; ;; 				     (xgraphicsexpose :type xgraphicsexposeevent :overlays xany)
;; ;; 				     (xnoexpose :type xnoexposeevent :overlays xany)
;; ;; 				     (xvisibility :type xvisibilityevent :overlays xany)
;; ;; 				     (xcreatewindow :type xcreatewindowevent :overlays xany)
;; ;; 				     (xdestroywindow :type xdestroywindowevent :overlays xany)
;; ;; 				     (xunmap :type xunmapevent :overlays xany)
;; ;; 				     (xmap :type xmapevent :overlays xany)
;; ;; 				     (xmaprequest :type xmaprequestevent :overlays xany)
;; ;; 				     (xreparent :type xreparentevent :overlays xany)
;; ;; 				     (xconfigure :type xconfigureevent :overlays xany)
;; ;; 				     (xgravity :type xgravityevent :overlays xany)
;; ;; 				     (xresizerequest :type xresizerequestevent :overlays xany)
;; ;; 				     (xconfigurerequest :type xconfigurerequestevent :overlays xany)
;; ;; 				     (xcirculate :type xcirculateevent :overlays xany)
;; ;; 				     (xcirculaterequest :type xcirculaterequestevent :overlays xany)
;; ;; 				     (xproperty :type xpropertyevent :overlays xany)
;; ;; 				     (xselectionclear :type xselectionclearevent :overlays xany)
;; ;; 				     (xselectionrequest :type xselectionrequestevent :overlays xany)
;; ;; 				     (xselection :type xselectionevent :overlays xany)
;; ;; 				     (xcolormap :type xcolormapevent :overlays xany)
;; ;; 				     (xclient :type xclientmessageevent :overlays xany)
;; ;; 				     (xmapping :type xmappingevent :overlays xany)
;; ;; 				     (xerror :type xerrorevent :overlays xany)
;; ;; 				     (xkeymap :type xkeymapevent :overlays xany)
;; ;; 				     (pad :type (:array long (24)) :overlays xany)))

;; ;; Create a slot accessor function exported in the specified package.
;; ;; (defun generate-slot-accessor-old (package-name cstruct-name slot-name)
;; ;;   (let* ((symbol (create-slot-accessor-symbol package-name cstruct-name slot-name))
;; ;; 	 (setter-symbol (create-slot-setter-symbol package-name cstruct-name slot-name)))
;; ;;     (format t "symbol ~s, (type-of symbol) ~s~%" symbol (type-of symbol))
;; ;;     (defun set-xsizehints-flags (cstruct value)
;; ;;       (setf (cffi:foreign-slot-value object struct slot) value))
;; ;;     (defsetf xsizehints-flags set-xsizehints-flags)
;; ;;     (setf (symbol-function symbol)
;; ;; 	  (function (lambda (struct)
;; ;; 	    (cffi:foreign-slot-value struct
;; ;; 				     (find-symbol (string-upcase cstruct-name) :x11)
;; ;; 				     (find-symbol (string-upcase slot-name) :x11)))))))
