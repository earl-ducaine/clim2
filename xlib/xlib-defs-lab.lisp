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
(def-exported-foreign-struct-cffi xcomposestatus-ffi
    "Xcomposestatus structure."
  (compose-ptr :type (:pointer char))
  (chars-matched :type int))

;; New way of creating interface to xcomposestatus.
(cffi:defcstruct xcomposestatus-lab
    "Xcomposestatus structure."
    (compose-ptr (:pointer :char))
    (chars-matched :int))

;; So, def-exported-foreign-struct-cffi has to render the old to the new.

(defun compute-cffi-style-cstruct-type (type)
  (cond ((listp type) (if (eq (car type) :pointer)
			  :pointer
			  (mapcar (lambda (symbol)
				    (convert-builtin-ctypes-to-keyword symbol))
				  type)))
	(t (convert-builtin-ctypes-to-keyword type))))


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

(def-exported-foreign-struct-cffi xextdata-cffi
  (number :type int)
  (next :type (:pointer xextdata))
  (free-private :type (:pointer :pointer))
  (private-data :type (:pointer char)))







(defmacro def-exported-constant-cffi ()
  was-called-above 0)

(defmacro def-exported-constant (name value)
  ;; define the constant and export it from :x11
  `(progn
     (eval-when (eval load compile)
       (export ',name))
     (defconstant ,name ,value)))




;;(def-exported-constant was-called-above 0)


(defmacro def-exported-foreign-struct-cffi (name-and-options &rest slots)
  (let ((cffi-cstruct-slots (compute-cffi-style-cstruct-slots slots))
	(cffi-cstruct-slots-sym (gensym)))
    `(let ((,cffi-cstruct-slots-sym ,cffi-cstruct-slot))
       (cffi:defcstruct ,name-and-options
	 ,@cffi-cstruct-slots-sym))))

	 ;; (compose-ptr (:pointer :char))
	 ;; (chars-matched :int))

(def-exported-foreign-struct xcomposestatus-ffi
  (compose-ptr :type (:pointer char))
  (chars-matched :type int))




;; (cffi:defcstruct xcomposestatus
;;     "Xcomposestatus structure."
;;     (compose-ptr (:pointer :char))
;;     (chars-matched :int))


(def-exported-foreign-struct xanyevent
  (type :type int)
  (serial :type unsigned-long)
  (send-event :type int)
  (display :type (:pointer display))
  (window :type window))

(cffi:defcstruct xanyevent
  (type :int)
  (serial :unsigned-long)
  (send-event :int)
  (display (:pointer display))
  (window window))



(defclass display (ff:foreign-pointer)
  ((context :initarg :context :reader display-context)
   (xid->object-mapping :initform (make-hash-table :test #'equal)
			excl::fixed-index 0)))



(define-foreign-type curl-code-type ()
    ()
    (:actual-type :int)
    (:simple-parser curl-code))


(cstruct-and-class
 display-cffi
 ((context :initarg :context :reader display-context)
  (xid->object-mapping :initform (make-hash-table :test #'equal)
		       excl::fixed-index 0)))




(cffi:defcstruct xcomposestatus2
    "Xcomposestatus structure."
    (compose-ptr (:struct xcomposestatus))
    (chars-matched :int))


(cffi:defcstruct xcomposestatus2
    "Xcomposestatus structure."
    (compose-ptr (:pointer :char))
    (chars-matched :int))



(defun iota (n) (loop for i from 1 to n collect i))       ;helper
(destructuring-bind ((a &optional (b 'bee)) one two three)
    `((alpha) ,@(iota 3))






(:struct



    (list slot-name type overlays))






  (destructuring-bind ((a &optional (b 'bee)) one two three)





(def-exported-foreign-struct-cffi  '(  (type :type int)
  (xany :type xanyevent :overlays type)
  (xkey :type xkeyevent :overlays xany)
  (xbutton :type xbuttonevent :overlays xany)
  (xmotion :type xmotionevent :overlays xany)
  (xcrossing :type xcrossingevent :overlays xany)
  (xfocus :type xfocuschangeevent :overlays xany)
  (xexpose :type xexposeevent :overlays xany)
  (xgraphicsexpose :type xgraphicsexposeevent :overlays xany)
  (xnoexpose :type xnoexposeevent :overlays xany)
  (xvisibility :type xvisibilityevent :overlays xany)
  (xcreatewindow :type xcreatewindowevent :overlays xany)
  (xdestroywindow :type xdestroywindowevent :overlays xany)
  (xunmap :type xunmapevent :overlays xany)
  (xmap :type xmapevent :overlays xany)
  (xmaprequest :type xmaprequestevent :overlays xany)
  (xreparent :type xreparentevent :overlays xany)
  (xconfigure :type xconfigureevent :overlays xany)
  (xgravity :type xgravityevent :overlays xany)
  (xresizerequest :type xresizerequestevent :overlays xany)
  (xconfigurerequest :type xconfigurerequestevent :overlays xany)
  (xcirculate :type xcirculateevent :overlays xany)
  (xcirculaterequest :type xcirculaterequestevent :overlays xany)
  (xproperty :type xpropertyevent :overlays xany)
  (xselectionclear :type xselectionclearevent :overlays xany)
  (xselectionrequest :type xselectionrequestevent :overlays xany)
  (xselection :type xselectionevent :overlays xany)
  (xcolormap :type xcolormapevent :overlays xany)
  (xclient :type xclientmessageevent :overlays xany)
  (xmapping :type xmappingevent :overlays xany)
  (xerror :type xerrorevent :overlays xany)
  (xkeymap :type xkeymapevent :overlays xany)
  (pad :type (:array long (24)) :overlays xany)))
