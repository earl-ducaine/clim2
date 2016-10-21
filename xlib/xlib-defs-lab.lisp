
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

  (defun compute-cffi-style-cstruct-slot (slot)
    (destructuring-bind (slot-name &key type overlays)
	slot
      (cond
	((member type '(char int keysym long long short unsigned
			unsigned-char unsigned-int unsigned-long
			unsigned-short))
	 (list slot-name (alexandria:make-keyword (string-upcase (symbol-name type)))))
	((atom type)
	 (list slot-name (list :struct (alexandria:make-keyword (string-upcase (symbol-name type)))))))))




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
