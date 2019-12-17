

(in-package :x11)

(defun create-translation (struct-name struct-simple-parser-name foreign-type-name)
  (let ((definitions
	   `(eval-when (:compile-toplevel :load-toplevel :execute)
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
