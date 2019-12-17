;; -*- mode: common-lisp; package: tk -*-
;; See the file LICENSE for the full license governing this code.
;;

(in-package :tk)

;;; We have to interface to various foreign functions in the toolkit

(defclass application-context (ff-wrapper:foreign-pointer)
  ((displays :initform nil :accessor application-context-displays)))

(defmethod cffi:translate-to-foreign (pointer (type ff-wrapper::clim-object-type))
  (declare (ignore type))
  (format t "translate-to-foreign ~s~%" pointer)
  (cond
    ((typep pointer 'ff-wrapper:foreign-pointer)
     (let ((foreign-pointer-address
	    (ff-wrapper::foreign-pointer-address pointer)))
       (format
	t
	"cffi:translate-to-foreign (ff-wrapper::foreign-pointer-address pointer):~%"
	foreign-pointer-address)	       
       (cond
	 ((numberp foreign-pointer-address)
	  (cffi:make-pointer foreign-pointer-address))
	 (t
	  foreign-pointer-address))))
    ((and (numberp pointer)
	  (zerop pointer))
     (cffi:null-pointer))
    ((null pointer)
     (cffi:null-pointer))
    ((stringp pointer)
     (cffi:foreign-string-alloc pointer))
    (t
     pointer)))

(defparameter *error-handler-function-address* nil)
(defparameter *warning-handler-function-address* nil)

(defmethod initialize-instance :after ((c application-context) &key context)
  (let ((context (or context (xt_create_application_context))))
    (setf (ff-wrapper:foreign-pointer-address c) context)
    (xt_app_set_error_handler
     context
     (or *error-handler-function-address*
	 (setq *error-handler-function-address*
	   (ff-wrapper:register-foreign-callable 'toolkit-error-handler))))
    (xt_app_set_warning_handler
     context
     (or *warning-handler-function-address*
	 (setq *warning-handler-function-address*
	   (ff-wrapper:register-foreign-callable 'toolkit-warning-handler))))))

(defun create-application-context ()
  (make-instance 'application-context))

(defparameter *large-connection-quantum* 20)

(defun open-display (&key (context (create-application-context))
		       (host nil)
		       (application-name "clim")
		       (application-class "Clim")
		       (options 0)
		       (num-options 0)
		       (argc 0)
		       (argv 0))
  (let ((d (with-ref-par ((argc argc :int))
	     (let (
		   #+allegro (temp (mp:process-quantum mp:*current-process*)))
	       (unwind-protect
		    (progn
		      #+allegro (setf (mp:process-quantum mp:*current-process*) *large-connection-quantum*)
		      #+allegro (mp:process-allow-schedule)
		      #-allegro (xt_open_display context
						 (if host
						     (lisp-string-to-string8 host)
						     0)
						 (lisp-string-to-string8 application-name)

						 (lisp-string-to-string8 application-class)
						 options
						 num-options &argc argv)
		      #+allegro (xt_open_display context
						 (if host
						     (lisp-string-to-string8 host)
						     0)
						 (lisp-string-to-string8 application-name)

						 (lisp-string-to-string8 application-class)
						 options
						 num-options &argc argv))
		 #+allegro (setf (mp:process-quantum mp:*current-process*) temp)
		 #+allegro (mp:process-allow-schedule))))))
    (when (or (and (numberp d) (zerop d)) (cffi:null-pointer-p d))
	(error "cannot open the display: ~A" host))
    ;; Used for debugging:
    #+ignore
    (x11:xsynchronize d 1)
    d))

(defmethod initialize-instance :after ((d display) &rest args
				       &key display
				       &allow-other-keys)
  (push d (application-context-displays (slot-value d 'context)))
  (setf (ff-wrapper:foreign-pointer-address d)
    (or display
	(apply #'open-display args)))
  (register-address d))

(defun display-database (display)
  (make-instance 'resource-database
		 :foreign-address (xt_database display)))


(defun get-application-name-and-class (display)
  (with-ref-par ((name 0 *)
		 (class 0 *))
    (xt_get_application_name_and_class display &name &class)
    (values
     #-allegro (cffi:foreign-string-to-lisp name)
     #+allegro (excl:native-to-string name)
     #-allegro (cffi:foreign-string-to-lisp class)
     #+allegro (excl:native-to-string class))))
