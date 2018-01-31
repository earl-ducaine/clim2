
(defvar *method-names* nil
  "Holds the method names.  This is used to create the Gem interface
   macros.")


;;; Interface definitions
(defun find-or-create-name (name)
  (let ((pos (position name *method-names*)))
    (unless pos
      (if *method-names*
	  (setf (cdr (last *method-names*)) (list name))
	  (setf *method-names* (list name)))
      (setf pos (1- (length *method-names*))))
    pos))


(defparameter *calls-to-methods* '())

(defmacro gem-method (method-name args &body body)
  (let ((local-results (gensym)))
  `(setf (fdefinition ',method-name)
	 (lambda ,args
	   (let ((,local-results (progn ,@body)))
	     (push (list :args ,@args :results ,local-results)
		   *calls-to-methods*)
	     ,local-results)))))


(defmacro gem-method-alt (method-name (&rest args))
  (let ((function-name (intern (symbol-name method-name)))
	(has-rest (find '&rest args)))
    `(progn
       ;; Make sure the method name is defined when we load this.
       (find-or-create-name ,method-name)
       ;; Define the interface function itself, which will dispatch on
       ;; its first argument (a window) to find the appropriate
       ;; device-specific argument.
       (defun ,function-name (,@args)
	 (,(if has-rest 'APPLY 'FUNCALL)
	   (aref (g-value ,(car args) :METHODS)
		 ,(find-or-create-name method-name))
	   ,@(if (or has-rest (intersection '(&key &optional) args))
		 ;; We must manipulate the arguments list.
		 (do ((head args (cdr head))
		      (in-key NIL)
		      (final nil))
		     ((null head)
		      (nreverse final))
		   (case (car head)
		     ((&optional &rest))
		     (&key
		      (setf in-key T))
		     (T
		      (let ((symbol (car head)))
			(if (listp symbol)
			    (setf symbol (car symbol)))
			(if in-key
			    (push (intern (symbol-name symbol)
					  (find-package "KEYWORD"))
				  final))
			(push symbol final)))))
		 ;; Arguments list is OK as is.
		 args)))
       ;; Export the interface function from the Gem package.
       (eval-when (:execute :load-toplevel :compile-toplevel)
	 (export ',function-name)))))


(gem-method :CREATE-WINDOW
	    (parent-window x y width height
	     title icon-name background border-width
	     save-under visible
	     min-width min-height max-width max-height
	     user-specified-position-p user-specified-size-p
	     override-redirect))
