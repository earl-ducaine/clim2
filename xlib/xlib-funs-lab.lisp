


(in-package :x11)

;; (defmethod cffi::translate-to-foreign (object (type x11::display-type))
;;   (ff-wrapper::foreign-pointer-address object))


(defun create-translation (struct-name struct-simple-parser-name foreign-type-name)
  (let ((definitions
	   `(progn
     (cffi:defctype ,struct-simple-parser-name (:pointer (:struct ,struct-name)))
      (cffi:define-foreign-type ,foreign-type-name ()
	()
	(:actual-type :pointer)
	(:simple-parser ,struct-simple-parser-name))
      (defmethod cffi::translate-to-foreign (object (type ,foreign-type-name))
	(ff-wrapper::foreign-pointer-address object))
      )))
    (format t "~A~%" definitions)
  (eval
   definitions
   )))

(defun create-translation-for-base-type (base-type)
  (create-translation
   base-type
   (intern (format nil "~A-~A-~A"  'pointer 'struct base-type))
   (intern (format nil "~A-~A-~A-~A"  'pointer 'struct base-type 'type))))

(defun run-create-translation-for-base-type ()
  (create-translation-for-base-type 'display)
  (create-translation-for-base-type 'screen))


(CFFI:DEFCFUN (XDEFAULTSCREEN "XDefaultScreen")
       INT
     (DPY (:POINTER (:STRUCT DISPLAY))))

(defcstruct (struct-pair :class pair)
  (a :int)
  (b :int))

(defcstruct (struct-pair :class pair)
  (a :int)
  (b :int))

(defctype struct-pair-typedef1 (:struct struct-pair))
(defctype struct-pair-typedef2 (:pointer (:struct struct-pair)))

;; display

(cffi:defcstruct (display :class display-type)
  (ext-data (:pointer (:struct xextdata)))
  (next (:pointer (:struct display)))
  (fd int)
  (lock int)
  (proto-major-version int)
  (proto-minor-version int)
  (vendor (:pointer :char))
  (resource-base long)
  (resource-mask long)
  (resource-id long)
  (resource-shift int)
  (resource-alloc (:pointer ff-wrapper::clim-object))
  (byte-order int)
  (bitmap-unit int)
  (bitmap-pad int)
  (bitmap-bit-order int)
  (nformats int)
  (pixmap-format (:pointer (:struct screenformat)))
  (vnumber int)
  (release int)
  (head (:pointer _xsqevent))
  (tail (:pointer _xsqevent))
  (qlen int)
  (last-request-read unsigned-long)
  (request unsigned-long)
  (last-req (:pointer :char))
  (buffer (:pointer :char))
  (bufptr (:pointer :char))
  (bufmax (:pointer :char))
  (max-request-size unsigned)
  (db (:pointer _xrmhashbucketrec))
  (synchandler (:pointer ff-wrapper::clim-object))
  (display-name (:pointer :char))
  (default-screen int)
  (nscreens int)
  (screens (:pointer (:struct screen)))
  (motion-buffer unsigned-long)
  (current window)
  (min-keycode int)
  (max-keycode int)
  (keysyms (:pointer keysym))
  (modifiermap (:pointer (:struct xmodifierkeymap)))
  (keysyms-per-keycode int)
  (xdefaults (:pointer :char))
  (scratch-buffer (:pointer :char))
  (scratch-length unsigned-long)
  (ext-number int)
  (ext-procs (:pointer (:struct _xextension)))
  (event-vec (:pointer (:pointer ff-wrapper::clim-object)))
  (wire-vec (:pointer (:pointer ff-wrapper::clim-object)))
  (lock-meaning keysym)
  (key-bindings (:pointer xkeytrans))
  (cursor-font font))


(cffi:defcfun (xdefaultscreen "XDefaultScreen")
       int
     (dpy pointer-struct-display))

(cffi:defctype pointer-struct-display (:pointer (:struct display)))

(defmethod cffi::translate-to-foreign (object (type pointer-struct-display-type))
  (ff-wrapper::foreign-pointer-address object))


(cffi:define-foreign-type pointer-struct-display-type ()
  ()
  (:actual-type (:pointer (:struct display)))
  (:simple-parser pointer-struct-display))

(defun visual-class (ff-wrapper::struct-pointer)
  (cond
    ((typep ff-wrapper::struct-pointer 'cons)
     (getf ff-wrapper::struct-pointer 'visual-class))
    ((typep ff-wrapper::struct-pointer 'ff-wrapper:foreign-pointer)
     (cffi:foreign-slot-value
      (ff-wrapper:foreign-pointer-address ff-wrapper::struct-pointer)
      '(:struct visual) 'class))
    (t
     (cffi:foreign-slot-value ff-wrapper::struct-pointer '(:struct visual)
			      'class))))
